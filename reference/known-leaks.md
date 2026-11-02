# Known macOS space and memory leaks

Things that quietly eat disk or memory on recent macOS. Each makes a good check: measure its size, track growth per day, flag above a threshold. Report only. The fix column is what you suggest to the user; the tool never does any fix that touches Mail, Photos, iCloud or system settings, the user does. Several of these paths need Full Disk Access to read; report "needs Full Disk Access" rather than failing.

| What | Where / how to measure | Why it grows | Suggested fix |
|---|---|---|---|
| Mail connection logging | `~/Library/Containers/com.apple.mail/Data/Library/Logs/Mail`; `defaults read ~/Library/Containers/com.apple.mail/Data/Library/Preferences/com.apple.mail` keys `LogActivityOnAllPorts`, `LogActivityToFile`, `LogDebuggingInformation` | Connection Doctor logging left on writes every IMAP byte: tens of GB a day. Some Mail plug-ins switch it on. | Quit Mail, set the keys to NO, user deletes the logs |
| Mail Drafts / All Mail caches (Gmail) | `~/Library/Mail/V*/*/[Gmail].mbox/Drafts.mbox`, `All Mail.mbox` | Old Gmail drafts re-sync endlessly; All Mail duplicates every message locally | Trash old drafts in Gmail; turn off "Show in IMAP" for All Mail; Mailbox → Rebuild |
| Mail BiomeStream | `~/Library/Mail/V*/MailData/BiomeStream` | Apple Intelligence mail feed, grows a few GB a month | Watch only |
| Photos search queue | `…photoslibrary/database/search/Spotlight/SpotlightKnowledgeEvents` | Journals written and never consumed; jumps after macOS updates | Report only; the tool never edits the library. The user decides on any trim (Photos quit first) |
| photolibraryd (and other daemons) | footprint in `top -o mem` | Can leak to tens or hundreds of GB and push swap onto disk | Quit Photos; the user restarts the daemon or the Mac |
| Swap | `sysctl vm.swapusage` | Any memory leak turns into disk use | Find the process; restart it |
| Chrome code-sign clones | count of `com.google.Chrome.code_sign_clone` folders under the per-user temp area (`/private/var/folders/*/*/X/` on recent macOS; find yours from `getconf DARWIN_USER_DIR`) | Chrome (or automated browser tests) relaunching while an update is pending | Restart Chrome after it updates; prefer a headless shell for automation |
| Staged macOS update | size of `/System/Volumes/Update`; `tmutil listlocalsnapshots /` (com.apple.os.update-*). Avoid `softwareupdate -l` in automated checks: it can start a download | A downloaded update plus its snapshots can hold 15–30 GB until installed | Install the update |
| iOS simulators | `~/Library/Developer/CoreSimulator/Devices`; `xcrun simctl list devices booted` | Old devices and app builds; a booted simulator left running | `xcrun simctl erase` / `shutdown` on approval |
| Xcode leftovers | `~/Library/Developer/Xcode/DerivedData`, `iOS DeviceSupport` | Rebuildable, regrows | Allowlisted cache sweep |
| Package caches | Homebrew (`brew --cache`), npm `~/.npm/_cacache`, uv/pip `~/.cache/uv`, `~/Library/Caches/pip` | Rebuildable | Allowlisted cache sweep; `brew cleanup` as a [YOU RUN] command |
| Messages temp | `~/Library/Containers/com.apple.MobileSMS/Data/tmp` | Temp copies of attachments | Report |
| iCloud Drive local copies | iCloud Drive with Optimize off; `~/Library/Caches/CloudKit/com.apple.bird` | Files stay local; the cache is purgeable | Turn on Optimize Mac Storage; never touch bird's files by hand |
| Spotlight indexes | `~/Library/Metadata/CoreSpotlight`; indexing of code folders | Code folders with node_modules inflate indexes | Add code folders to Spotlight → Search Privacy |
| Claude/agent scratch | `/private/tmp/claude-*`, agent transcripts in `~/.claude/projects` | Large renders and long sessions | Report; clears on restart |

Not leaks, never count them:
- `~/Library/Developer/CoreDevice/DeviceFS` is a mount of a connected iPhone.
- Some system daemons' containers point at the real Photos library.
- The Photos preview cache re-downloads when there's room; macOS counts it as purgeable.
