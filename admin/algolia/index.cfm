<cfparam name="url.reset" default="false" />

<cfscript>
	
	algoliaClient = new modules.algoliacfc.algolia( applicationId = 'S16PTK744D', apiKey = '0bc8ea1d8e8429fc08176aa64cc3121e' );

	index = algoliaClient.initIndex( 'cbi' );
	
//	if(url.reset) {
		//clear the index	
		index.clearIndex();
		
		//unlink the replicas
		index.setSettings(settings={ 
			'replicas' : []
		});

		//reference the replica index
		//replica = algoliaClient.initIndex( 'recently_added' );

		// delete the replica index
		// replica.deleteIndex();
		
		// delete the priamry index
		index.deleteIndex();

		//recreate the index with replica
		index = algoliaClient.initIndex( 'cbi' );

		writeOutput('<p>index deleted</p>');
	
//	} else {

			items = deserializeJSON( fileRead(ExpandPath( "../../" ) & '/data/items.json' ) );
			index.addObjects( items );

			index.setSettings(settings={ 
					'replicas' : [
						'recently_added'
					]
			});

			index.setSettings(settings={ 
				'searchableAttributes' : ['headline', 'description', 'category', 'mfr', 'model', 'price', 'keywords'],
				'customRanking': ['desc(popular)', 'desc(isFeatured)',  'desc(unixTimeStamp)'],
				'attributesForFaceting' : ['searchable(categories.lvl0)', 'searchable(categories.lvl1)',  'searchable(categories.lvl2)',  'searchable(categories.lvl3)',  'searchable(categories.lvl4)',  'searchable(categories.lvl5)', 'searchable(mfr)'],
				'replicas' : [
					'recently_added'
				]
			}, forwardToReplicas = true);


			// reference the replica index
			replica = algoliaClient.initIndex( 'recently_added' );
			replica.setSettings(settings={
				'ranking' : [
					'desc(unixTimeStamp)',
					'typo',
					'geo',
					'words',
					'filters',
					'proximity',
					'attribute',
					'exact',
					'custom'

				]
			});

			writeOutput('<p>index created and sent to algolia</p>');
//}	
</cfscript>

