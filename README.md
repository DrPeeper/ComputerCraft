# It's happening

[Turtle API](https://computercraft.info/wiki/Turtle_(API))

[Turtle Recipes](https://computercraft.info/wiki/Recipes)

## Repo structure

* **/bin:** executable programs
* **/lib:** library functions
* **/scripts:** scripts to setup new turtles

## Turtle Install Guide

These are the steps required to copy code from `/bin` and `/lib` in this repo to a fresh turtle.

1. In game, copy the `scripts/git.lua` script onto a floppy disk, via this command:
```
> pastebin get A6qnQXMQ /disk/git.lua
```

Downloading to a floppy disk is completely optional but much more convenient if setting up multiple turtles, as you only have to download `git.lua` once.

2. Use this floppy disk to install git code onto turtles with this command:
```
> /disk/git.lua
```

3. Confirm code was downloaded with this command:
```
> /bin/test.lua
Turtle initialization success!
```
