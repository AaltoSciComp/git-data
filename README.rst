git-data: easy wrapper for git-annex
====================================

To successfully use an object store, one needs to manage movement of
data.  This takes a lot of care when it is *imperative* (issue
commands), but easier when it is *declarative* (say what data you want
where, backend handles transfers, replication, merging).

git-data is an easy wrapper for git-annex, which handles simple
use cases easy (and doesn't get in the way of complex matters, since
git-annex is still usable directly).

Currently, git-data is speciallized for Allas, a ceph-based object
store in Finland - but there is nothing special about using Allas.  In
fact, there's not much special about git-data other than making things
usable.



Target audience
---------------

git-annex can do anything, but let's keep the goals of git-data simple:

User **Alpha** wants to add data files to their (existing) git
repository, and have all data available everywhere by default.  (This
is the git-data default)

User **Bravo** wants to add large files to their existing git
repository, but explicitely choose what data is available on each
checkout, but *all* data is always stored in Allas.  (To enable this
mode, run ``git annex wanted . present`` in a repository).

User **Echo** has confidential data which, in effect, has to be
client-side encrypted before it can go into Allas.  This is done with
``-e`` to the initialization.

User **Sierra** has data which must be shared with external
collaborators.  This is done by sharing Allas bucket access and this
git repository.



Example use case
----------------

Create new repository:

* ``git init``
* ``git data allas bucket_name[/object_prefix]`` (after ``module load allas && allas-conf``)

Clone an existing repository and access its data:

* Clone the repository like normal.
* ``git data allas`` - re-inits existing allas link, which is stored
  within the normal git repository - even if hosted on github or
  non-aware services.  Add ``-e`` to enable git-annex encryption (see
  below).

And for daily work:

* ``git data add [filenames]``: add data files.  File is moved to a
  safe place and replaced with a symlink.
* ``git data sync --content``: *automatically* use the Alpha (all
  files everywhere) or Bravo (all files in Allas) policies.
* ``git data push [filenames]``: push specific data files to object
  storage
* ``git data get [filenames]``: get specific data files from object
  storage
* ``git data drop [filenames]``: remove data from local system, leave
  dangling symlink locally and actual data in Allas.



Locking
-------

If it's in git-annex, it is assumed to be static, thus it is locked by
default.  This is especially good for safety: you data integreity is
guarenteed.  But sometimes you need to edit it.  For that, you have to
unlock it.  When you ``git add`` it again later, it will be locked
again.

* ``git data unlock [filename]``
* ``git data lock [filename]``



Advanced use cases
------------------

Clean data from object storage, which has been removed from git at
some time in the past.

* ``git annex unused``
* ``git annex dropunused all``

Completly get rid of git-annex

* ``git annex uninit``: un-annex and get rid of all the symlinks (put
  original, normal files back in the directories).

Metadata (key-values strings) can be saved along with every file.



Sharing
-------

If you want to share the data with others, it is as simple as sharing
the git repository (All the special stuff is on the special
``git-annex`` branch - that branch encodes what is needed to get
objects from the store.



Encryption
----------

If the allas is initialized (the very first time) with ``-e``, then
all objects are stored on it `encrypted
<https://git-annex.branchable.com/encryption/>`__ client side.  This
encryption should be considered secure.  By ``git-data`` default, it
is "shared" encryption mode: the symmetric key is stored within the
repository itself, so anyone with a copy of the repository can access
all data (the other option is using PGP keys, not described here).
Thus, securely sharing data with the object store reduces the the
problem of securely the the (small) git repository, which can be done
via ssh access, Gitlab, etc.  If the object store credentials are not
also embedded in the repository, then both the repository and object
store access are needed to access the data.



Limitations
-----------

We rely on ``allas-conf`` to set up a rclone configuration that has an
``allas`` remote defined.  This simplifies the instructions above,
becasue we don't have to give instructions for getting access
tokens.

The filenames in object storage are hashes and don't match up with the
real filenames (since it has to be able to store multiple versions),
BUT git-annex has a mode which can export actual filenames to the
object store.  We will investigate this if needed.



See also
--------
* `git-annex <https://git-annex.branchable.com/>`__, the true
  inspiration and workhorse of git-data.
* `DataLad <https://www.datalad.org/>`__, a tool using git-annex to
  build whole structured repositories.
