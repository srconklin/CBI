import TypesenseInstantSearchAdapter from "typesense-instantsearch-adapter";

const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
	server: {
	apiKey: process.env.TYPESENSE_SEARCH_ONLY_API_KEY, // Be sure to use an API key that only allows searches, in production
	  nodes: [
		{
			host: process.env.TYPESENSE_HOST,
			port: process.env.TYPESENSE_PORT,
			protocol: process.env.TYPESENSE_PROTOCOL,
		  
		},
	  ],
	},
	additionalSearchParameters: {
	  queryBy: "headline,description,category,mfr,model,keywords",
	},
  });
  const { searchClient } = typesenseInstantsearchAdapter;

  export default searchClient;
  