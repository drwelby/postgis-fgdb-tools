import subprocess
import sys
import os

'''usage: pgimport path/to/fgdb layername database schema.tablename host user pass
    This lets you import fgdbs into postgis tables that have views on them.
    Uses an intermediate table to minimize downtime'''


fgdb, layer, db, target, host, user, password = sys.argv[1:]

env = os.environ.copy()
env['PGPASSWORD'] = password

sqlconn = 'psql -U%s -h %s -d %s ' % (user, host, db)

try:
    targetschema,targettable = target.split(".")
except ValueError:
    targetschema = "public"
    targettable = target

temptable = "import.%s" % (targettable)

#ogr2ogr in overwrite mode to temp import table
ogrcmd = 'ogr2ogr -skipfailures -overwrite -f "PostgreSQL" PG:"host=%s dbname=%s user=%s password=%s" "%s" "%s" -nln "%s"' \
        % (host, db, user, password, fgdb, layer, temptable)

print ogrcmd
subprocess.call(ogrcmd, shell=True)

#check if target table exists, otherwise create it

sqlcmd = sqlconn + '-c "INSERT INTO import.importlog (targetschema, tablename) VALUES (%s,%s);"' % (targetschema, targettable)
print sqlcmd
subprocess.call(sqlcmd, shell=True, env=env)

