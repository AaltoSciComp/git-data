git-data: easy wrapper for git-annex
====================================

git-data is an easy wrapper for git-annex, which handles the simple
use case easy (and doesn't get in the way of complex use cases by not
changing the fundamental nature of git-annex).

We start by using Allas as an example.  This avoids the need to do our
own configuration.


Example use case
----------------

* Create new repository
  * ``git init``
  * ``git data allas [-p object_prefix] bucket_name`` (after ``module load allas && allas-conf``)

And for daily work:

* Add data files
  * ``git data add [filenames]``
* push data files to object storage
  * ``git data push [filenames]``
* get data files from object storage
  * ``git data get [filenames]``
* Delete data
  * ``git data drop [filenames]``
* Move all data everywhere
  * ``git annex sync --content``
* You want allas to have *all* data, but local to only have what you
  specifically request
  * ``git annex wanted . present``  (allas automatically configured to
    want ``anything``)
  * ``git annex sync --content``

And to clean-up:

* Remove data files which are no longer in git
  * ``git rm [filenames]``
* Clean data from object storage
  * ``git annex unused``
  * ``git annex dropunused all``


Locking/unlocking files
* ``git annex unlock [filename]``
* ``git annex lock [filename]``
