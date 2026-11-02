# AGENTS.md — Kempt

Instructions for any AI coding agent opened in this folder (Claude Code, Codex, Gemini CLI, Cursor, GitHub Copilot and others).

This folder is a recipe, not an app. When the user asks to build their computer care tool (or anything like it), follow `RECIPE.md` step by step, starting with step 0 (the warning).

- The user's own tool is built in a NEW folder (default `~/Developer/<name>`), never inside this kit. Leave this kit unchanged so it can be shared again.
- Read `reference/safety-rules.md` before writing any code, and copy its rules into the new project's instructions file (from `templates/AGENTS.md.template`).
- Ask choices as multiple choice, recommended option first.
- Label every step the user must do [YOU RUN] and every step you do [I RUN].
- Verify before calling anything done: run it, read its output, run the tests.
- The user may not be an engineer. Plain language, short reports, no jargon without a gloss.
- Never name, compare with, or make claims about any commercial software product in anything you write for the user's project. Describe what a feature does, not who else does it.
- If you cannot run commands on this Mac, follow `CHAT-ONLY.md` instead.
