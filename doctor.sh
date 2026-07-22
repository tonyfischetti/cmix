#!/usr/bin/env bash
# cmix doctor — check that this machine's cmus setup works.  Reports,
# never mutates, exits nonzero if something is wrong.  Invoked by
# `make doctor`.

CMIX="$(cd "$(dirname "$0")" && pwd)"
UNAME_S="$(uname -s)"

green="\033[32m"; red="\033[31m"; yellow="\033[33m"; bold="\033[1m"; off="\033[0m"
fail=0
ok()   { printf "  ${green}✓${off} %s\n" "$1"; }
bad()  { printf "  ${red}✗ %s${off}\n" "$1"; fail=1; }
warn() { printf "  ${yellow}! %s${off}\n" "$1"; }

printf "${bold}cmix doctor${off} (%s)\n" "$UNAME_S"

# --- the repo must BE ~/cmus (CMUS_HOME, exported by zix's .zshrc) ---
[ "$CMIX" -ef "$HOME/cmus" ] \
  && ok "repo is ~/cmus (where CMUS_HOME points)" \
  || bad "repo is at $CMIX, not ~/cmus — cmus won't see this config"

if [ -n "$CMUS_HOME" ] && ! [ "$CMUS_HOME" -ef "$HOME/cmus" ]; then
  bad "CMUS_HOME is set to $CMUS_HOME (expected ~/cmus)"
fi

# --- the music the playlists assume ---
[ -d "$HOME/music" ] \
  && ok "~/music exists" \
  || warn "~/music missing — the playlists assume it (make setup)"

# --- the patched cmus ---
if [ -x /usr/local/bin/cmus ]; then
  ok "patched cmus installed ($(/usr/local/bin/cmus --version 2>/dev/null | head -1))"
  resolved="$(command -v cmus)"
  [ "$resolved" = "/usr/local/bin/cmus" ] \
    && ok "PATH resolves cmus to the patched build" \
    || warn "PATH resolves cmus to $resolved (not the patched build)"
  command -v cmus-remote >/dev/null \
    && ok "cmus-remote on PATH (tmix's ltunes.pl wants it)" \
    || warn "cmus-remote not on PATH"
else
  bad "patched cmus missing from /usr/local/bin (make setup)"
fi

echo
if [ "$fail" -eq 0 ]; then
  printf "${green}${bold}all good.${off}\n"
else
  printf "${red}${bold}problems found — see above.${off}\n"
fi
exit "$fail"
