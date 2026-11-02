#!/bin/bash
# Pushes the kit to github.com/kempt-kit/kempt as the kempt-publisher GitHub
# App, so no personal account appears in the repo's activity. The app's
# private key stays on the maintainer's Mac; the short-lived token is never
# printed.
#   bash tools/publish.sh                 push HEAD to main and tag v<kit.json version>
#   bash tools/publish.sh --enable-pages  also turn on GitHub Pages from /docs (first publish)
set -euo pipefail
cd "$(dirname "$0")/.."
APP_ID="${KEMPT_APP_ID:-5574475}"
KEY="${KEMPT_APP_KEY:-$HOME/.ssh/kempt-publisher.pem}"
ORG=kempt-kit
REPO=kempt
[ -r "$KEY" ] || { echo "no app key at $KEY"; exit 1; }

b64url() { openssl base64 -A | tr '+/' '-_' | tr -d '='; }
now=$(date +%s)
hdr=$(printf '{"alg":"RS256","typ":"JWT"}' | b64url)
pay=$(printf '{"iat":%d,"exp":%d,"iss":"%s"}' $((now - 60)) $((now + 540)) "$APP_ID" | b64url)
sig=$(printf '%s.%s' "$hdr" "$pay" | openssl dgst -sha256 -sign "$KEY" | b64url)
jwt="$hdr.$pay.$sig"
api() { curl -fsS --max-time 30 -H "Accept: application/vnd.github+json" "$@"; }

inst=$(api -H "Authorization: Bearer $jwt" https://api.github.com/app/installations |
  python3 -c "import json,sys; print(next(i['id'] for i in json.load(sys.stdin) if i['account']['login']=='$ORG'))")
tok=$(api -X POST -H "Authorization: Bearer $jwt" "https://api.github.com/app/installations/$inst/access_tokens" |
  python3 -c 'import json,sys; print(json.load(sys.stdin)["token"])')

ver=$(python3 -c 'import json; print(json.load(open("kit.json"))["version"])')
git rev-parse -q --verify "refs/tags/v$ver" >/dev/null || { echo "tag v$ver missing: tag the release commit first"; exit 1; }

auth=$(printf 'x-access-token:%s' "$tok" | openssl base64 -A)
GIT_CONFIG_COUNT=1 GIT_CONFIG_KEY_0="http.https://github.com/.extraheader" GIT_CONFIG_VALUE_0="AUTHORIZATION: basic $auth" \
  git push -q "https://github.com/$ORG/$REPO.git" "HEAD:refs/heads/main" "refs/tags/v$ver"
echo "pushed main and v$ver as kempt-publisher"

if [ "${1:-}" = "--enable-pages" ]; then
  api -X POST -H "Authorization: Bearer $tok" "https://api.github.com/repos/$ORG/$REPO/pages" \
    -d '{"source":{"branch":"main","path":"/docs"}}' >/dev/null && echo "pages enabled"
fi
