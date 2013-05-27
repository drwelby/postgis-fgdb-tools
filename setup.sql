CREATE SCHEMA IF NOT EXISTS import;

GRANT ALL ON SCHEMA import to public;

CREATE TABLE IF NOT EXISTS import.importlog (
    iid serial,
    target_schema varchar(50) NOT NULL,
    tablename varchar(50) NOT NULL,
    timestamp_in timestamp without time zone NOT NULL DEFAULT NOW(),
    complete boolean NOT NULL DEFAULT FALSE
)
