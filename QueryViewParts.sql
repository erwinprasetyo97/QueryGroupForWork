-- query untuk melihat total rows 
SELECT 
    COUNT(*) AS total_rows
FROM tb_cmz_parts a
WHERE
   a.model = '10.07.2024 CUTTING MOLD - CZ192 - Signature Textile Jacquard Juliet Shoulder Bag (COMELZ)'
    and a.patternid_bom LIKE 'COH2638 A%'
    and a.style_code != 'COH2638'

    and TRUNC(a.start_time) BETWEEN TO_DATE('01-10-2024', 'dd-mm-yyyy') AND TO_DATE('21-10-2024', 'dd-mm-yyyy');

-- view data tb_cmz_hides B1 FACTORY COMELZ
SELECT 
    a.machine_code, 
    a.start_time, 
    a.orders_code,
    a.model,
    a.part_name,
    a.patternid_bom,
    a.style_code,
    a.code_hides
FROM tb_cmz_parts a
WHERE
    -- a.patternid_bom LIKE '%COH2638 A%'
    a.model = 'UPDATE KEEPER CW566 - Coated Canvas Signature Cassie Crossbody 17 (COMELZ) CONS 2,2889'
    and a.style_code = 'COH2638'
    and a.orders_code = 'PGC1-2409-000000076'
--    a.model = 'CR667 - Glovetanned Leather Emmy Saddle Bag 23 FEB-PLAN (COMELZ)_5,1039'
--    a.style_code IS NULL
--    and a.machine_code IN ('k014444', 'k012757', 'k014302', 'k015660', 'k015444', 'k015465')
--    and a.machine_code IN ('k012758','k012562', 'k015533', 'k014188')
--    and a.part_name IS NULL and a.patternid_bom IS NULL
--    and a.orders_code = 'PGC1-2408-000000023'
    --    and a.part_name = 'LONG SS FACING'
--    and a.patternid_bom = 'COH2698 A 3/20'
--    and a.machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
    -- and a.style_code != 'COH2638'
--    and a.part_name LIKE '%LONG SS FACING%'
--    a.part_name LIKE '%HANDLE FACING%'
--    AND a.part_name = 'BACK INT TOP COLLAR'
--    and a.orders_code = '76952'
--    and a.model = 'CG096 - Signature Striped Jacquard with Metallic Patch Dempsey Tote 22_Metallic refined calf_CONS 0,7530'
--    and TRUNC(a.start_time) = TO_DATE('01-10-2024', 'dd-mm-yyyy');
    and TRUNC(a.start_time) BETWEEN TO_DATE('01-10-2024', 'dd-mm-yyyy') AND TO_DATE('31-10-2024', 'dd-mm-yyyy');

-- cek stylecode
WITH ranked_data AS (
    SELECT 
        a.machine_code, 
        a.start_time, 
        a.orders_code,
        a.model,
        a.part_name,
        a.patternid_bom,
        a.style_code,
        a.material,
        ROW_NUMBER() OVER (PARTITION BY a.patternid_bom ORDER BY a.start_time) AS rn
    FROM tb_cmz_parts a
    WHERE
        REGEXP_LIKE(a.patternid_bom, '^COH2586 A [0-9]+/19$')
        AND a.model LIKE '%CV436%'
        AND TRUNC(a.start_time) BETWEEN TO_DATE('01-11-2024', 'dd-mm-yyyy') AND TO_DATE('15-11-2024', 'dd-mm-yyyy')
)
SELECT
    machine_code, 
    start_time, 
    orders_code,
    model,
    part_name,
    patternid_bom,
    style_code,
    material
FROM ranked_data
WHERE rn = 1
AND ROWNUM <= 19;

-- cek berdasarkan patternid_bom
WITH ranked_data AS (
    SELECT 
        a.machine_code, 
        a.start_time, 
        a.orders_code,
        a.model,
        a.part_name,
        a.patternid_bom,
        a.style_code,
        a.material,
        ROW_NUMBER() OVER (PARTITION BY a.patternid_bom ORDER BY a.start_time) AS rn
    FROM tb_cmz_parts a
    WHERE
--        a.orders_code = 'PGD2-2406-000000038'
        a.patternid_bom LIKE '%COH2774 A%'
       and a.model LIKE '%CAT10%'
        -- and a.model = 'HONEY BROWN CAM20 - Glazed Leather Pocket Juliet Bag 30 - SHINY SMOOTHY LEATHER - CONS 7,6598'
        -- and a.style_code != 'COH2638'
--        and a.model LIKE '%CW640%'
    --    and a.part_name = 'LONG SS FACING1'
        
--        and a.machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
        -- AND a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
        AND TRUNC(a.start_time) BETWEEN TO_DATE('01-11-2024', 'dd-mm-yyyy') AND TO_DATE('24-11-2024', 'dd-mm-yyyy')
)
SELECT
    machine_code, 
    start_time, 
    orders_code,
    model,
    part_name,
    patternid_bom,
    style_code,
    material
FROM ranked_data
WHERE rn = 1;

    
-- query cek sebelum dan setelah diedit
SELECT 
    a.machine_code, 
    a.start_time, 
    a.orders_code,
    a.model,
    a.part_name,
    a.patternid_bom,
    a.style_code,
    a.code_hides
FROM tb_cmz_parts a
WHERE
    a.patternid_bom = 'COH2770 A 26/40'
    -- and a.orders_code NOT LIKE '%PGC1-2406%'
    -- a.part_name LIKE '%FRONT%'
    -- and a.model LIKE '%C9092-B4XUK%'
    -- and a.model = 'CUTTING MOLD CY707 - Kailey Shoulder Bag in Refined Pebble Leather (COMELZ)'
    -- and a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
--    and a.orders_code = 'PGC1-2407-000000061'
    -- and a.orders_code != 'PGC1-2409-000000071'
--    and a.orders_code = 'PGD2-2406-000000016'
   and TRUNC(a.start_time) BETWEEN TO_DATE('01-11-2024', 'dd-mm-yyyy') AND TO_DATE('28-11-2024', 'dd-mm-yyyy');
    -- AND trunc(start_time) = to_date('07-11-2024', 'dd-mm-yyyy');
    
-- query untuk melihat pieces 
SELECT 
    a.machine_code, 
    a.start_time, 
    a.orders_code,
    a.model,
    a.part_name,
    a.patternid_bom,
    a.style_code,
    a.code_hides,
    (SELECT COUNT(*) 
     FROM tb_cmz_parts b
     WHERE b.orders_code = a.orders_code 
       AND b.part_name = a.part_name 
       AND b.patternid_bom = a.patternid_bom) AS pieces
FROM tb_cmz_parts a
WHERE
    a.patternid_bom LIKE '%COH2770 A%'
    -- a.patternid_bom =  'COH2646 A 16/20'
    -- and a.orders_code NOT LIKE '%PGC1-2406%'
    and a.part_name = 'EXT ZIP PULLER'
    and a.model = 'HONEY BROWN CAM20 - Glazed Leather Pocket Juliet Bag 30 - SHINY SMOOTHY LEATHER - CONS 7,6598'
    -- and a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
    -- and a.orders_code NOT LIKE '%PG'
   and a.orders_code = 'PGD2-2406-000000016'
    and TRUNC(a.start_time) BETWEEN TO_DATE('01-11-2024', 'dd-mm-yyyy') AND TO_DATE('21-11-2024', 'dd-mm-yyyy');








    