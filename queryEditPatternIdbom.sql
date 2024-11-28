/* query untuk update patterind_bom sekaligus dimana patternid nya tidak ada tanda /
contoh kasus : COH2104 A 219 -> COH2104 A 2/19
COH2618 A 1826 -> COH2618 A 18/26
*/
UPDATE tb_cmz_parts
SET patternid_bom = REGEXP_REPLACE(patternid_bom, '([0-9]{1,2})(1)', '\1/\2')
WHERE patternid_bom LIKE '%COH2104 AC%' 
  AND style_code = 'COH2104'
  and model LIKE '%C7965%'
--  and model = 'CR652_Glazed Leather Juliet Shoulder Bag_ Shiny crinkle leather_CONS 6,1'
  and PATTERNID_BOM NOT LIKE '%/%' -- apabila sudah ada pattern yang sudah benar
  AND TRUNC(start_time) BETWEEN TO_DATE('01-11-2024', 'dd-mm-yyyy') AND TO_DATE('22-11-2024', 'dd-mm-yyyy');

COMMIT;
ROLLBACK;

-- versi lain
UPDATE tb_cmz_parts
SET patternid_bom = REGEXP_REPLACE(patternid_bom, '(\s[0-9]{1,2})(18)$', '\1/\2')
WHERE patternid_bom LIKE '%COH2618 A%' 
  AND style_code = 'COH2618'
  AND patternid_bom NOT LIKE '%/%'  -- Hanya untuk data yang belum ada garis miring (/)
  AND TRUNC(start_time) BETWEEN TO_DATE('01-10-2024', 'dd-mm-yyyy') AND TO_DATE('30-10-2024', 'dd-mm-yyyy');


/* query untuk update patternid apabila salah dalam penulisan belakangnya contoh /6 menjadi /7
contoh : COH2104 D 1/6 -> COH2104 D 1/7
*/
UPDATE tb_cmz_parts
SET patternid_bom = REGEXP_REPLACE(patternid_bom, '/6$', '/7')
WHERE patternid_bom LIKE 'COH2104 D%/6'
  AND style_code = 'COH2104'
  AND trunc(start_time) = TO_DATE('01-10-2024', 'dd-mm-yyyy');
  
-- contoh kasus : COH2104 D 16 -> COH2104 D 1/7 
UPDATE tb_cmz_parts
SET patternid_bom = REGEXP_REPLACE(patternid_bom, '([0-9])6$', '\1/7')
WHERE patternid_bom LIKE 'COH2104 D%6'
  AND style_code = 'COH2104';
  
-- case seperti ini COH2698 A 10/20 -> COH2698 A 10/21
UPDATE tb_cmz_parts
SET patternid_bom = REGEXP_REPLACE(patternid_bom, '(/)[0-9]+$', '/21')
WHERE patternid_bom LIKE 'COH2698 A%' 
  AND style_code = 'COH2698'
  AND model = 'CAD75 - Glazed Leather Juliet Shoulder Bag 25 - SHINY CRINKLE LEATHER - CONS 4,3822'
  AND orders_code != 'PGD2-2409-000000021'
--  AND trunc(start_time) = TO_DATE('07-11-2024', 'dd-mm-yyyy');
  AND TRUNC(start_time) BETWEEN TO_DATE('10-11-2024', 'dd-mm-yyyy') AND TO_DATE('12-11-2024', 'dd-mm-yyyy');

COMMIT;
ROLLBACK;



-- untuk aktifkan row movement  
ALTER TABLE tb_cmz_parts ENABLE ROW MOVEMENT;
ALTER TABLE tb_cmz_hides ENABLE ROW MOVEMENT;

SELECT
    s.sid, s.serial#, s.username, s.program
FROM
    v$session s
JOIN
    v$locked_object lo ON s.sid = lo.session_id
JOIN
    dba_objects o ON lo.object_id = o.object_id
WHERE
    o.object_name = 'TB_CMZ_PARTS';
  
-- untuk nonaktifin row movement
ALTER TABLE tb_cmz_parts DISABLE ROW MOVEMENT;
ALTER TABLE tb_cmz_hides DISABLE ROW MOVEMENT;

-- untuk rollback jika sudah dicommit, note harus di enable dulu baru diflashback setelah itu di disable lagi
FLASHBACK TABLE tb_cmz_parts TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '20' MINUTE);
FLASHBACK TABLE tb_cmz_hides TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '20' MINUTE);


-- untuk case COH2618 A 1818 -> COH2618 A 18/18
UPDATE tb_cmz_parts
SET patternid_bom = REGEXP_REPLACE(patternid_bom, 'COH2618 A ([0-9]{1,2})(18)', 'COH2618 A \1/\2')
WHERE patternid_bom LIKE 'COH2618 A%' 
  AND style_code = 'COH2618'
  AND trunc(start_time) = TO_DATE('01-10-2024', 'dd-mm-yyyy');


UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE
        WHEN part_name = 'LONG SS FACING' THEN 'COH2639 A 1/25'
        WHEN part_name = 'LONG SS TOP' THEN 'COH2639 A 2/25'
        WHEN part_name = 'BACK SLASH PKT LEFT LINING' THEN 'COH2639 A 3/25'
        WHEN part_name = 'BACK SLASH PKT RIGHT LINING' THEN 'COH2639 A 4/25'
        WHEN part_name = 'ANCHOR' THEN 'COH2639 A 5/25'
        WHEN part_name = 'PIPING' THEN 'COH2639 A 6/25'
        WHEN part_name = 'HANGTAG FAICNG' THEN 'COH2639 A 7/25'
        WHEN part_name = 'ANCHOR LOOP FACING' THEN 'COH2639 A 8/25'
        WHEN part_name = 'SHORT SS FLOATING KEEPER TOP' THEN 'COH2639 A 9/25'
        WHEN part_name = 'HANDLE KEEPER FACING' THEN 'COH2639 A 10/25'
        WHEN part_name = 'HANDLE TOP' THEN 'COH2639 A 11/25'
        WHEN part_name = 'HANDLE KEEPER TOP' THEN 'COH2639 A 12/25'
        WHEN part_name = 'HANG TAG TOP' THEN 'COH2639 A 13/25'
        WHEN part_name = 'SHORT SS TOP' THEN 'COH2639 A 14/25'
        WHEN part_name = 'SHORT SS KEEPER TOP' THEN 'COH2639 A 15/25'
        WHEN part_name = 'CENTER DIVIDER LEFT GUSSET ACCORDION' THEN 'COH2639 A 16/25'
        WHEN part_name = 'SHORT SS KEEPER FACING' THEN 'COH2639 A 17/25'
        WHEN part_name = 'SHORT SS FLOATING KEEPER FACING' THEN 'COH2639 A 18/25'
        WHEN part_name = 'CENTER DIVIDER RIGHT GUSSET ACCORDION' THEN 'COH2639 A 19/25'
        WHEN part_name = 'HANDLE FACING' THEN 'COH2639 A 20/25'
        WHEN part_name = 'CENTER DIVIDER GUSSET ACCORDION' THEN 'COH2639 A 21/25'
        WHEN part_name = 'SHORT SS BUCKLE LOOP FACING' THEN 'COH2639 A 22/25'
        WHEN part_name = 'SHORT SS FACING' THEN 'COH2639 A 23/25'
        WHEN part_name = 'FLAP TOP' THEN 'COH2639 A 24/25'
        WHEN part_name = 'CENTER DIVIDER BOTTOM' THEN 'COH2639 A 25/25'
        ELSE patternid_bom
    END
WHERE 

    model = 'UPDATE KEEPER CW566 - Coated Canvas Signature Cassie Crossbody 17 (COMELZ) CONS 2,2889'
    and trunc(start_time) BETWEEN TO_DATE('01-10-2024', 'dd-mm-yyyy') AND TO_DATE('22-10-2024', 'dd-mm-yyyy');

        

/* note
'([0-9]{1,2})(19)': Ini adalah regular expression (regex) yang akan mencari pola dalam patternid_bom. Mari kita pecah bagian ini:

([0-9]{1,2}): Ini mencocokkan satu atau dua digit angka.
[0-9] berarti angka dari 0 hingga 9.
{1,2} berarti kita mencari 1 atau 2 digit angka.
Kurung ( ) ini adalah grup tangkapan, yang berarti angka ini akan disimpan dan bisa digunakan nanti.
(19): Ini mencari angka "19" yang langsung mengikuti angka yang ditemukan sebelumnya.
Angka "19" ini juga berada dalam tanda kurung ( ), yang membuatnya menjadi grup tangkapan kedua.
'\1/\2': Ini adalah format baru yang akan digunakan untuk menggantikan pola yang ditemukan:

\1: Mengacu pada hasil grup tangkapan pertama, yaitu angka 1 atau 2 digit yang ditemukan di patternid_bom sebelum "19" (misalnya 1 dari 119 atau 2 dari 219).
/: Karakter "/" ditambahkan di antara grup tangkapan.
\2: Mengacu pada grup tangkapan kedua, yaitu angka "19".

*/

-- query for edit style code
UPDATE tb_cmz_parts
SET style_code = 'COH2638'
WHERE
    model = 'MULTI CW565 - Refined Pebble Leather Cassie Crossbody 17 (COMELZ) CONS 3,1533'
    -- and patternid_bom LIKE '%COH2572 A%'
    -- and orders_code = 'PGC1-2406-000000022'
    and style_code IS NULL
    and trunc(start_time ) BETWEEN to_date('01-10-2024', 'dd-mm-yyyy') AND to_date('31-10-2024', 'dd-mm-yyyy');

COMMIT;

UPDATE tb_cmz_parts
SET patternid_bom = 'COH2573 ' || substr(patternid_bom, instr(patternid_bom, ' ')+1)
 
 where orders_code = 'PGC1-2406-000000022'
 and trunc(start_time ) BETWEEN to_date('01-10-2024', 'dd-mm-yyyy') AND to_date('18-10-2024', 'dd-mm-yyyy');



UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE
        WHEN patternid_bom IS NULL THEN 'COH2698 A 6/20'
--        WHEN patternid_bom = 'COH2513 A 15/16' THEN 'COH2663 A 6/20'
    END
    
WHERE part_name = 'TOP BINDING'
and style_code = 'COH2698'
--AND trunc(start_time) = to_date('19-09-2024', 'dd-mm-yyyy');
AND trunc(start_time) BETWEEN to_date('01-09-2024', 'dd-mm-yyyy') AND to_date('30-09-2024', 'dd-mm-yyyy');



UPDATE tb_cmz_parts
SET part_name = 'FRONT BACK'

WHERE part_name = 'FRONT BACK_2'
and patternid_bom = 'COH2569 A 20/21'
--and patternid_bom IS NULL
and model LIKE '%CR652%'
--AND trunc(start_time) = to_date('19-09-2024', 'dd-mm-yyyy');
AND trunc(start_time) BETWEEN to_date('01-09-2024', 'dd-mm-yyyy') AND to_date('11-10-2024', 'dd-mm-yyyy');





-- query for update apabila ada case COH2104 A 119 dan apabila ada data COH2104 A 1/19
UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE 
        -- If there's already a slash present, avoid adding another one
        WHEN INSTR(patternid_bom, '/') = 0 
        THEN SUBSTR(patternid_bom, 1, LENGTH(patternid_bom) - 2) || '/' || SUBSTR(patternid_bom, -2)
        -- If there's already a slash, no need to update the value
        ELSE patternid_bom 
    END
WHERE patternid_bom LIKE 'COH2639 A%' -- or your desired style code
AND TRUNC(start_time) BETWEEN TO_DATE('01-10-2024', 'dd-mm-yyyy') AND TO_DATE('15-10-2024', 'dd-mm-yyyy')
AND REGEXP_LIKE(SUBSTR(patternid_bom, -2), '^[0-9]{2}$');

-- query untuk edit style code
UPDATE tb_cmz_parts
SET style_code = 'COH2639'
WHERE
    model = 'UPDATE KEEPER CW566 - Coated Canvas Signature Cassie Crossbody 17 (COMELZ) CONS 2,2889'
    -- and patternid_bom IN ('COH2638 A 14/30', 'COH2638 A 4/30')
    -- and style_code IS NULL
    and style_code = 'COH2638'
   and trunc (start_time) BETWEEN to_date('01-10-2024', 'dd-mm-yyyy') AND to_date('31-10-2024', 'dd-mm-yyyy');

COMMIT;



--QUERY UNTUK EDIT PATTERNiD
SET DEFINE OFF;
UPDATE tb_cmz_parts 
SET patternid_bom = 'COH2638 A 3/30'

WHERE 
    model = 'CW565 - Refined Pebble Leather Cassie Crossbody 17 (COMELZ) CONS 3,1533'
    and patternid_bom = 'COH2638 A 4/30'
    AND part_name = 'BACK SLASH PKT RIGHT&LEFT LINING'
    and trunc (start_time) BETWEEN to_date('01-10-2024', 'dd-mm-yyyy') AND to_date('31-10-2024', 'dd-mm-yyyy');


UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE
        WHEN part_name = 'PKT TOP BINDING' THEN 'COH2770 A 31/40'
        WHEN part_name = 'RIGHT GUSSET D RING ANCHOR TOP' THEN 'COH2770 A 22/40'
        WHEN part_name = 'GUSSET FLAP HW PATCH TOP' THEN 'COH2770 A 4/40'
        WHEN part_name = 'EXT ZIP PULLER LOOP FACING' THEN 'COH2770 A 36/40'
        WHEN part_name = 'GUSSET FLAP TOP' THEN 'COH2770 A 37/40'
        WHEN part_name = 'ANCHOR' THEN 'COH2770 A 3/40'
        WHEN part_name = 'BOTTOM' THEN 'COH2770 A 7/40'
        WHEN part_name = 'EXT ZIP PULLER' THEN 'COH2770 A 1/40'
        WHEN part_name = 'ANCHOR LOOP FACING' THEN 'COH2770 A 2/40'
        WHEN part_name = 'HANGTAG TOP' THEN 'COH2770 A 38/40'
        WHEN part_name = 'FRONT' THEN 'COH2770 A 39/40'
        WHEN part_name = 'HANGTAG FACING' THEN 'COH2770 A 19/40'
        WHEN part_name = 'STRAP PAD FACING FILLER' THEN 'COH2770 A 23/40'
        WHEN part_name = 'SHORT SS KEEPER TOP' THEN 'COH2770 A 24/40'
        WHEN part_name = 'SHORT SS KEEPER FACING' THEN 'COH2770 A 26/40'
        WHEN part_name = 'STRAP PAD TOP' THEN 'COH2770 A 27/40'
        WHEN part_name = 'STRAP PAD FACING' THEN 'COH2770 A 28/40'
        WHEN part_name = 'LONG SS FACING' THEN 'COH2770 A 15/40'
        WHEN part_name = 'SHORT SS BUCKLE LOOP FACING' THEN 'COH2770 A 32/40'
        WHEN part_name = 'SHORT SS TOP' THEN 'COH2770 A 16/40'
        WHEN part_name = 'SHORT SS FACING' THEN 'COH2770 A 21/40'
        WHEN part_name = 'LONG SS TOP' THEN 'COH2770 A 14/40'
        WHEN part_name = 'GUSSET FLAP HW PATCH BOTTOM' THEN 'COH2770 A 5/40'
        WHEN part_name = 'HANDLE SS KEEPER FACING' THEN 'COH2770 A 9/40'
        WHEN part_name = 'HANDLE SHORT SS BUCKLE LOOP FACING' THEN 'COH2770 A 29/40'
        WHEN part_name = 'HANDLE SS KEEPER TOP' THEN 'COH2770 A 18/40'
        WHEN part_name = 'HANDLE LONG SS FACING' THEN 'COH2770 A 13/40'
        WHEN part_name = 'HANDLE SHORT SS FACING' THEN 'COH2770 A 30/40'
        WHEN part_name = 'HANDLE LONG SS TOP' THEN 'COH2770 A 11/40'
        WHEN part_name = 'KEY HOOD FACING' THEN 'COH2770 A 8/40'
        WHEN part_name = 'KEY HOOD TOP' THEN 'COH2770 A 33/40'
        WHEN part_name = 'KEY HOOD STRAP FACING' THEN 'COH2770 A 10/40'
        WHEN part_name = 'KEY HOOD STRAP' THEN 'COH2770 A 34/40'
        WHEN part_name = 'GUSSET COLLAR' THEN 'COH2770 A 12/40'
        WHEN part_name = 'GUSSET SLASH POCKET RIGHT GUSSET ACCORDION TOP' THEN 'COH2770 A 17/40'
        WHEN part_name = 'GUSSET SLASH POCKET LEFT GUSSET ACCORDION TOP' THEN 'COH2770 A 20/40'
        WHEN part_name = 'BACK' THEN 'COH2770 A 25/40'
        WHEN part_name = 'GUSSET SLASH POCKET' THEN 'COH2770 A 35/40'
        WHEN part_name = 'RIGHT GUSSET D RING ANCHOR FACING' THEN 'COH2770 A 6/40'
        else patternid_bom
    END
WHERE 

--    model = 'UPDATESINGLE_CR981_Glovetanned Leather Juliet Shoulder Bag_JAN-PLAN (COMELZ)_CONS_6,1'
    style_code = 'COH2770'
    and model LIKE '%CAM20%'
    -- and orders_code != 'PGD2-2410-000000062'
    and trunc(start_time) BETWEEN to_date('01-11-2024', 'dd-mm-yyyy') AND to_date('28-11-2024', 'dd-mm-yyyy');

COMMIT;
ROLLBACK;



UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE 
        WHEN part_name = 'HANG TAG TOP' THEN 'COH2702 A 12/22'
        else patternid_bom
    END

WHERE 
    style_code = 'COH2702'
    and model = '24.07.2024 CUTTING MOLD _ CY830 - Signature Textile Jacquard Juliet Shoulder Bag 25 (COMELZ)'
--AND trunc(start_time) = to_date('02-09-2024', 'dd-mm-yyyy');
AND trunc(start_time) BETWEEN to_date('01-10-2024', 'dd-mm-yyyy') AND to_date('21-10-2024', 'dd-mm-yyyy');

-- update data which name Glovetanned Leather Emmy Saddle Bag 23

UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE
        WHEN part_name = 'SS KEEPER FACING1' THEN 'COH2586 A 9/21'
        WHEN part_name = 'SHORT SS TOP1' THEN 'COH2586 A 6/21'
        WHEN part_name = 'SHORT SS BUCKLE LOOP FAICNG' THEN 'COH2586 A 13/21'
        WHEN part_name = 'CENTER DIVIDER GUSSET ACCORDION RIGHT' THEN 'COH2586 A 11/21'
        WHEN part_name = 'SHORT SS FACING' THEN 'COH2586 A 14/21'
        WHEN part_name = 'CENTER DIVIDER GUSSET ACCORDION LEFT GUSSET' THEN 'COH2586 A 17/21'
        WHEN part_name = 'SHELL GUSSET' THEN 'COH2586 A 8/21'
        WHEN part_name = 'FLAP TOP' THEN 'COH2586 A 12/21'
        WHEN part_name = 'HANGTAG TOP' THEN 'COH2586 A 2/21'
        WHEN part_name = 'CENTER DIVIDER GUSSET ACCORDION MIDDLE' THEN 'COH2586 A 18/21'
        WHEN part_name = 'HANGTAG FACING' THEN 'COH2586 A 19/21'
        WHEN part_name = 'SHORT SS FLOATING KEEPER FACING' THEN 'COH2586 A 7/21'
        WHEN part_name = 'HANDLE TOP' THEN 'COH2586 A 16/21'
        WHEN part_name = 'PIPING' THEN 'COH2586 A 4/21'
        WHEN part_name = 'SHORT SS FLOATING KEEPER TOP' THEN 'COH2586 A 1/21'
        WHEN part_name = 'SS KEEPER TOP1' THEN 'COH2586 A 5/21'
        WHEN part_name = 'HANDLE FACING' THEN 'COH2586 A 10/21'
        WHEN part_name = 'LONG SS FACING' THEN 'COH2586 A 15/21'
        WHEN part_name = 'LONG SS TOP' THEN 'COH2586 A 21/21'
        else patternid_bom
    END
WHERE 

--    model = 'UPDATESINGLE_CR981_Glovetanned Leather Juliet Shoulder Bag_JAN-PLAN (COMELZ)_CONS_6,1'
    style_code = 'COH2586'
    and model = 'CV436 - Coated Canvas Signature Cassie Crossbody 19 (COMELZ) CONS 3,2646'
    and trunc(start_time) BETWEEN to_date('01-11-2024', 'dd-mm-yyyy') AND to_date('15-11-2024', 'dd-mm-yyyy');

COMMIT;

-- UPDATE tb_cmz_parts
-- SET patternid_bom = 
--     CASE
--         WHEN part_name = 'BACK SLASH PKT' THEN 'COH2615 A 21/22'
--         WHEN part_name = 'FLAP FACING ANCHOR FACING_' THEN 'COH2615 A 11/22'
--         WHEN part_name = 'FLAP FACING ANCHOR_' THEN 'COH2615 A 2/22'
--         WHEN part_name = 'FLAP TOP' THEN 'COH2615 A 22/22'
--         WHEN part_name = 'FLAP TOP HW WEBBING FACING TOP KEEPER' THEN 'COH2615 A 10/22'
--         WHEN part_name = 'FRONT' THEN 'COH2615 A 12/22'
--         WHEN part_name = 'FRONT BACK PIPING' THEN 'COH2615 A 16/22'
--         WHEN part_name = 'FRONT GUSSET' THEN 'COH2615 A 20/22'
--         WHEN part_name = 'FRONT PKT PIPING' THEN 'COH2615 A 5/22'
--         WHEN part_name = 'FRONT SLASH PKT' THEN 'COH2615 A 7/22'
--         WHEN part_name = 'FRONT WEBBING_' THEN 'COH2615 A 8/22'
--         WHEN part_name = 'SS ANCHOR FACING_' THEN 'COH2615 A 6/22'
--         WHEN part_name = 'SS ANCHOR TOP_' THEN 'COH2615 A 15/22'
--         else patternid_bom
--     END
-- WHERE 

-- --    model = 'UPDATESINGLE_CR981_Glovetanned Leather Juliet Shoulder Bag_JAN-PLAN (COMELZ)_CONS_6,1'
--     style_code = 'COH2615'
--     and model = 'CUTTING MOLD CU110 - Racer Crossbody in Smooth Leather (COMELZ) CONS 7,62'
--     and trunc(start_time) BETWEEN to_date('01-10-2024', 'dd-mm-yyyy') AND to_date('28-10-2024', 'dd-mm-yyyy');

SET DEFINE OFF;
UPDATE tb_cmz_parts
SET patternid_bom = 
    CASE
        WHEN part_name = 'LONG SS FACING' THEN 'COH2638 A 1/30' -- done
        WHEN part_name = 'SHORT SS FLOATING KEEPER TOP' THEN 'COH2638 A 10/30'
        WHEN part_name = 'SHORT SS FLOATING KEEPER FACING' THEN 'COH2638 A 11/30'
        WHEN part_name = 'HANGTAG FAICNG' THEN 'COH2638 A 12/30'
        WHEN part_name = 'PIPING' THEN 'COH2638 A 13/30'
        WHEN part_name = 'FRONT BACK LEFT GUSSET ACCORDION' THEN 'COH2638 A 14/30'
        WHEN part_name = 'SHORT SS BUCKLE LOOP FACING' THEN 'COH2638 A 15/30'
        WHEN part_name = 'HANDLE KEEPER FACING' THEN 'COH2638 A 16/30'
        WHEN part_name = 'HANDLE KEEPER TOP' THEN 'COH2638 A 17/30'
        WHEN part_name = 'SHORT SS FACING' THEN 'COH2638 A 18/30'
        WHEN part_name = 'ANCHOR LOOP FACING' THEN 'COH2638 A 19/30'
        WHEN part_name = 'LONG SS TOP' THEN 'COH2638 A 2/30'
        WHEN part_name = 'HANDLE FACING' THEN 'COH2638 A 20/30'
        WHEN part_name = 'CENTER DIVIDER RIGHT GUSSET ACCORDION' THEN 'COH2638 A 21/30'
        WHEN part_name = 'SHORT SS TOP' THEN 'COH2638 A 22/30'
        WHEN part_name = 'ANCHOR' THEN 'COH2638 A 23/30'
        WHEN part_name = 'CENTER DIVIDER GUSSET ACCORDION' THEN 'COH2638 A 24/30'
        WHEN part_name = 'FRONT BACK  GUSSET ACCORDION' THEN 'COH2638 A 25/30'
        WHEN part_name = 'CENTER DIVIDER BOTTOM' THEN 'COH2638 A 26/30'
        WHEN part_name = 'FLAP TOP' THEN 'COH2638 A 27/30'
        WHEN part_name = 'CENTER DIVIDER LEFT GUSSET ACCORDION' THEN 'COH2638 A 28/30'
        WHEN part_name = 'HANDLE TOP' THEN 'COH2638 A 29/30'
        WHEN part_name = 'BACK SLASH PKT RIGHT&LEFT LINING' THEN 'COH2638 A 3/30'
        WHEN part_name = 'FRONT BACK RIGHT GUSSET ACCORDION' THEN 'COH2638 A 30/30'
        WHEN part_name = 'BACK SLASH PKT' THEN 'COH2638 A 5/30'
        WHEN part_name = 'FRONT' THEN 'COH2638 A 6/30'
        WHEN part_name = 'SHORT SS KEEPER TOP' THEN 'COH2638 A 7/30'
        WHEN part_name = 'SHORT SS KEEPER FACING' THEN 'COH2638 A 8/30'
        WHEN part_name = 'HANG TAG TOP' THEN 'COH2638 A 9/30'
        else patternid_bom
    END
WHERE 

--    model = 'UPDATESINGLE_CR981_Glovetanned Leather Juliet Shoulder Bag_JAN-PLAN (COMELZ)_CONS_6,1'
    style_code = 'COH2638'
    and model = 'MULTI CW565 - Refined Pebble Leather Cassie Crossbody 17 (COMELZ) CONS 3,1533'
    and trunc(start_time) BETWEEN to_date('01-10-2024', 'dd-mm-yyyy') AND to_date('31-10-2024', 'dd-mm-yyyy');

UPDATE tb_cmz_parts
SET patternid_bom = 'COH2570 A 21/22'
WHERE
model LIKE '%CR981%'
-- model = 'UPDATE HANGTAG_CR981_Glovetanned Leather Juliet Shoulder Bag_JAN-PLAN (COMELZ)_CONS_6,1' 
-- And orders_code = 'PGD2-2410-000000104'
AND part_name = 'ANCHOR LOOP FACING'
and trunc(start_time ) between to_date('01-11-2024', 'dd-mm-yyyy') and to_date('21-11-2024', 'dd-mm-yyyy');

COMMIT;