--SELECT TO_CHAR(a.start_time,'DD-MM-YYYY') as start_date, a.models, a.orders_code, b.empname,  b.empid, a.code_hides, a.machine_code 
--FROM tb_cmz_hides a 
--		 LEFT JOIN mv_t_mx_mpmt b 
--		 ON a.orders_code = b.packagegroup 
--		 LEFT JOIN mv_hr_emp_master b 
--		 ON a.operatore = b.empid 
--WHERE 
--    trunc(a.start_time) BETWEEN to_date('02-09-2024', 'dd-mm-yyyy') AND to_date('30-09-2024', 'dd-mm-yyyy')
----    trunc(a.start_time) = to_date('27-09-2024', 'dd-mm-yyyy')
--    AND (b.packagegroup IS NULL 
--		                OR b.empid IS NULL)
--    AND a.models IS NOT NULL
--    AND a.models != 'esempio'
----    AND a.models = 'BODY C0689__POLISHED PEBBLE LEATHER WILLOW TOTE (COMELZ) CONS 7,15'
----    AND a.orders_code != 'PGC1-2408-000000021'
--    AND a.orders_code LIKE 'N%'
----  filter for COMELZ and NESTING B1
----    AND a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465', 'k012393', 'k015468', 'k014948', 'k017592', 'k014870', 'k017264')
----  filter for COMELZ only B1
----    AND a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465')
----  filter for COMELZ and NESTING B2
----    AND a.machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706', 'k015537', 'k015273', 'k015211')
----  filter for COMELZ only B2
----    AND a.machine_code IN ('k012758','k012562', 'k015533', 'k014188')
--    GROUP BY a.models,
--         TO_CHAR(a.start_time,'DD-MM-YYYY'), 
--         a.orders_code, 
--         b.empname,  
--         b.empid, 
--         a.code_hides, 
--         a.machine_code
--    ORDER BY start_time DESC,code_hides,machine_code


SELECT TO_CHAR(MIN(a.start_time), 'DD-MM-YYYY') as start_date, 
       a.models, 
       MIN(a.orders_code) as orders_code,
       MAX(b.empname) as empname,  
       MAX(b.empid) as empid, 
       MIN(a.code_hides) as code_hides, 
       MIN(a.machine_code) as machine_code
FROM tb_cmz_hides a 
LEFT JOIN mv_t_mx_mpmt b 
    ON a.orders_code = b.packagegroup 
LEFT JOIN mv_hr_emp_master b 
    ON a.operatore = b.empid
WHERE trunc(a.start_time) between to_date('01-09-2024', 'dd-mm-yyyy') and to_date('30-09-2024', 'dd-mm-yyyy')
    AND (b.packagegroup IS NULL OR b.empid IS NULL)
    AND a.models IS NOT NULL
    AND a.models LIKE '%Glovetanned Leather Juliet Shoulder Bag 25%'
    AND a.models != 'esempio'
--    AND a.machine_code IN ('k014444','k012757', 'k014302', 'k015660', 'k015444', 'k015465','k012758','k012562', 'k015533', 'k014188')
    AND a.machine_code IN ('k012758','k012562', 'k015533', 'k014188', 'k015706')
--    AND a.orders_code LIKE 'N%' -- Filter untuk orders_code yang dimulai dengan "N" atau "n"
GROUP BY a.models
ORDER BY MIN(a.start_time) DESC, MIN(a.code_hides), MIN(a.machine_code);


