git-data: easy wrapper for git-annex
====================================

git-data is an easy wrapper for git-annex, which handles the simple
use case easy (and doesn't get in the way of complex use cases by not
changing the fundamental nature of git-annex).

We start by using Allas as the built-in, with automatic configuration.
This avoids the need to do our own configuration.



Target audience
---------------

User **Alpha** wants to add data files to their (existing) git
repository, and have all data available everywhere by default.  (This
is the git-data default)

User **Bravo** wants to add large files to their existing git
repository, but explicitely choose what data is available on each
checkout, but *all* data is always stored in Allas.  (To enable this
automation, run ``git annex wanted . present`` in a repository).


Example use case
----------------

Create new repository:

* ``git init``
* ``git data allas bucket_name[/object_prefix]`` (after ``module load allas && allas-conf``)

Use an existing repository:

* Clone the repository like normal.
* ``git data allas`` - re-inits existing allas link, which is stored
  within the normal git repository - even if hosted on github or
  non-aware services.

And for daily work:

* ``git data add [filenames]``: add data files
* ``git data sync --content``: *automatically* use the Alpha (all
  files everywhere) or Bravo (all files in Allas) policies.
* ``git data push [filenames]``: push specific data files to object
  storage
* ``git data get [filenames]``: get specific data files from object
  storage
* ``git data drop [filenames]``: remove data from local system, leave
  it in git and allas.



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

* ``git annex uninit``: un-annex (put original, normal files back in
  the directories) and git rid of all the symlinks.



Limitations
-----------

We rely on ``allas-conf`` to set up a rclone configuration that has an
``allas`` remote defined.  This simplifies things a lot, but it could
be that it's not available.  We will deal with that when it comes up,
because CSC doesn't provide any other way of configuring Allas!



See also
--------
* git-annex
