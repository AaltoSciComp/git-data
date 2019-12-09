#!/bin/bash

# Test of git-data.  This script is currently a hack, and needs
# improvement.

set -x
set -e

echo "$@"

# ROOT is where test is done, path of this script by default,
# otherwise from command line.
ROOT=$(dirname $0)
test -n $1 && ROOT=$1 || true
ROOT=$(readlink -f $ROOT)

# Remove existing test dirs
chmod -R u+w $ROOT/tmp-git-data-test* || true
rm -rf $ROOT/tmp-git-data-test*

# Make temp dir, change to it
tmpdir=$(mktemp -d -p $ROOT tmp-git-data-test-XXXXXXX)
cd $tmpdir

# Make first repo, init it, add a file.
mkdir origin
cd 'origin'
git init 'test origin'
git data init
echo data1 >> file1
git data add file1
git commit -m 'commit 1'

# Phase 1: clone it, verify that "git data clone" automatically gets
# the data for you.
cd "$tmpdir"
ls
git data clone ./origin ./clone1
cd 'clone1'
test -e file1  # "git data clone" inits and gets for you.
git data metasync
test -e file1
# Phase 1b: clone without git-data, verify that "git data sync
# --content" gets the data for you.
cd "$tmpdir"
ls
git clone ./origin ./clone2
cd 'clone2'
test ! -e file1  # File is *not* there yet
git data metasync --content
test -e file1    # File is now there
echo
echo "phase 1 success"
echo

# Phase 2: try to link to object store
echo "Begin phase 2..."
test -z "$2" && exit 0
echo $2
echo "$@"
# Do the test
cd "$tmpdir/origin"
git data allas "$2"
git data sync
echo
echo "phase 2 success"
echo


# Phase 3: use the fullsync on a new repo - send files both ways.
echo "Begin phase 3..."
cd "$tmpdir/"
git data clone ./origin ./clone3
cd clone3
echo 'data3a' > data3a     # annexed
echo 'data3b' > data3b     # normal git file
git data add data3a
git add data3b
git commit -m phase3
git data sync
pwd ; ls -l
cd ../origin
git data sync
pwd ; ls -l
test "$(cat data3a)" = data3a   # verify both files got transferred
test "$(cat data3b)" = data3b   # ...


#trap "rm -r ./$tmpdir" EXIT
echo
echo "success"
