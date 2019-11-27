#!/bin/bash
set -x
set -e

chmod -R u+w ./tmp*
rm -rf ./tmp*
tmpdir=$(mktemp -d -p $(dirname $0))
base="$PWD/$tmpdir"

cd $tmpdir
mkdir base
cd base
git init
git data init
echo data1 >> file1
git data add file1

cd "$base"
ls
git data clone ./base ./clone1


#trap "rm -r ./$tmpdir" EXIT
