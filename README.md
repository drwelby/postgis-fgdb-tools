pgtools
========

Some tools to help import PostGIS tables from FGDBs. This tries to solve the
following problems:

* Importing a big FGDB takes a couple of minutes. So instead of updating
  a table in-place, this instead imports to a intermediate table.
* The import is logged, so when somebody asks "When was the last time X was
  updated?", you can do something other than shrug and look around.
* The target table is truncated instead of dropped, so you can use views on
  your tables without them disappearing every time you update a table through
  ogr2ogr


Parts
-----

*setup.sql* sets up the import schema and the import log table.

*triggers.sql* sets up the trigger on the import log that finishes the import.

*pgimport.py* is a python batch script that imports the FGDB using ogr2ogr and then logs
the file as imported, which triggers the db to move the import file to its
target location.

Requirements
---------

You'll need ogr2ogr, psql, and Postgres 9.2. 
