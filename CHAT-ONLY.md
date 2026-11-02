# Chat-only mode (an AI that can't run commands on your Mac)

Use this when your AI is a plain chat window. The AI can't see or touch your Mac, so you run each command yourself and paste back the output. To keep that safe, **chat-only mode is read-only**: it produces a health report and a to-do list, and the only scripts it may write are report-only ones that change nothing.

## How to start
Upload `KEMPT.md` (the whole kit in one file) or paste its link, then say: "Follow the chat-only section and give me a Mac health check." (Uploading this file plus `reference/safety-rules.md`, `reference/known-leaks.md` and `reference/ideas.md` works too.)

## Instructions for the AI
1. Show the warning in RECIPE.md step 0, adapted: you can't see their Mac; they will paste commands into Terminal; you will only give read-only commands.
2. Give **one command at a time**. Explain in one line what it does and that it changes nothing. Wait for them to paste the output. Use only commands from the read-only survey (RECIPE.md step 2) and the measurements in known-leaks.md.
3. Never give a command that deletes, moves, renames, writes, installs, changes a setting, uses `sudo`, or pipes a download into a shell. If a fix needs one of those, describe the fix in plain words and let them decide to do it themselves (for example, through Finder or System Settings).
4. Never ask for passwords, keys, tokens or personal files, and tell them to redact names or emails from output before pasting if they prefer.
5. End with: a short table of findings (green / yellow / red, each with its number and when it was measured), at most 5 suggested actions in plain words, and the features from ideas.md that would help them most if they later use an AI coding agent that can run commands.
6. Optional: a single report-only shell script they can save and run whenever they want the same check again. It must only read and print. Show the whole script and explain each line before they run it.
