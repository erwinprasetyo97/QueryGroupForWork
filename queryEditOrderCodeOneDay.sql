-- update data berdasarkan style code di satu hari
UPDATE tb_cmz_hides
SET orders_code = 'PGC1-2407-000000017'
WHERE 
--    models LIKE '%CT803 - City Large Bucket Bag in Double Face Leather%'
    machine_code IN ('k014444', 'k012757', 'k014302', 'k015660', 'k015444', 'k015465', 'k012393', 'k015468', 'k014948', 'k017592', 'k014870', 'k017264')
    and orders_code NOT LIKE '%TEST%'
--    and code_hides = 'N0406056'
    and models = 'UPDATE SMOOTH TRIM - CT803 - City Large Bucket Bag in Double Face Leather (COMELZ) CONS 0,1890'
    AND trunc(start_time ) = to_date('02-09-2024', 'dd-mm-yyyy');

--------------------------------------------------------------------------

UPDATE tb_cmz_parts
SET orders_code = 'PGC1-2407-000000017'
WHERE
--    model LIKE '%CT803 - City Large Bucket Bag in Double Face Leather%'
    style_code = 'COH2618'
    and machine_code IN ('k014444', 'k012757', 'k014302', 'k015660', 'k015444', 'k015465', 'k012393', 'k015468', 'k014948', 'k017592', 'k014870', 'k017264')
    and orders_code != 'PGC1-2407-000000017'
--    and code_hides = 'N0406056'
    and model = 'UPDATE SMOOTH TRIM - CT803 - City Large Bucket Bag in Double Face Leather (COMELZ) CONS 0,1890'
    AND trunc(start_time ) = to_date('02-09-2024', 'dd-mm-yyyy');