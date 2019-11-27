git-data: easy wrapper for git-annex
====================================

git-data is an easy wrapper for git-annex, which handles the simple
use case easy (and doesn't get in the way of complex use cases by not
changing the fundamental nature of git-annex).

We start by using Allas as the built-in, with automatic configuration.
This avoids the need to do our own configuration.

Target audience
---------------

User Alpha wants to add data files to their (existing) git repository,
and have all data available everywhere by default.

User Bravo wants to add large files to their existing git repository,
but explicitely choose what data is available on each checkout, but
*all* data is always stored in Allas.


Example use case
----------------

Create new repository:

* ``git init``
* ``git data allas [-p object_prefix] bucket_name`` (after ``module load allas && allas-conf``)

Use an existing repository:

* ``git data allas`` - re-inits existing allas link

And for daily work:

* Add data files

  * ``git data add [filenames]``

* push data files to object storage

  * ``git data push [filenames]``

* get data files from object storage

  * ``git data get [filenames]``

* Remove data from local system, leave it in git and allas.

  * ``git data drop [filenames]``

* Move all data everywhere

  * ``git annex sync --content``


Advanced use cases
------------------

Locking/unlocking files:

* ``git annex unlock [filename]``
* ``git annex lock [filename]``


You want allas to have *all* data, but local to only have what you
specifically request.

* ``git annex wanted . present``  (allas automatically configured to
  want ``anything``)
* ``git annex sync --content``  (then this puts *everything* in allas,
  but doesn't fetch new things locally)


Cleaning up old data:

* Remove data files which are no longer in git

  * ``git rm [filenames]``

* Clean data from object storage

  * ``git annex unused``
  * ``git annex dropunused all``
