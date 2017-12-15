#!/bin/bash

inkscape src/block.svg --export-png=block.png
inkscape src/mini_block.svg --export-png=mini_block.png
inkscape src/grid.svg --export-png=grid.png

ffmpeg -y -i src/main_music.wav main_music.ogg

normal_files=$(find src/ -iname "*.wav" ! -name "main_music.wav")
normal_files+=" src/Chewy.ttf"
normal_files+=" src/main_menu_bg.png"

for f in $normal_files
do
    echo "Copying '$f' to current path"
    cp -f $f .
done
