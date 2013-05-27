CREATE OR REPLACE FUNCTION import_table() RETURNS TRIGGER AS $$
BEGIN 
    -- copy the table if it doesn't exist yet
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || NEW.target || ' (LIKE ' || NEW.source || ' INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES )';
    EXECUTE 'TRUNCATE ' || NEW.target;
    EXECUTE 'INSERT INTO ' || NEW.target || ' SELECT * FROM ' || NEW.source;
    EXECUTE 'UPDATE import.importlog  SET complete = TRUE WHERE source=' || quote_literal(new.source) || ' AND timestamp_in=' || quote_literal(NEW.timestamp_in); 
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER inbound_table
    AFTER INSERT ON import.importlog
    FOR EACH ROW EXECUTE PROCEDURE import_table();
