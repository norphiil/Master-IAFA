#!/bin/bash
./autocc $1.auto
./autoas $1.s
./autocell $1.exe maps/circ.map
exec bash