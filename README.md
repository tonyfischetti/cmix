# cmix

## my cmus configuration file

This only works with cmus with patches applied

Grab the configurations (this repo must live at `~/cmus` — zix's
`.zshrc` exports `CMUS_HOME=$HOME/cmus`)...

    git clone https://github.com/tonyfischetti/cmix.git ~/cmus
    make -C ~/cmus deps      # build deps (apt build-dep / brew codecs)
    make -C ~/cmus setup     # ~/music + build the patched cmus if missing
    make -C ~/cmus doctor    # verify everything

The Makefile is the single source of truth.  Everything is
re-runnable: `setup` skips the build when the patched cmus is already
at /usr/local/bin (`make cmus` forces a rebuild — it builds the
default branch of github.com/tonyfischetti/cmus, which carries the
patches; goodies/ keeps the same changes as a patch file against
upstream 600fa4bbde for reference).

Music lives in `$HOME/music` (the playlists assume it; `setup`
creates it).

Still manual: compile the patched cmusfm from goodies/ if scrobbling
is wanted.

