# Feature menu

Rank = importance ×2 − effort − risk (low 0, med 1). Modes: **report** (never changes anything), **ask** (writes a proposal; acts only on approval), **auto** (acts on its own; reversible). "ask / auto" means ask by default, and auto only if the user chose hands-off for that job. Schedules: hourly, 6h, daily, weekly, monthly, mount, on demand. Defaults are starting points; confirm them with the user.

## Storage
| id | Feature | What it does | Schedule | Mode | Thresholds |
|---|---|---|---|---|---|
| sentinel | Space sentinel | Usable space, swap and biggest memory footprints; notification at each threshold | hourly | report | warn 40 GB, critical 20 GB usable; swap 10 GB; process 10 GB |
| leaks | Known-leak registry | One check per item in known-leaks.md, with growth per day | every 6 h | report | growth over 2 GB/day |
| growth | What-grew report | Size snapshot of `~`, `~/Library` and dev folders 3 levels deep, diffed against 1 and 7 days ago | daily 05:30 | report | over 2 GB; keep 60 days |
| caches | Rebuildable-cache sweep | Allowlist only: npm/uv/pip caches, old DerivedData, old DeviceSupport (never any AI tool's caches or models, rule 4); `brew cleanup` and `simctl delete unavailable` as [YOU RUN] commands | weekly | ask | DerivedData > 14 days; only above 3 GB total |
| photoq | Photos search-queue watch | Size and growth of the never-consumed Photos search journals (inside the library, so read only). Above the threshold, tell the user; any trim is theirs to decide, with Photos quit | weekly | report | queue over 3 GB |

## Files
| id | Feature | What it does | Schedule | Mode | Thresholds |
|---|---|---|---|---|---|
| downloads | Downloads and Desktop triage | Old Downloads into `Downloads/Archive/YYYY-MM`; old installers to the Trash; Desktop screenshots into dated folders | daily | ask / auto | archive after 30 days; installers after 7 |
| tiers | Archive to an external drive | Queue of cold, large files; when the named drive is plugged in, copy, then re-read the copy from the drive and compare checksums, and only then Trash the original. Keep the drive's index at `state/drive-index.json` and suggest a second copy of anything that exists only on the drive | monthly + mount | ask | untouched 180 days, over 50 MB |
| recognize | Recognize and rename documents | New PDFs and scans: on-device OCR (Apple Vision) + a local model propose "YYYY-MM-DD Party · Type · Subject.pdf" and a folder; approve in batches | hourly | ask | always ask (optionally auto-apply only when the model's confidence is above a % the user sets) |
| ocr | Make scans searchable | Image-only PDFs get a text layer (ocrmypdf) as a new file; the original goes to the Trash only after the new file opens and its page count matches | daily | ask / auto | — |
| search | Ask-your-files search | Local embeddings (Ollama) over Documents, Downloads and the drive index; `<name> find "<question>"` | daily index | report | — |
| dupes | Duplicate report | Content-identical files outside protected folders, aware of APFS clones and hard links; never deletes | monthly | report | ignore under 5 MB |
| screenshots | Screenshot knowledge | OCR + classify every screenshot (recipe, receipt, address, event, product, how-to, contact…), extract the facts into a searchable digest, and a weekly "things you probably meant to do" (add to calendar, save contact, buy) | daily (backlog newest first, capped per day) | report | cap 400/day |

## Photos
| id | Feature | What it does | Schedule | Mode | Thresholds |
|---|---|---|---|---|---|
| pdupes | Photos duplicates | Count of Photos' Duplicates album plus near-identical bursts (osxphotos, read-only); merging stays inside Photos | monthly | report | — |
| pshots | Screenshots in Photos | Old screenshots go into a "Screenshots to review" album on approval, for bulk deletion inside Photos | monthly | ask | older than 60 days |
| optimize | iCloud Optimize check | Photos and iCloud Drive set to Optimize Mac Storage; Photos preview-cache size | weekly | report | — |

## Memory and system
| id | Feature | What it does | Schedule | Mode | Thresholds |
|---|---|---|---|---|---|
| daemons | Daemon leak watch | Any process over N GB is named (folded into the sentinel) | hourly | report | 10 GB |
| restart | Restart and update nudge | Long uptime, a staged macOS update, a browser updated but not relaunched | daily | report | 10 days uptime |
| health | SSD and battery health | SSD wear and TB written (smartctl), battery cycles and condition, as a trend | weekly | report | wear 50% |

## Security
| id | Feature | What it does | Schedule | Mode | Thresholds |
|---|---|---|---|---|---|
| persist | New background item alert | LaunchAgents/Daemons, privileged helpers and login items diffed against a baseline; each new one named with its signer | every 6 h | report | — |
| posture | Security posture | FileVault, firewall, Gatekeeper, SIP, XProtect age, Remote Login; deep links to fix | weekly | report | XProtect older than 21 days |
| firewall | Network and background-item protection | Explain what an outbound firewall and a background-item (persistence) blocker do, and help the user choose and install one they trust if they want it. Nothing to build | once | — | — |
| browser | Browser extension watch | Extensions per Chrome/Safari profile; flags new ones. Never clears cookies or history | weekly | report | — |

## Apps
| id | Feature | What it does | Schedule | Mode | Thresholds |
|---|---|---|---|---|---|
| uninstall | Uninstall with leftovers | `<name> uninstall <App>` finds every file tied to the bundle id, Trashes them with a manifest; `restore` puts them back | on demand | ask | — |
| orphans | Leftovers of removed apps | Support/cache/container folders whose app is gone, with sizes | monthly | report | over 50 MB |
| updates | One update list | Homebrew, App Store (mas) and macOS updates in one list | weekly | report | — |
| unused | Unused apps | Not opened in N days, with support-folder size | monthly | report | 120 days |

## Dashboard
| id | Feature | What it does | Schedule | Mode | Thresholds |
|---|---|---|---|---|---|
| report | Report command | `<name> report`: one summary of every job's latest result, every number dated | weekly + on demand | — | — |
| menubar | Menu-bar app | Native SwiftUI status icon and menu (see menu-bar-app.md) | always | — | — |
| digest | Daily digest | One short line in a daily note or message, only when something is yellow or red | daily | report | — |
| second | Second Mac | The read-only checks over `ssh <alias>`, reported beside this Mac | weekly | report | — |
| kitcheck | Kit update check (on by default) | Weekly, one plain request for the kit's newest version file; if newer, a yellow line saying what's new and how to update. Never downloads or changes anything | weekly | report | — |
| weekly-claude | Weekly AI check | A scheduled Claude Code task that reads `<name> report`, lists open proposals and summarizes; read-only | weekly | report | — |
