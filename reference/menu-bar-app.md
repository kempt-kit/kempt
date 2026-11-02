# Optional: the menu-bar app

A thin native front end over the tool. It never re-implements a check or touches files itself: it reads `~/Library/Logs/<name>/latest/*.json` and acts only by running `bin/<name>` commands.

## v1
- Menu-bar icon: a **still** image tinted by the worst status. It never animates, not even when red (see the first pitfall).
- Header: usable GB, swap, memory pressure, last check time; every number shows its age.
- Yellow and red items grouped by job, each with its value and suggested action.
- "Waiting on you": open proposals. Approve runs `<name> apply <id>` only after a second confirm click that shows exactly what will happen.
- Run check now, refresh, open logs, search (`<name> find`).
- Settings view: FileVault, firewall, Gatekeeper, SIP, Remote Login, Spotlight; each row only deep-links to its System Settings pane. The app never changes a system setting.
- Themes that each change the whole look (typeface, color, materials, chart style, motion), with a live preview. Offer the menu in `themes.md`.
- The command center main screen described in `themes.md`.

## Engineering
- SwiftUI `MenuBarExtra` (window style), Swift Package in `app/`, ad-hoc signed, installed to `~/Applications/<Name>.app`. Build with `swift build -c release`, assemble the `.app` bundle (Contents/MacOS binary, Info.plist with `LSUIElement` true and the bundle id `com.<you>.<name>`), then `codesign --force --deep -s - <Name>.app`. Write this as `app/build.sh` and test it.
- Run commands with `Process`, an argument array (no shell string built from user text) and a timeout.
- Tests: JSON parsing and status roll-up from fixture files; theme tokens complete and readable.

## Pitfalls found the hard way
- **Never animate the menu-bar icon.** No `TimelineView`, `.symbolEffect`, animation, or timer-swapped image anywhere inside the `MenuBarExtra` label. The menu-bar host rebuilds the label every time its image changes, so a pulse there restarts itself forever: the app pins a CPU core at 100%, its memory grows by gigabytes a minute (one real build reached 17 GB and pushed 20 GB into swap), and the menu never opens. It only shows up while something is red, so ordinary testing misses it. Animate only inside the opened menu window.
- SwiftUI's built-in `Settings` scene silently fails in menu-bar-only apps; open a regular window instead.
- A System Settings deep link that opens a sheet (e.g. some Sharing sub-panes) makes System Settings ignore later links until the sheet closes; link to the pane, not the sheet.
- Screenshot tools often can't capture menu-bar-only windows; render views offscreen to PNG for checks.
- "Open at Login" via `SMAppService` is persistence: the user turns it on.
- Changing the bundle id resets the login item and saved preferences.

## Window stability (the menu window is anchored at its bottom edge)
Any change in the window's size moves its top edge away from the menu bar, so the menu appears to jump:
- **One fixed size for every screen and tab.** Size it to the tallest content the menu shows (measure each tab's natural height and remember the largest), not to the screen; a screen-height guess leaves a huge empty window on tall monitors. Narrower screens (confirm, settings, search results) center their content inside the same size.
- **Clamp to the smallest screen** (`NSScreen.screens`), not `NSScreen.main`, which is whichever screen has the focused window: a laptop plus an external display otherwise gives a menu taller than the laptop screen.
- **Status lines that come and go** (a progress bar, a notice) live in a fixed-height slot or an overlay, never above the content where they push it.
- **Anything that can grow** (a list of proposals, a long dry-run output, a settings grid) scrolls inside its area, with the action buttons pinned outside the scroll so "Approve" can never be pushed off screen.
- The settings window is resizable and fits a 13-inch screen (about 800 points of usable height).

## Motion and performance
- Animations run only while their window is visible and Reduce Motion is off. That includes separate windows (a job detail window left open behind others must stop animating), not just the menu.
- Never change observed state while a view is being drawn (assigning a shared theme, publishing from a visibility probe); defer it (`DispatchQueue.main.async`). Today's loop and tomorrow's stutter both start there.
- Read files, parse settings and look up file icons once per refresh in the model, never inside view bodies (they redraw every few seconds; an icon for a path on a sleeping external drive stalls the menu).
- Guard every gauge and meter fraction with `isFinite` and clamp thresholds above zero on load: a 0/0 becomes NaN, and converting NaN to an integer crashes the app.

## Actions
- Every action that changes something (approve, quit, force quit) needs a real second confirmation. A confirm button that appears under the cursor turns a double-click into a yes: keep it disabled for about 0.8 s after it appears.
- A "run one check" menu runs jobs that move files only as a dry run (say so in the menu), or routes them to the confirm screen.
- One command at a time, everywhere: a job window's dry-run goes through the same lock as the menu's buttons.
- Pass user text to commands after `--` (a search for "-v" must stay a search).

## Guardrails
- Near 0% CPU when closed: animate only inside the opened menu or windows (pause `TimelineView` when hidden), never in the menu-bar label, and no polling faster than the file watcher needs.
- **Required check before the app counts as done:** launch the real installed app once in each status (green, yellow and red, using fixture results or a `--status` test switch), leave the menu closed for 60 seconds each time, and confirm CPU stays near 0% and memory stays flat (`ps -o %cpu=,rss= -p <pid>` every few seconds). Report the numbers. A red-only failure is the most likely kind.
- Respect Reduce Motion and Reduce Transparency; status never told by color alone; AA contrast in every theme.
- No network. No "free memory" button.
