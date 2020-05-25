CREATE OR REPLACE TRIGGER country_trig BEFORE
    INSERT ON band
    FOR EACH ROW
    WHEN ( new.country_name IS NULL )
    
BEGIN
    :new.country_name := 'Unknown';
    INSERT INTO country ( country_name ) VALUES ( :new.country_name );

EXCEPTION
    WHEN dup_val_on_index THEN
        NULL;
            
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error in country_trig!');

END;
