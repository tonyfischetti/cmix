# cmix

## my cmus configuration file

This only works with cmus with patches applied

Grab the configurations...

    git clone https://github.com/tonyfischetti/cmix.git ~/cmus

Make sure your music is in a directory called `music` in your
home directory (`$HOME/music`) because that's what the playlists
assume

Oh, and don't forget to

    sudo apt build-dep cmus

before attempting to compile cmus
Use the patch(es) in ./goodies/ against cmus
(tested against commit 600fa4bbde)

And then compile the patched version of cmusfm in goodies

