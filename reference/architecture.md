# Architecture

A small, boring layout that has held up well. `<name>` is the user's tool name.

```
<name>/
  bin/<name>              one entry point: <name> <job> [--dry-run] [--json] [args]
  lib/<name>/core.py      paths, run() with timeouts, usable space, notify(), Result, latest.json
  lib/<name>/trash.py     Finder Trash + manifest, restore, proposals
  jobs/<job>.py           one file per job, each exposing run(ctx) (and apply_item for ask-first jobs)
  config/picks.json       the user's picks: on/off, schedule, mode, thresholds per job
  launchd/*.plist         one LaunchAgent per cadence, plus install.sh [YOU RUN]
  state/                  gitignored: baselines, snapshots, proposals, indexes
  tests/                  unittest, fixture home folder via env overrides, no real paths
  app/                    optional SwiftUI menu-bar app
```

## Commands
- `<name> <job> [--dry-run]` runs one job. `--dry-run` measures and prints, and writes nothing (no logs, no baseline, no notification, no moves).
- `<name> cadence hourly|6h|daily|weekly|monthly|mount` runs every picked job due at that cadence; this is what each LaunchAgent calls.
- `<name> list` shows jobs, schedule, mode. `<name> report` summarizes every job's latest result.
- `<name> apply` lists open proposals; `<name> show <id>`; `<name> apply <id> [--only 1,3]`.
- `<name> restore` lists recent Trash moves; `<name> restore <n>` puts one back.

## Job contract
A job module looks like this (Python):
```python
def run(ctx):            # ctx.dry_run: bool, ctx.args: list[str]
    res = core.Result("downloads")             # collects flags and data
    res.flag("Downloads", core.YELLOW, "249 items older than 30 days", action="proposal downloads-…")
    return res                                 # core saves log + latest.json unless dry_run

def apply_item(item, dry_run):                 # ask-first jobs only; called by `apply` per approved item
    ...                                        # raise trash.Refused("why") to skip safely
```
Each run writes `~/Library/Logs/<name>/<job>.log` (human lines) and `~/Library/Logs/<name>/latest/<job>.json`:
`{job, machine, ts, dryRun, status, flags:[{item, status: green|yellow|red, value, action?}], data:{}}`.
The report, the menu-bar app and any dashboard read only these files.

## Proposals (ask-first jobs)
`state/proposals/<job>-<timestamp>.json`: `{id, job, created, status: open|applied|superseded, note, items:[{path, kb, action, sig:[size, mtime, inode]}], commands:[]}`, where `sig` is integers from `os.lstat`: size in bytes, mtime in whole epoch seconds, inode number. One open proposal per job; a newer scan supersedes it. Post one macOS notification only when a proposal is new or gains items (hourly jobs would otherwise nag). `apply` re-checks each item's signature and the protected-folder guard before acting.

## Useful snippets
Usable space in GB:
```bash
osascript -l JavaScript -e 'ObjC.import("Foundation");var u=$.NSURL.fileURLWithPath("/");var r=u.resourceValuesForKeysError(["NSURLVolumeAvailableCapacityForImportantUsageKey"],null);(r.objectForKey("NSURLVolumeAvailableCapacityForImportantUsageKey").js/1e9).toFixed(1)'
```
Notification:
```bash
osascript -e 'display notification "text" with title "<Name>: needs your OK"'
```
Timeout wrapper: `perl -e 'alarm 120; exec @ARGV' du -sk PATH`.
Count your agents (a login item also appears in `launchctl list` as `application.<bundle id>…`, so match the labels exactly):
```bash
launchctl list | grep -cE 'com\.<you>\.<name>\.(hourly|6h|daily|weekly|monthly|mount)$'
```

## Running jobs reliably
- **Isolate every job completely.** Import, run and save each job inside its own error handling, so one broken or crashing job is recorded as "job crashed" and the rest of its cadence still runs. A malformed settings file or a full disk must not silence the space alarm.
- **Run the space sentinel first** in its hour; slow jobs (OCR, local AI) go after it.
- **Catch up missed runs.** launchd skips a calendar run missed while the Mac was off or restarting, so a Mac that's off at 05:30 silently loses that day. Record when each cadence last finished; each hourly run starts any daily (over 26 h), weekly (over 8 days) or monthly (over 32 days) run that's overdue.
- **Never overlap a cadence with itself:** take a non-blocking lock file per cadence and skip if it's held.
- **Time limits that really stop things:** run each command in its own process group, and on timeout kill the whole group (helpers a command starts can outlive a simple alarm and hang the run).
- **Keep files bounded:** trim the tool's own logs (for example, over 2 MB keep the newest 1 MB) and drop old closed proposals. Never trim the Trash manifest; restore needs every line.
- **Install agents from wherever the repo is:** the install script writes the plists with the repo's current path and the user's home, so moving the folder needs only a re-run of the installer.

## Files the tool moves
- Every move (not just Trash moves) re-checks the protected-folder guard and skips anything open or changed in the last 10 minutes.
- Record every move in the manifest, even when Finder doesn't report where it put the item.
- Copies to a drive go to `<name>.partial`, are verified by re-reading them, and only then renamed and the original trashed; any failure removes the partial copy, so retries aren't blocked.
- Rewrites (OCR) check that the file is quiet before starting, and remove their temporary file on any failure.
- Approving only some items of a proposal leaves the rest waiting in a new proposal, never silently marked done.

## LaunchAgents
One plist per cadence (`StartInterval` 3600 for hourly, `StartCalendarInterval` for daily/weekly/monthly, `StartOnMount` for the drive job), running `/usr/bin/python3 <repo>/bin/<name> cadence <c>` with stdout/stderr to the logs folder. `StartOnMount` fires for any volume, so the mount job itself checks `/Volumes/<drive name>` exists and exits quietly otherwise. A calendar run missed while the Mac sleeps runs once on wake; one missed while it is powered off is skipped. So jobs must not assume they ran yesterday: diff against the newest snapshot, whatever its age. Renaming or moving the repo breaks the plist paths, so ship a script that swaps old agents for new ones.

## A second Mac
Run the read-only subset over `ssh <alias>` with a single heredoc script that prints `key=value` lines; parse locally. Never copy bulk data over a relayed connection.
