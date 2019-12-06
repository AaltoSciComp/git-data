#!/bin/bash
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

# Clone it, verify that "git data clone" automatically gets for you
cd "$tmpdir"
ls
git data clone ./origin ./clone1
cd 'clone1'
test -e file1  # "git data clone" inits and gets for you.
git data sync
test -e file1

# Clone it, verify that "git data clone" automatically gets for you
cd "$tmpdir"
ls
git clone ./origin ./clone2
cd 'clone2'
test ! -e file1  # "git data clone" inits and gets for you.
git data sync --content
test -e file1


echo
echo "phase 1 success"
echo

# Phase 2: try to link to object store
test -z "$2" && exit 0

echo $2
echo "$@"

# Do the test
cd "$tmpdir/origin"
git data allas "$2"
git data sync --content

echo
echo "phase 2 success"
echo

#trap "rm -r ./$tmpdir" EXIT
