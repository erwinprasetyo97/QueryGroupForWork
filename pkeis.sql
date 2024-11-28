-- update data berdasarkan style code
    UPDATE tb_cmz_hides
    SET orders_code = 'PGC1-2410-000000038'
    WHERE 
        models = 'CV436 - Coated Canvas Signature Cassie Crossbody 19 (COMELZ) CONS 3,2646'
        -- and operatore = '20201826'
--        and machine_code = 'N0315490'
--        models LIKE  '%CO915__Lucas Crossbody in Signature Jacquard%'
      and orders_code LIKE '%N%'
    --    and machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
    --    and machine_code = 'k014302'
--        and orders_code = 'N09161406_00'
--        and code_hides = 'N0565881'
--        and orders_code = 'HD 0_8 BLACK'
    --    orders_code IN ('25', '15094', '15094 +++ 15095', '15107', 'N0565135_00', 'N0565137_00', 'N0565139_00', 'N0565132_00', 'N0565134_00', 'N0565138_00', 'N0565131_00', 'N0565133_00')
        -- and machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
--        AND machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
    --    and code_hides = 'N0406056'
    --    and models = 'N-CONS 4,3822'
        --  AND trunc(start_time) = to_date('07-11-2024', 'dd-mm-yyyy');
      AND trunc(start_time ) BETWEEN to_date('01-11-2024', 'dd-mm-yyyy') AND to_date('14-11-2024', 'dd-mm-yyyy');

COMMIT;
--------------------------------------------------------------------------  

UPDATE tb_cmz_parts
SET orders_code = 'PGC1-2410-000000001'
WHERE
--    orders_code = 'PGC1-2408-000000048'
    model = 'UPDATE 030924 CX071 - Racer Sling Pack in Smooth Leather (COMELZ) CONS 2,4617'
--    and machine_code = 'k014444'
--    and part_name = '#2 HANG TAG'
     and patternid_bom LIKE '%COH2646 A%'
    --  and code_hides = 'AH81772'
    and style_code = 'COH2646'
    and orders_code IN ('N0317795_00', 'N0317791_00')
    -- and part_name = 'INT STORY PATCH TOP FACING'
    -- and machine_code = 'k014302'
    -- and orders_code = 'N0315490_00'
    
--   and orders_code IN ('N09163614_00', 'N09163620_00', 'N09163599_00', 'N09163624_00', 'N09163609_00', 'N09163603_00', 'N08170850_00') 
--    and orders_code = 'HD 0_8 BLACK'
--    and orders_code = 'PGC1-2408-000000023'
    -- and machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
--    and code_hides IN ('AH79931', 'AH79930', 'AH79929', 'AH79928', 'AH79927', 'AH79926', 'AH79925', 'AH79907', 'AH79906', 'AH79905', 'AH79904', 'AH79903', 'AH79921', 'AH79920', 'AH79919', 'AH79945', 'AH79944', 'AH79955', 'AH79954', 'AH79953', 'AH79952', 'AH79940', 'AH79939', 'AH79938', 'AH79937', 'AH79936', 'AH79943', 'AH79942', 'AH79941', 'AH79951', 'AH79950', 'AH79949', 'AH79948', 'AH79947', 'AH79946', 'AH79923', 'AH79922')
--    and machine_code = 'k012562'
--    and style_code = 'COH2663'
--    and orders_code IN ('25', '15094', '15094 +++ 15095', '15107', 'N0565135_00', 'N0565137_00', 'N0565139_00', 'N0565132_00', 'N0565134_00', 'N0565138_00', 'N0565131_00', 'N0565133_00')
--    and machine_code IN ('k014787', 'k014577')
--    and machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
--    and machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706', 'k015537', 'k015273', 'k015211')
--    and code_hides = 'N0406056'
--    and model = 'CT716 - Racer Crossbody in Signature_Natural Smooth Calf_L-54938-09_BLACK_CONS 5,66'
    AND trunc(start_time) = to_date('13-11-2024', 'dd-mm-yyyy');
    -- AND trunc(start_time ) BETWEEN to_date('01-11-2024', 'dd-mm-yyyy') AND to_date('07-11-2024', 'dd-mm-yyyy');

ROLLBACK;
COMMIT;
-- edit name operator
UPDATE tb_cmz_hides
SET operatore = '20184429'
WHERE 
--    models LIKE '%Lucas Crossbody in Signature Jacquard%'
--    orders_code != 'PGC1-2407-000000017'
--    machine_code = ('k014577')
--    machine_code IN ('k014444', 'k012757', 'k014302', 'k015660', 'k015444', 'k015465', 'k012393', 'k015468', 'k014948', 'k017592', 'k014870', 'k017264')
--    and orders_code = 'N0677815_00'
--    and code_hides = 'N0406056'
    models = 'UPDATE GUSSET ANCHOR TOP PEBBLE DF CROSSGRAIN - CT803 - City Large Bucket Bag in Double Face Leather (COMELZ) CONS 6,1579'
    AND trunc(start_time) = to_date('04-09-2024', 'dd-mm-yyyy');
--    AND trunc(start_time ) BETWEEN to_date('07-09-2024', 'dd-mm-yyyy') AND to_date('09-09-2024', 'dd-mm-yyyy');
    
UPDATE tb_cmz_parts 
SET style_code  = 'COH2513'
WHERE 
    model LIKE '%Lucas Crossbody in Signature Jacquard%'
    AND trunc(start_time ) BETWEEN to_date('01-09-2024', 'dd-mm-yyyy') AND to_date('04-09-2024', 'dd-mm-yyyy');
    
SELECT 
    m.PACKAGEGROUP,
    h.DATE_UPLOAD,
    m.FACTORY,
    m.AONO,
    m.SEQNO,
    p.STYLE_CODE,
    p.MATERIAL,
    p.MODEL,
    h.CODE_HIDES
FROM MV_T_MX_PPKG m
JOIN tb_cmz_parts p ON m.PACKAGEGROUP = p.ORDERS_CODE
JOIN TB_CMZ_HIDES h ON p.ORDERS_CODE = h.ORDERS_CODE
WHERE 
    m.PACKAGEGROUP = 'PGC1-2406-000000202'
    AND TRUNC(p.start_time) BETWEEN TO_DATE('01-08-2024', 'dd-mm-yyyy') AND TO_DATE('27-08-2024', 'dd-mm-yyyy');


SELECT *
FROM
tb_cmz_parts
 where 
 orders_code = 'PGC1-2406-000000106'
 and Extract(MONTH FROM start_time)= 08
 and Extract(YEAR FROM start_time)= 2024;
 
UPDATE tb_cmz_hides
SET orders_code = 'PGC1-2406-000000106'
WHERE 
    machine_code IN ('K012757', 'K014444','K014302', 'K015660', 'K015444', 'K015465','K012393','K015468','K014948','K017592', 'K014870','K017264')
    and models = 'UPDATE_CR981_Glovetanned Leather Juliet Shoulder Bag_JAN-PLAN (COMELZ)_CONS_6,1'
    AND trunc(start_time ) BETWEEN TO_DATE('01-07-2024', 'dd-mm-yyyy') AND TO_DATE('31-07-2024', 'dd-mm-yyyy');

-- update stylecode yang kosong
UPDATE tb_cmz_parts
SET style_code = 'COH2513'

WHERE 
    model = 'REFINED CO915__Lucas Crossbody in Signature Jacquard (COMELZ) CONS 1,5574'
    and patternid_bom = 'COH2513 F 4/5'
    and TRUNC(start_time) BETWEEN TO_DATE('01-09-2024', 'dd-mm-yyyy') AND TO_DATE('30-09-2024', 'dd-mm-yyyy');


