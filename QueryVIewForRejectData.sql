-- query untuk melihat data reject comel machine
SELECT 
    a.start_time, 
    a.machine_code,
    a.models,
    a.orders_code,
    a.operatore,
    a.code_hides
FROM tb_cmz_hides a
WHERE
    (INSTR(a.orders_code, 'R') > 0 OR INSTR(a.orders_code, 'J') > 0)
    and a.orders_code NOT IN ('KURANGAN', 'PRESS')
--    and a.models LIKE '%CW566%'
--    and TRUNC(a.start_time) = TO_DATE('01-10-2024', 'dd-mm-yyyy');
    and TRUNC(a.start_time) BETWEEN TO_DATE('17-10-2024', 'dd-mm-yyyy') AND TO_DATE('23-10-2024', 'dd-mm-yyyy');

-- query for cecking reject data
WITH ranked_data AS (
    SELECT 
        a.start_time, 
        a.machine_code,
        a.models,
        a.orders_code,
        a.operatore,
        a.code_hides,
        ROW_NUMBER() OVER (PARTITION BY a.orders_code ORDER BY a.start_time) AS rn
    FROM TB_CMZ_HIDES a
    WHERE
        (INSTR(a.orders_code, 'R') > 0 OR INSTR(a.orders_code, 'J') > 0)
        and a.orders_code NOT IN ('KURANGAN', 'PRESS', 'COLLAR', 'LYR', 'MLYR')
        AND TRUNC(a.start_time) BETWEEN TO_DATE('17-10-2024', 'dd-mm-yyyy') AND TO_DATE('23-10-2024', 'dd-mm-yyyy')
)
SELECT 
    start_time, 
    machine_code,
    models,
    orders_code,
    operatore,
    code_hides
FROM ranked_data
WHERE rn = 1;   
