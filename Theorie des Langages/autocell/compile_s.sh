#!/bin/bash
./autoas $1.s
./autocell $1.exe maps/circ.map
exec bash