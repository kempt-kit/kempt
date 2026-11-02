# Maintaining the kit

## Publish a new version
1. Make the changes in the source files (never in `KEMPT.md`, which is generated).
2. Bump `version` and `released` in `kit.json` (semantic versioning: patch for wording fixes, minor for new features, major for anything that changes how existing tools work).
3. Add a `CHANGELOG.md` entry at the top, with a **For tools built from an earlier version** list: each item one opt-in change an agent can offer, saying which files or jobs it touches.
4. Run `bash tools/bundle.sh`.
5. Scan before publishing: no personal names, accounts, machine names, home-folder paths, email addresses, IPs or product names of other software makers beyond what's needed to say what the kit works with.
6. Commit, tag `v<version>`, then run `bash tools/publish.sh` (see below). The `release` workflow publishes the GitHub Release from the changelog, so people who "Watch → Releases" get an email.

## First publish
Set `home` in `kit.json` to the public page or repo, `latest` to a URL that returns the newest `kit.json` as plain text, and `bundle` to one that returns `KEMPT.md` as plain text (for a GitHub repo: `https://raw.githubusercontent.com/<owner>/<repo>/main/kit.json` and `…/main/KEMPT.md`). Run `bash tools/bundle.sh`; it writes the link into the README's one-line start prompt and into `KEMPT.md`. Tools only check for updates once `latest` is set.

## Reaching people with updates
- **Built-in:** tools whose owners opted in show a yellow "new version" line within a week.
- **GitHub:** Releases notify anyone watching the repo.
- **Your own channels:** a post or newsletter linking the changelog. The kit itself never contacts anyone.

## Pushing
Publish with `bash tools/publish.sh`. It pushes `main` and the tag `v<version>` as the kempt-publisher GitHub App (owned by the kempt-kit organization), so no personal username appears in the repo's activity, and the `release` workflow then publishes the Release as github-actions. The app's private key lives only on the maintainer's Mac at `~/.ssh/kempt-publisher.pem`. Commit as `Kempt <kit@example.invalid>`.
