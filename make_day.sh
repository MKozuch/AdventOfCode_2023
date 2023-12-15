#!/bin/bash

dart create day$1
cd day$1
dart pub upgrade --major-versions
rm *.md
rm .gitignore
mkdir input
touch input/input.txt
