# Theme menu (for the menu-bar app)

Offer these during phase 4. The user can pick one, several, or all; build each as a **whole look**, not a color swap. Every theme sets: typeface style, palette, backdrop, card surface, the main gauge, the chart style, icon style, meters, and motion. Write each theme as data (a theme spec with every token), so adding one never touches the views.

Use only fonts that ship with macOS (pick one matching the style named below), or the system font.

| Theme | Mood | Type | Backdrop and cards | Main gauge | Chart | Motion |
|---|---|---|---|---|---|---|
| **Native** | Follows light and dark mode | System font | System materials, soft cards | Plain ring | Line | Standard |
| **Vector** | Old vector-display wireframe | Monospace, uppercase, wide tracking | Black with green wire grid; outlined cards, no corners | Spinning wireframe globe | 3D wireframe terrain of free space | Stepped, ~12 fps, a floor rolling toward you |
| **Synthwave** | 1980s at midnight | Condensed heavy geometric sans, uppercase | Striped sunset sun over a neon grid; hot-pink glass cards | Neon segmented ring | 3D bars | Bouncy |
| **Glass** | Frosted panes over drifting light | Rounded sans; ultra-light numerals | Slow drifting colored orbs; translucent cards that tilt in 3D under the pointer | Liquid orb filling to the free-space level | Glossy area | Floating |
| **Press** | Brutalist newsprint | Condensed black sans, giant condensed numerals | Warm paper with halftone; white cards, thick black borders, hard offset shadows; one red | Solid block bar | Step bars | None: hard cuts only |
| **Amber CRT** | 1983 terminal | Monospace bold, uppercase | Amber phosphor on near-black with scanlines | ASCII bar `[#####-----]` | Oscilloscope trace | Typewriter text |
| **Moss** | Soft and organic | Humanist sans titles, old-style serif numerals | Sage and clay; pebble-shaped cards, no borders | A blob that breathes | Smooth flowing area | Slow, organic |
| **Atelier** | Calm editorial | High-contrast serif (Didone style) | White space, paper texture, hairline rules, one bronze accent | Hairline dial with a needle | Hairline line | Slow, minimal |
| **Blueprint** | Drafting table | Condensed technical sans, uppercase, wide tracking | Cyanotype blue with a drafting grid; dashed outlines | Protractor | Isometric ribbon chart | Precise, ruled |
| **Sorbet** | Loud and happy | Rounded bold | Pastel confetti; chunky outlined cards; sticker icons | Fat donut | Candy bars that bounce in | Springy |
| **Abyss** | Deep ocean | Light humanist sans, uppercase, wide tracking | Dark teal depths with rising bioluminescent particles | Sonar sweep showing free space | Light particles flowing along the line | Slow drift |

## Rules every theme must follow
- **Readable:** status text and numbers meet WCAG AA contrast in every theme; status is never shown by color alone (an icon or word too).
- **The menu-bar icon never animates in any theme** (it caused a runaway loop; see menu-bar-app.md). Themes animate only inside the opened menu and windows.
- **Light on battery:** animate only while the menu or a window is visible; near 0% CPU when closed. Cap frame rates (most themes 8–12 fps; Press, Atelier, Blueprint and Sorbet need no continuous animation).
- **Reduce Motion and Reduce Transparency** turn motion and glass off in every theme.
- **Switching themes** is a saved preference only: no relaunch, no new process.
- Keep a test that every theme defines every token and passes the contrast check.

## The command center (main menu screen)
A dense, theme-styled dashboard, all read locally without admin rights:
- **CPU:** load per core (performance and efficiency cores shown separately). Clock speed needs admin tools on Apple silicon; say so rather than guess.
- **Memory:** pressure, used/wired/compressed, swap.
- **GPU** load.
- **Temperatures and fans:** CPU, GPU, SSD and battery temperatures from the system's sensor service, and fan speeds, read only. If a sensor can't be read on this Mac, show "not available", never a made-up number.
- **Disk:** usable space, read/write rate, SSD wear.
- **Network:** up/down rate.
- **Battery:** charge, health, cycle count, power draw.
- **Uptime** and time since the last restart, thermal state, top processes by CPU and by memory.
- **Actions:** quit a chosen app (confirm; force quit needs a second confirm), "quit the biggest app you're not using", restart a browser that updated but wasn't relaunched (ask first), run checks now, act on open proposals. Never a "free memory" button, never `sudo`, never writes to fans or sensors.
- Sample every 1–2 s only while the menu is open; stop when it closes.
