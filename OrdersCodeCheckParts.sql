SELECT 
    a.start_time,
    a.machine_code, 
    a.model, 
    a.orders_code,
    a.part_name,
    a.patternid_bom,
    a.style_code
FROM tb_cmz_parts a
WHERE
    a.orders_code != 'PGD2-2407-000000002'
    and a.model LIKE '%CW640 - Glovetanned Leather Juliet Shoulder Bag 25%'
    and a.machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
--    and a.part_name = 'EXT ZIP PULLER'
--    and a.patternid_bom LIKE '%COH2663 A%'
    and TRUNC(a.start_time) BETWEEN TO_DATE('01-09-2024', 'dd-mm-yyyy') AND TO_DATE('30-09-2024', 'dd-mm-yyyy');
    
    
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
        a.model LIKE '%CW640 - Glovetanned Leather Juliet Shoulder Bag 25%'
        and a.machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
        and a.patternid_bom LIKE 'COH2663 A%'
        AND TRUNC(a.start_time) BETWEEN TO_DATE('01-09-2024', 'dd-mm-yyyy') AND TO_DATE('30-09-2024', 'dd-mm-yyyy')
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
