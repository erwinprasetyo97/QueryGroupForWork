SELECT /*+ use_nl(a b c ptmt bomt ppkg mpmt ca bo aop pkg stm scm)  */  
		    aop.fctname, aop.aono, aop.stylecode, stm.stylename, aop.stylecolorserial || ' - ' || scm.stylecolorways as color, SUM(aop.aoqty) AS AOTARGETQTY, SUM(aop.actual_pg_qty) AS CUTTINGQTY, 
		    CASE 
		        WHEN (SUM(aop.aoqty) - SUM(aop.actual_pg_qty)) &lt; 0 THEN 0 	
		        ELSE (SUM(aop.aoqty) - SUM(aop.actual_pg_qty)) 	
		        END AS REMAINQTY,	
		    CASE 	
		        WHEN (SUM(aop.aoqty) - SUM(aop.actual_pg_qty)) &lt; 0 THEN ABS(SUM(aop.aoqty) - SUM(aop.actual_pg_qty))	
		        ELSE 0 	
		        END AS EXTRA   
		FROM 
		    (SELECT 
		         pkg.fctname, pkg.aono,  pkg.packagegroup, pkg.stylecode, pkg.stylecolorserial, pkg.aoqty ,min(pkg.set_piece) as actual_pg_qty 
		    FROM 
		        (SELECT       
				    fc.fctname, c.aono, c.packagegroup, a.stylecode, a.stylecolorserial, a.patternid, c.aoqty, 
				    c.aoqty * a.pieceqty AS target_piece, SUM(d.total_piece) AS actual_piece, Floor(SUM(d.total_piece) / a.pieceqty) AS set_piece  
		        FROM         
				    mv_t_sd_ptmt a   
				JOIN       
				    (SELECT  
				        itemname,stylecode,stylecolorserial,stylesize,revno,itemcode,itemcolorserial         
				     FROM   
				        mv_t_ad_bomt      
				     GROUP BY  
				        itemname,stylecode,stylecolorserial,stylesize,revno,itemcode,itemcolorserial) b ON a.stylecode = b.stylecode AND a.revno = b.revno AND a.stylesize = b.stylesize AND a.itemcode = b.itemcode AND a.itemcolorserial = b.itemcolorserial  --AND a.stylecolorserial = b.stylecolorserial       
		        JOIN 
				    (SELECT      
				        ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode, mpmt.stylesize, mpmt.stylecolorserial, mpmt.revno, SUM(ppkg.ordqty) AS aoqty  
				     FROM         
				        pkras.mv_t_mx_mpmt mpmt     
				     JOIN     
				        pkras.mv_t_mx_ppkg ppkg ON mpmt.packagegroup = ppkg.packagegroup 
		             WHERE 
		                ppkg.factory LIKE Decode({factory}, 'PIGB', 'PIGB', 'PIGA', 'PIGA', 'PGC1', 'PGC1', 'PGD2', 'PGD2', 'PGD1', 'PGD1', 'PGC2', 'PGC2', 'PGB1', 'PGB1', 'PIGC', 'PIGC' ,'%')  
				     GROUP  BY     
				        ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode,mpmt.stylesize,mpmt.stylecolorserial,mpmt.revno) c ON a.stylecode = c.stylecode AND a.revno = c.revno  AND a.stylesize = c.stylesize AND a.stylecolorserial = c.stylecolorserial      
		        JOIN 
		            (SELECT 'PGD1' AS factory,'I-GC1' AS fctname FROM dual UNION ALL SELECT 'PGD2'  AS factory, 'I-GB2' AS fctname FROM   dual  
		             UNION ALL SELECT factory, name FROM   pkmes.t_cm_fcmt@erp_link) fc ON c.factory = fc.factory 
		        RIGHT OUTER JOIN   
				    (SELECT     
				        a.orders_code, Replace(a.patternid_bom, '/', '') patternid_bom, Count(*) total_piece     
				     FROM       
				        tb_cmz_parts a   
		             WHERE 
		                a.machine_code IN ('k014444','k012757','k014302','k015660','k015444','k015465','k012758','k012562', 'k015533','k014188','k015706','k014577','k014787','k015442','k015463','k014934','k017681','k014932', 
		                'k012565','k017255','k019150','k019186','k019178','k017216','k018864','k017525','k017584') 
				     AND    
				        Extract(month FROM a.start_time) = '08' AND Extract(year FROM a.start_time) = '2024'       
				     GROUP  BY a.orders_code,a.patternid_bom) d ON c.packagegroup = d.orders_code AND Replace(a.patternid, '/', '') = d.patternid_bom       
		        RIGHT OUTER JOIN    
				    (SELECT  
				        ca.stylecode, ca.stylesize, bo.stylecolorserial, ca.revno    
				     FROM  
				        pkerp.t_sd_cadm@erp_link ca	  
		             JOIN	
		                pkerp.t_sd_bomh@erp_link bo on ca.stylecode = bo.stylecode AND ca.stylesize = bo.stylesize AND ca.revno = bo.revno AND     
		                ca.cadrevno = bo.carrevno and ca.stylecolorserial = bo.cadcolorserial  
		             GROUP BY    
		                ca.stylecode, ca.stylesize, bo.stylecolorserial, ca.revno) e ON c.stylecode = e.stylecode AND c.stylesize = e.stylesize AND c.revno = e.revno and c.stylecolorserial = e.stylecolorserial   
		        WHERE 
		            c.packagegroup IS NOT NULL 
		        GROUP BY 
		            fc.fctname, c.aono, c.packagegroup, a.itemcode, a.stylecode, a.stylecolorserial, a.patternid, a.piece, c.aoqty, a.pieceqty) pkg 
		    GROUP BY 
		        pkg.fctname, pkg.aono, pkg.aoqty , pkg.packagegroup, pkg.stylecode, pkg.stylecolorserial)aop
		LEFT JOIN
		    pkerp.t_00_stmt@erp_link stm ON aop.stylecode = stm.stylecode  
		LEFT JOIN
		    pkerp.t_00_scmt@erp_link scm on aop.stylecode = scm.stylecode and aop.stylecolorserial = scm.stylecolorserial  
		GROUP BY 
		     aop.fctname, aop.aono, aop.stylecode, stm.stylename, aop.stylecolorserial, scm.stylecolorways 
		ORDER BY 
		    aop.fctname ASC 

SELECT
         pkg.aono, pkg.packagegroup, pkg.aoqty , min(pkg.set_piece) as actualqty
    FROM
        (SELECT       
		    c. factory, c.aono, c.packagegroup,  c.aoqty, a.itemcode, b.itemname, a.stylecode, a.patternid,  a.piece,  
		    c.aoqty * a.pieceqty AS target_piece, SUM(d.total_piece) AS actual_piece, Floor(SUM(d.total_piece) / a.pieceqty) AS set_piece        
        FROM         
		    mv_t_sd_ptmt a   
		JOIN       
		    (SELECT  
		        itemname,stylecode,stylecolorserial,stylesize,revno,itemcode,itemcolorserial         
		     FROM   
		        mv_t_ad_bomt      
		     GROUP BY  
		        itemname,stylecode,stylecolorserial,stylesize,revno,itemcode,itemcolorserial) b ON a.stylecode = b.stylecode AND a.revno = b.revno AND a.stylesize = b.stylesize AND a.itemcode = b.itemcode AND a.itemcolorserial = b.itemcolorserial  --AND a.stylecolorserial = b.stylecolorserial       
        JOIN 
		    (SELECT      
		        ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode, mpmt.stylesize, mpmt.stylecolorserial, mpmt.revno, SUM(ppkg.ordqty) AS aoqty  
		     FROM         
		        pkras.mv_t_mx_mpmt mpmt         
		     join     
		        pkras.mv_t_mx_ppkg ppkg      
		     ON     
		        mpmt.packagegroup = ppkg.packagegroup         
		     GROUP  BY     
		        ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode,mpmt.stylesize,mpmt.stylecolorserial,mpmt.revno) c ON a.stylecode = c.stylecode AND a.revno = c.revno  AND a.stylesize = c.stylesize AND a.stylecolorserial = c.stylecolorserial      
        JOIN 
            (SELECT 'PGD1' AS factory,'I-GC1' AS fctname FROM   dual UNION ALL SELECT 'PGD2'  AS factory, 'I-GB2' AS fctname FROM   dual  
             UNION ALL SELECT factory, name FROM   pkmes.t_cm_fcmt@erp_link) fc ON c.factory = fc.factory
        RIGHT OUTER JOIN   
		    (SELECT     
		        a.orders_code, Replace(a.patternid_bom, '/', '') patternid_bom, Count(*) total_piece     
		     FROM       
		        tb_cmz_parts a   
             WHERE 
                a.machine_code IN ('k014444','k012757','k014302','k015660','k015444','k015465','k012758','k012562', 'k015533','k014188','k015706','k014577','k014787','k015442','k015463','k014934','k017681','k014932', 
                'k012565','k017255','k019150','k019186','k019178','k017216','k018864','k017525','k017584') 
		     AND    
		        Extract(month FROM a.start_time) = '09' AND Extract(year FROM a.start_time) = '2024'      
		     GROUP  BY a.orders_code,a.patternid_bom) d ON c.packagegroup = d.orders_code AND Replace(a.patternid, '/', '') = d.patternid_bom       
        RIGHT OUTER JOIN    
		    (SELECT  
		        ca.stylecode, ca.stylesize, bo.stylecolorserial, ca.revno, ca.vendor, bo.carrevno, bo.cadcolorserial    
		     FROM  
		        pkerp.t_sd_cadm@erp_link ca	  
             JOIN	
                pkerp.t_sd_bomh@erp_link bo on ca.stylecode = bo.stylecode AND ca.stylesize = bo.stylesize AND ca.revno = bo.revno AND     
                ca.cadrevno = bo.carrevno and ca.stylecolorserial = bo.cadcolorserial  
             GROUP BY    
                ca.stylecode, ca.stylesize, bo.stylecolorserial, ca.revno, ca.vendor, bo.carrevno, bo.cadcolorserial) e ON c.stylecode = e.stylecode AND c.stylesize = e.stylesize AND c.revno = e.revno and c.stylecolorserial = e.stylecolorserial   
		WHERE      
		    c.aono = 'AD-COH-9104'
        AND 
            c.stylecode = 'COH2513'
        AND
            c.stylecolorserial = '001'
        AND 
            fc.fctname = 'I-GB1'
		GROUP BY 
            c. factory, c.aono, c.packagegroup, c.aoqty, a.itemcode, b.itemname, a.patternid, a.piece, c.aoqty, a.pieceqty, a.stylecode, a.stylesize, e.stylecolorserial, a.revno) pkg 
    GROUP BY 
        pkg.aono, pkg.packagegroup, pkg.aoqty
        
-- query baru
SELECT
         pkg.aono, pkg.packagegroup, pkg.aoqty , min(pkg.set_piece) as actualqty
    FROM
        (SELECT       
		    c. factory, c.aono, c.packagegroup,  c.aoqty, a.itemcode, b.itemname, a.stylecode, a.patternid,  a.piece,  
		    c.aoqty * a.pieceqty AS target_piece, d.total_piece, Floor(d.total_piece / a.pieceqty) AS set_piece        
        FROM         
		    mv_t_sd_ptmt a   
		JOIN       
		    (SELECT  
		        itemname,stylecode,stylecolorserial,stylesize,revno,itemcode,itemcolorserial         
		     FROM   
		        mv_t_ad_bomt      
		     GROUP BY  
		        itemname,stylecode,stylecolorserial,stylesize,revno,itemcode,itemcolorserial) b ON a.stylecode = b.stylecode AND a.revno = b.revno AND a.stylesize = b.stylesize AND a.itemcode = b.itemcode AND a.itemcolorserial = b.itemcolorserial  --AND a.stylecolorserial = b.stylecolorserial       
        JOIN 
		    (SELECT      
		        ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode, mpmt.stylesize, mpmt.stylecolorserial, mpmt.revno, SUM(ppkg.ordqty) AS aoqty  
		     FROM         
		        pkras.mv_t_mx_mpmt mpmt     
		     join     
		        pkras.mv_t_mx_ppkg ppkg      
		     ON     
		        mpmt.packagegroup = ppkg.packagegroup         
		     GROUP  BY     
		        ppkg.factory, ppkg.aono, mpmt.packagegroup, mpmt.stylecode,mpmt.stylesize,mpmt.stylecolorserial,mpmt.revno) c ON a.stylecode = c.stylecode AND a.revno = c.revno  AND a.stylesize = c.stylesize AND a.stylecolorserial = c.stylecolorserial      
        JOIN 
            (SELECT 'PGD1' AS factory,'I-GC1' AS fctname FROM   dual UNION ALL SELECT 'PGD2'  AS factory, 'I-GB2' AS fctname FROM   dual  
             UNION ALL SELECT factory, name FROM   pkmes.t_cm_fcmt@erp_link) fc ON c.factory = fc.factory
        RIGHT OUTER JOIN   
		    (SELECT     
		        a.orders_code, Replace(a.patternid_bom, '/', '') patternid_bom, Count(*) total_piece     
		     FROM       
		        tb_cmz_parts a   
             WHERE 
                a.machine_code IN ('k014444','k012757','k014302','k015660','k015444','k015465','k012758','k012562', 'k015533','k014188','k015706','k014577','k014787','k015442','k015463','k014934','k017681','k014932', 
                'k012565','k017255','k019150','k019186','k019178','k017216','k018864','k017525','k017584') 
		     AND    
		        Extract(month FROM a.start_time) = 10 AND Extract(year FROM a.start_time) = 2024       
		     GROUP  BY a.orders_code,a.patternid_bom) d ON c.packagegroup = d.orders_code AND Replace(a.patternid, '/', '') = d.patternid_bom       
        RIGHT OUTER JOIN    
		    (SELECT  
		        ca.stylecode, ca.stylesize, bo.stylecolorserial, ca.revno, ca.vendor, bo.carrevno, bo.cadcolorserial    
		     FROM  
		        pkerp.t_sd_cadm@erp_link ca	  
             JOIN	
                pkerp.t_sd_bomh@erp_link bo on ca.stylecode = bo.stylecode AND ca.stylesize = bo.stylesize AND ca.revno = bo.revno AND     
                ca.cadrevno = bo.carrevno and ca.stylecolorserial = bo.cadcolorserial  
             GROUP BY    
                ca.stylecode, ca.stylesize, bo.stylecolorserial, ca.revno, ca.vendor, bo.carrevno, bo.cadcolorserial) e ON c.stylecode = e.stylecode AND c.stylesize = e.stylesize AND c.revno = e.revno and c.stylecolorserial = e.stylecolorserial   
        WHERE      
            c.aono = 'AD-COH-9203' --{aoNo} 
        AND 
            c.stylecode = 'COH2638' --{styleCode} 
        AND 
            c.stylecolorserial = '002' --{styleColorSerial} 
        AND 
            fc.fctname = 'I-GB1'--{factoryName} 
		GROUP BY 
            c. factory, c.aono, c.packagegroup, c.aoqty, a.itemcode, b.itemname, a.patternid, a.piece, c.aoqty, a.pieceqty, a.stylecode, a.stylesize, e.stylecolorserial, a.revno, d.total_piece) pkg 
    GROUP BY 
        pkg.aono, pkg.packagegroup, pkg.aoqty;

