component accessors=true {

    property config;
    property utils;


	function getGeoByGID( required number GID ) {
		
        var params = {
            GID: arguments.GID,
        };
            
        var sql ='Select * FROM GeoData Where GID = :GID;'

        var arGeo = queryExecute( sql, params,  { returntype="array" });
        
        return arGeo;

	}		
	number function getInvPnoforItem( required number itemno ) {
		
        var params = {
            itemno: arguments.itemno,
        };
            
        var sql ='SELECT VI.PNo as InvPNo
            FROM Items I
            INNER JOIN CoVenues VI ON VI.VTID=I.IVTID
            WHERE ItemNo = :itemno';

        var arRS = queryExecute( sql, params, { returntype="array" });
        
        return arRS[1].InvPNo;

	}		
	function toggleFavorite( required number itemno =0, required number pno, required boolean isfavorite ) {

		if(arguments.itemno gt 0 and arguments.pno gt 0) {
            
            cfstoredproc( procedure="setUserFavorites") {
                cfprocparam( cfsqltype="cf_sql_integer", value=arguments.itemno );
                cfprocparam( cfsqltype="cf_sql_integer", value=arguments.pno );
                cfprocparam( cfsqltype="cf_sql_bit", value=arguments.isfavorite?1:0);
            }
        }
	}		
    
    function getHotMfrs() {
                 
        var sql ='SELECT top 10 I.maketxt
        FROM items I
        INNER JOIN CoVenues VP ON VP.VTID=I.VTID
        INNER JOIN OpsClasses C on C.VTID=#config.getSetting('TRANSVTID')# AND C.classTID=I.dataTID AND C.vizPagetop <= 0
        WHERE I.ArchDt IS NULL AND I.IVTID=#config.getSetting('IVTID')# 
        AND (I.vizPub>=9 OR (I.PNo=0 AND 9 <= VP.viz)) 
        AND (I.Qty>0 OR I.inAuction=1 OR 0 >= 3) AND (I.Qty>0 OR I.OfferBid=1 OR I.inAuction>0 ) AND I.OfferBid=0
        group by I.maketxt 
        order by count(I.maketxt) desc 
        ';

        var qryResult = queryExecute( sql, {}, { cachedWithin: createTimeSpan(0, 24, 0, 0)  });
        
        return qryResult;
    }

    function getSpecialityItems(string type='isnew', string listofitems='') {
		var pg = '';

        
        var params = { 
            listofitems: { 
                value: arguments.listofitems, 
                cfsqltype: "cf_sql_varchar", 
                list: true 
            } 
        };

        var sql ="SELECT top 10 I.Cotid, I.IVTID, I.DataTID, I.Itemno, I.headline, I.maketxt as mfr, I.model, 
            I.isFeatured, I.isNew,I.pagetitle, I.imgServNameMn,
             C.LNm as category,
            CONCAT(geo.citySnm, ', ', geo.stSnm, ' ', geo.CySnm) AS location,
            '' as mainImage,
            '' as URI
            FROM items I
            INNER JOIN CoVenues VP ON VP.VTID=I.VTID
            INNER JOIN OpsClasses C on C.VTID=#config.getSetting('TRANSVTID')# AND C.classTID=I.dataTID AND C.vizPagetop <= 0
            OUTER APPLY dbo.getGeoData(I.LLocGID,I.LStPGID,I.LCyGID) as geo
            WHERE";

            if (type eq 'featureds') {
                sql ="#sql# isfeatured = 1";
            } else  if (type eq 'isnew') { 
                sql ="#sql# isnew = 1";
            }
            else if (type eq 'recentlyviewed') { 
                sql ="#sql# itemno in ( :listofitems) ";
            } else {
                sql ="#sql# 1=0"
            }
                     

            sql ="#sql# AND I.ArchDt IS NULL AND I.IVTID=#config.getSetting('IVTID')# 
			AND (I.vizPub>=9 OR (I.PNo=0 AND 9 <= VP.viz)) 
            AND (I.Qty>0 OR I.inAuction=1 OR 0 >= 3)  AND (I.Qty>0 OR I.OfferBid=1 OR I.inAuction>0 ) AND I.OfferBid=0";

         var qryResult = queryExecute( sql, params,  { 
                cachedWithin: createTimeSpan(0, 24, 0, 0),  // Cache for 24 hours
             });
        

            // Transform query in-place
            for (row in qryResult) {
                
                pg = len(qryResult.pagetitle[qryResult.currentRow]) gt 0 ?  trim(REReplaceNoCase(qryResult.pagetitle[qryResult.currentRow],"(<[^>]*>|&nbsp;|<br>)", " ","All")) : qryResult.headline[qryResult.currentRow] ;

                qryResult.headline[qryResult.currentRow] = trim(REReplaceNoCase(
                    qryResult.headline[qryResult.currentRow], 
                    "(<[^>]*>|&nbsp;|<br>)", 
                    " ", 
                    "All"
                ));

                if (len(qryResult.imgServNameMn))
                    qryResult.mainImage[qryResult.currentRow] = "#config.getSetting('Imgbase')##Trim(qryResult.COTID[qryResult.currentRow])#/#qryResult.IVTID[qryResult.currentRow]#/#Trim(Right(qryResult.DataTID[qryResult.currentRow],2))#/#qryResult.DataTID[qryResult.currentRow]#/#qryResult.imgServNameMn[qryResult.currentRow]#";
                else
                   qryResult.mainImage[qryResult.currentRow] = "#config.getSetting('Imgbase')#no-image.png"; 

                
                qryResult.URI[qryResult.currentRow] = variables.utils.buildURI(qryResult.itemno[qryResult.currentRow], pg);
            
              }
        
        return qryResult;

	}									
      
						
	function getVenueContacts() {
		
        var params = {
            VTID: #config.getSetting('VTID')#,
        };
            
        var sql ='SELECT VV.AdmEmail as VenAdmEmail,VI.AdmEmail AS InvAdmEmail,VI.ccEmail,VV.LNm AS VenLNm 
                FROM CoVenues VV
                INNER JOIN CoVenues VI ON VI.VTID=VV.IVTID
                WHERE VV.VTID = :VTID'

        var arContacts = queryExecute( sql, params,  { 
                 cachedWithin: createTimeSpan(0, 24, 0, 0),  // Cache for 24 hours
                returntype="array"
             });
        
        return arContacts[1];

	}					
}