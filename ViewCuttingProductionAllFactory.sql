SELECT 
		    ext.fctname, ext.aono, ext.stylecode, ext.stylename, ext.stylecolorserial || ' - ' || ext.stylecolorways as color , SUM(ext.aoqty) AS aotargetqty, SUM(ext.actualcutqty) AS cuttingqty, 
		    CASE 
                WHEN (SUM(ext.aoqty) - SUM(ext.actualcutqty)) < 0 THEN 0 	
                ELSE (SUM(ext.aoqty) - SUM(ext.actualcutqty)) 	
                END AS remainqty,	
            CASE 	
                WHEN (SUM(ext.aoqty) - SUM(ext.actualcutqty)) < 0 THEN ABS(SUM(ext.aoqty) - SUM(ext.actualcutqty))	
                ELSE 0 	
                END AS EXTRA  	

		FROM
		    (SELECT   
		        a.fctname, b.aono, b.packagegroup, b.stylecode, d.stylename,  b.stylecolorserial, e.stylecolorways, min(c.set_piece) AS actualcutqty, b.aoqty 
		    FROM  
		        (SELECT 'PGD1' AS factory,'I-GC1' AS fctname FROM   dual UNION ALL SELECT 'PGD2'  AS factory, 'I-GB2' AS fctname FROM   dual 
		         UNION ALL SELECT factory, name FROM pkmes.t_cm_fcmt@erp_link) a  
		    JOIN 
		        (SELECT   
		            ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode, mpmt.stylesize, mpmt.stylecolorserial, mpmt.revno, SUM(ppkg.ordqty) AS aoqty 
		         FROM     
		            pkras.mv_t_mx_mpmt mpmt 
		         JOIN   
		            pkras.mv_t_mx_ppkg ppkg ON mpmt.packagegroup = ppkg.packagegroup 
		         WHERE  
		            ppkg.factory = 'PGC1'
		            --'PIGB', 'PIGA', 'PGC1', 'PGD2', 'PGD1', 'PGC2', 'PGB1', 'PIGC'
		         GROUP  BY   
		            ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode, mpmt.stylesize, mpmt.stylecolorserial, mpmt.revno) b ON a.factory = b.factory 
		    JOIN  
		        (SELECT 
		            parts.orders_code, ptmt.stylecode, ptmt.stylecolorserial, ptmt.stylesize, ptmt.revno, ptmt.itemcode, ptmt.itemcolorserial, ptmt.patternid, floor(SUM(parts.total_piece) / ptmt.pieceqty) AS set_piece   
		         FROM   
		            mv_t_ad_bomt bomt  
		         JOIN 
		            mv_t_sd_ptmt ptmt ON bomt.stylecode = ptmt.stylecode AND bomt.revno = ptmt.revno AND bomt.stylecolorserial = ptmt.stylecolorserial AND bomt.stylesize = ptmt.stylesize AND bomt.itemcode = ptmt.itemcode AND bomt.itemcolorserial = ptmt.itemcolorserial   
		         JOIN 
		            (SELECT   
		                a.orders_code, replace(a.patternid_bom, '/', '') patternid_bom, count(*) total_piece 
		             FROM     
		                tb_cmz_parts a  
		             WHERE
                        a.machine_code IN ('k014444','k012757','k014302','k015660','k015444','k015465','k012758','k012562', 'k015533','k014188','k015706','k014577','k014787','k015442','k015463','k014934','k017681','k014932',
                        'k012565','k017255','k019150','k019186','k019178','k017216','k018864','k017525','k017584')
                     -- AND extract(month FROM a.start_time) = {bulan} AND extract(year FROM a.start_time) = {tahun} 
		             GROUP BY   
		                a.orders_code, a.patternid_bom) parts ON parts.patternid_bom = replace(ptmt.patternid, '/', '') 
		         GROUP BY  
		            parts.orders_code, ptmt.stylecode, ptmt.stylecolorserial, ptmt.stylesize, ptmt.revno, ptmt.itemcode, ptmt.itemcolorserial, ptmt.patternid, ptmt.pieceqty) c  
		         ON  b.packagegroup = c.orders_code AND b.stylecode = c.stylecode AND b.stylecolorserial = c.stylecolorserial AND b.stylesize = c.stylesize AND b.revno = c.revno   
		    JOIN 
		        pkerp.t_00_stmt@erp_link d ON b.stylecode = d.stylecode   
		    JOIN 
		        pkerp.t_00_scmt@erp_link e on b.stylecode = e.stylecode and b.stylecolorserial = e.stylecolorserial   
		    GROUP BY 
		        a.fctname, b.aono, b.packagegroup, b.stylecode, d.stylename, b.stylecolorserial, e.stylecolorways, b.aoqty )ext   
		GROUP BY ext.fctname, ext.aono, ext.stylecode, ext.stylename, ext.stylecolorserial, ext.stylecolorways 
		ORDER BY  
		    ext.fctname ASC