#!/bin/bash

if [[ -f ./build/blahajos.img ]]; then
    qemu-system-x86_64 -fda ./build/blahajos.img -d int -serial stdio
else
    echo "floppy image not found"
fi