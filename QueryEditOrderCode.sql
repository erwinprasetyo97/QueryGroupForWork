UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE
        WHEN part_name = 'LONG SS FACING' THEN 'COH2638 A 1/30' --done
        WHEN part_name = 'LONG SS TOP' THEN 'COH2638 A 2/30	' -- done
        -- WHEN part_name = 'BACK SLASH PKT LEFT LINING' THEN 'COH2639 A 3/25'
        -- WHEN part_name = 'BACK SLASH PKT RIGHT LINING' THEN 'COH2639 A 4/25'
        WHEN part_name = 'ANCHOR' THEN 'COH2638 A 23/30' -- done
        WHEN part_name = 'PIPING' THEN 'COH2639 A 6/25'
        -- WHEN part_name = 'HANGTAG FAICNG' THEN 'COH2639 A 7/25'
        WHEN part_name = 'ANCHOR LOOP FACING' THEN 'COH2638 A 19/30' --done
        WHEN part_name = 'SHORT SS FLOATING KEEPER TOP' THEN 'COH2638 A 10/30' -- done
        WHEN part_name = 'HANDLE KEEPER FACING' THEN 'COH2638 A 16/30' -- done
        WHEN part_name = 'HANDLE TOP' THEN 'COH2638 A 29/30' -- done
        WHEN part_name = 'HANDLE KEEPER TOP' THEN 'COH2638 A 17/30'  --done
        WHEN part_name = 'HANG TAG TOP' THEN 'COH2638 A 9/30' -- done
        WHEN part_name = 'SHORT SS TOP' THEN 'COH2638 A 22/30' -- done
        WHEN part_name = 'SHORT SS KEEPER TOP' THEN 'COH2638 A 7/30' -- done
        WHEN part_name = 'CENTER DIVIDER LEFT GUSSET ACCORDION' THEN 'COH2638 A 28/30' -- done
        WHEN part_name = 'SHORT SS KEEPER FACING' THEN 'COH2638 A 8/30' -- done
        WHEN part_name = 'SHORT SS FLOATING KEEPER FACING' THEN 'COH2638 A 11/30' -- done
        WHEN part_name = 'CENTER DIVIDER RIGHT GUSSET ACCORDION' THEN 'COH2639 A 19/25'
        WHEN part_name = 'HANDLE FACING' THEN 'COH2638 A 20/30' -- done
        WHEN part_name = 'CENTER DIVIDER GUSSET ACCORDION' THEN 'COH2638 A 24/30' --done
        WHEN part_name = 'SHORT SS BUCKLE LOOP FACING' THEN 'COH2638 A 15/30' --done
        WHEN part_name = 'SHORT SS FACING' THEN 'COH2638 A 18/30' -- done
        WHEN part_name = 'FLAP TOP' THEN 'COH2638 A 27/30' -- done
        WHEN part_name = 'CENTER DIVIDER BOTTOM' THEN 'COH2638 A 26/30' -- done
        WHEN part_name = 'BACK SLASH PKT' THEN 'COH2638 A 5/30' -- done
        WHEN part_name = 'FRONT' THEN 'COH2638 A 6/30' -- done
        WHEN part_name = 'CENTER DIVIDER RIGHT GUSSET ACCORDION' THEN 'COH2638 A 21/30' -- done
        WHEN part_name = 'FRONT BACK GUSSET ACCORDION' THEN 'COH2638 A 25/30' -- done
        WHEN part_name = 'FRONT BACK RIGHT GUSSET ACCORDION' THEN 'COH2638 A 30/30' -- done
        WHEN part_name = 'FRONT BACK LEFT GUSSET ACCORDION' THEN 'COH2638 A 14/30'
        ELSE patternid_bom
    END
WHERE 

    model = 'CW565 - Refined Pebble Leather Cassie Crossbody 17 (COMELZ) CONS 3,1533'
    and trunc(start_time) BETWEEN TO_DATE('21-10-2024', 'dd-mm-yyyy') AND TO_DATE('25-10-2024', 'dd-mm-yyyy');

COMMIT;

-- cek data
SET DEFINE OFF;

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
    -- a.patternid_bom = 'COH2104 D 5/7'
    -- a.part_name = 'FRONT BACK'
    -- and a.patternid_bom = 'COH2663 A 15/20'
    -- a.model = 'CW640 - Glovetanned Leather Juliet Shoulder Bag 25 b2 (COMELZ)'
    -- and a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
    a.orders_code NOT LIKE '%PG%'
    and a.machine_code IN ('k012758','k012562', 'k015533', 'k014188')
    and a.model NOT IN ('esempio')
    -- and a.patternid_bom IS NULL
--    and a.orders_code = 'PGD2-2406-000000016'
    and TRUNC(a.start_time) BETWEEN TO_DATE('01-10-2024', 'dd-mm-yyyy') AND TO_DATE('31-10-2024', 'dd-mm-yyyy');



