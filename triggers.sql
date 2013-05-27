CREATE OR REPLACE FUNCTION import_table() RETURNS TRIGGER AS $$
DECLARE
    target_table VARCHAR;
    source_table VARCHAR;
BEGIN 
    target_table := NEW.target_schema || '.' || NEW.tablename;
    source_table := 'import.' || NEW.tablename;
    -- copy the table if it doesn't exist yet
    EXECUTE 'CREATE TABLE IF NOT EXISTS ' || target_table
        || ' (LIKE import.' || NEW.tablename || ' INCLUDING DEFAULTS INCLUDING CONSTRAINTS INCLUDING INDEXES )';
    EXECUTE 'TRUNCATE ' || target_table;
    EXECUTE 'INSERT INTO ' || target_table || ' SELECT * FROM ' || source_table;
    EXECUTE 'UPDATE import.importlog  SET complete = TRUE WHERE iid=' || quote_literal(NEW.iid); 
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER inbound_table
    AFTER INSERT ON import.importlog
    FOR EACH ROW EXECUTE PROCEDURE import_table();
