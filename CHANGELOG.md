# Changelog

Newest first. Each release says what changed in the kit and, under **For tools built from an earlier version**, what an AI agent should offer to add or change in an existing tool. Every item there is opt-in and goes through the same warnings and gates as a new build.

## 1.5.0 — 2026-11-02
- **New theme: Pro.** A dense, businesslike admin-console look: flat white or graphite cards, hairline borders, one blue accent, thin rings and sparklines, no motion. Follows light and dark mode. Suggested first for anyone who wants a work tool rather than a show piece. (Requested by a friend who built their own.)

- **Background fixes from real use:** every theme paints an opaque backdrop (one that followed the system was see-through in settings and windows), no status-colour wash (it became a muddy band on dark themes), decorations kept clear of controls and skipped on small tiles, and an Appearance setting (System / Light / Dark) for themes that follow the system.

**For tools built from an earlier version:**
1. Recommended for any menu-bar app: apply the four new "Rules every theme must follow" at the top of that section in `reference/themes.md` (opaque backdrops, no status wash, decorations clear of controls, Appearance setting). Touches: the backdrop view, the theme picker and settings.
2. Optional: add the Pro theme from `reference/themes.md` (a new theme spec plus any new gauge/chart styles it needs). Touches: the app's theme catalog and views only; run the green/yellow/red check afterwards.

## 1.4.0 — 2026-11-02 — reliability audit
A full audit of the original app this recipe comes from found the problems below; the recipe now tells your AI to build it right the first time.
- **Scheduler:** every job isolated (one crash never stops the rest), the space sentinel runs first, missed runs (Mac off at the scheduled time) are caught up, a cadence never overlaps itself, and command time limits really stop runaway helpers.
- **No false alarms, no false all-clears:** new safety rule 14. Unreadable is "unknown", not green; normal setups (Apple-signed or Homebrew tools, script wrappers) are yellow, not red; new background items stay flagged until acknowledged.
- **Safer file handling:** every move gets the in-use check, drive copies use a verified `.partial` file, and OCR temp files are always cleaned up.
- **Privacy:** new safety rule 15. Codes and passwords are dropped from screenshot and scan text.
- **Menu-bar app:** one fixed window size (no jumping between tabs or screens), sizes from content, clamps to the smallest screen, scrolls instead of clipping, delayed confirm buttons, dry-run-only quick runs, no work inside view drawing, and NaN guards.

**For tools built from an earlier version** (each is opt-in; 1 and 2 matter most):
1. Scheduler: isolate each job, run the sentinel first, add missed-run catch-up and a per-cadence lock, and kill commands by process group on timeout (architecture.md, "Running jobs reliably"). Touches: the entry script and the shared command runner.
2. Add rules 14 and 15 to the tool's AGENTS.md, then fix any check that shows green when it couldn't read something, or red for an ordinary setup; make new background items stay flagged until acknowledged; drop codes and passwords from stored OCR text. Touches: the checks involved and the OCR/screenshot job.
3. File handling: add the in-use check to every move, `.partial` drive copies, OCR temp cleanup, keep un-approved items waiting (architecture.md, "Files the tool moves").
4. Menu-bar app: apply "Window stability", "Motion and performance" and "Actions" in menu-bar-app.md, then rerun the green/yellow/red check.
5. Log trimming, and an installer that writes agent paths from the repo's current location.

## 1.3.2 — 2026-11-02 — URGENT fix for menu-bar apps
- **Bug fixed in the recipe:** 1.3.0 and 1.3.1 said the menu-bar icon could pulse while something is red. On macOS 27 an animated menu-bar icon can loop forever: the app spins at 100% CPU, its memory grows by gigabytes a minute (one build reached 17 GB and pushed 20 GB into swap), and the menu never opens. It only happens while a check is red, so it's easy to miss.
- The recipe now forbids any animation in the menu-bar icon (new safety rule 13) and requires a green/yellow/red test with CPU and memory numbers before the menu-bar app counts as done.

**For tools built from an earlier version (do this first, even if nothing else):**
1. **Urgent if your tool has a menu-bar app:** remove any `TimelineView`, animation, `.symbolEffect` or timer-swapped image from the menu-bar label so the icon is a still image tinted by status. Add rule 13 from `reference/safety-rules.md` to the tool's AGENTS.md. Then run the app in a red state with the menu closed for 60 seconds and confirm CPU near 0% and flat memory. Touches: the app's menu-bar label view and AGENTS.md.

## 1.3.1 — 2026-11-01
- **New home:** the recipe now lives at github.com/kempt-kit/kempt, and the setup page at kempt-kit.github.io/kempt.

**For tools built from an earlier version:**
1. Point the update check at the new address: set `latest` to `https://raw.githubusercontent.com/kempt-kit/kempt/main/kit.json` and `home` to `https://github.com/kempt-kit/kempt` in config/picks.json. Touches: config/picks.json only.

## 1.3.0 — 2026-11-01
- **Theme menu:** eleven complete looks for the menu-bar app (Native, Vector, Synthwave, Glass, Press, Amber CRT, Moss, Atelier, Blueprint, Sorbet, Abyss), each with its own type, backdrop, gauge, chart and motion, plus the rules every theme must follow (contrast, battery, Reduce Motion).
- **Command center:** the main menu screen becomes a full dashboard: per-core CPU, memory, GPU, temperatures and fans, disk and network rates, battery health, uptime, top processes, and safe actions (quit an app with confirmation, run checks).

**For tools built from an earlier version:**
1. Add any themes from `reference/themes.md` the user picks. Touches: the app's theme catalog and views only.
2. Add the command center screen. Touches: the menu-bar app only; read-only except the confirm-to-quit action.

## 1.2.0 — 2026-11-01
- **Renamed to Kempt** (formerly Upkeep Kit). The repo moved to github.com/kempt-kit/kempt; old links redirect.
- **Setup page:** https://kempt-kit.github.io/kempt/ turns a few clicks into one ready-to-paste prompt. It runs only in the browser and sends nothing.
- **Pre-filled answers:** the recipe accepts the page's `KEMPT SETUP ANSWERS` block and skips those questions, while still showing every warning.
- **Default app name is Kempt,** changeable during setup or later.

**For tools built from an earlier version:**
1. Point the update check at the new address: set `latest` to `https://raw.githubusercontent.com/kempt-kit/kempt/main/kit.json` and `home` to `https://github.com/kempt-kit/kempt` in config/picks.json. Touches: config/picks.json only.

## 1.1.0 — 2026-11-01
- **AI tools' files are protected.** Every build finds the AI tools installed (local models, coding agents, desktop AI apps, and the agent doing the build) and adds their folders to the protected list. Nothing ever moves, trims or "cleans" them.
- **Files in use are never moved.** Any file a process has open, or that changed in the last 10 minutes, is skipped.
- **Update check is on by default,** disclosed in the opening warning, and easy to turn off.

**For tools built from an earlier version:**
1. Add rule 4 (AI tools' files) and rule 4a (files in use) from `reference/safety-rules.md` to the tool's AGENTS.md; detect installed AI tools and add their folders to the protected list; make every job that moves files skip open and recently changed files. Touches: AGENTS.md, the protected-folder guard, the Trash helper, and tests.
2. Offer to turn on the weekly kit update check if it's off. Touches: config/picks.json, one weekly job.

## 1.0.0 — 2026-11-01
First release.
- Recipe for any AI coding agent, plus a read-only chat path.
- Quick setup (read-only checks and a menu-bar app) or full choice of 30 features.
- Safety rules, known macOS leaks, architecture, menu-bar app guide.
- Opt-in update check and an update flow for tools built from this kit.

**For tools built from an earlier version:** nothing (first release).
