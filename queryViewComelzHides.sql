-- view data tb_cmz_hides B1 FACTORY COMELZ
SELECT 
    a.machine_code, 
    a.start_time,
    a.orders_code,
    a.models,
    a.operatore,
    a.code_hides
FROM tb_cmz_hides a
WHERE
    -- a.models LIKE '%CW640%'
--    and a.orders_code = 'PGD2-2407-000000002'
--    and a.machine_code = 'k012562'
--    and a.machine_code IN ('k014444', 'k012757', 'k014302', 'k015660', 'k015444', 'k015465')
--    and a.orders_code != 'PGC1-2406-000000245'
    a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
    and a.orders_code NOT LIKE '%PG%'
--    a.machine_code IN ('k012758','k012562', 'k015533', 'k014188')
--    and a.models LIKE '%CW566%'
--    and TRUNC(a.start_time) = TO_DATE('01-10-2024', 'dd-mm-yyyy');
    and TRUNC(a.start_time) BETWEEN TO_DATE('01-11-2024', 'dd-mm-yyyy') AND TO_DATE('05-11-2024', 'dd-mm-yyyy');
    
-- melihat data yang sama satu kali di tb cmz hides yang belum ada package group nya
WITH ranked_data AS (
    SELECT 
        a.machine_code, 
        a.start_time,
        a.orders_code,
        a.models,
        a.OPERATORE,
        a.CODE_HIDES,
        ROW_NUMBER() OVER (PARTITION BY a.models ORDER BY a.start_time) AS rn
    FROM TB_CMZ_HIDES a
    WHERE
        -- a.machine_code IN ('k014444', 'k012757', 'k014302', 'k015660', 'k015444', 'k015465')
        a.machine_code IN ('k012758', 'k012562', 'k015533', 'k014188')
        and a.orders_code NOT LIKE '%PG%'
        and a.orders_code NOT LIKE '%KK%'
        and a.orders_code NOT LIKE '%RIC%'
        and a.orders_code NOT LIKE '%KURANGAN%'
        
        and a.models != 'esempio'
        and a.models != 'cinturino'
        AND TRUNC(a.start_time) BETWEEN TO_DATE('01-11-2024', 'dd-mm-yyyy') AND TO_DATE('14-11-2024', 'dd-mm-yyyy')
)
SELECT
    machine_code, 
    start_time,
    orders_code,
    models,
    operatore,
    code_hides
FROM ranked_data
WHERE rn = 1;


-- query cek data hides setelah diedit
SELECT 
    a.machine_code, 
    a.start_time,
    a.orders_code,
    a.models,
    a.operatore,
    a.code_hides
FROM tb_cmz_hides a
WHERE
    a.models = 'update GUSSET 1 MOLD PKID - CY707 CONS 4,2587'
    -- and a.operatore IS NULL
    and TRUNC(a.start_time) = TO_DATE('04-11-2024', 'dd-mm-yyyy');