/* eslint-disable */

// Start Typesense server with `npm run typesenseServer`
// Then run `npm run populateTypesenseIndex` or `node populateTypesenseIndex.js`

require('dotenv').config();
const Typesense = require('typesense');

module.exports = (async () => {
  const typesense = new Typesense.Client({
    nodes: [
      {
        host: process.env.TYPESENSE_HOST,
			  port: process.env.TYPESENSE_PORT,
			  protocol: process.env.TYPESENSE_PROTOCOL,
      },
    ],
    apiKey: process.env.TYPESENSE_ADMIN_API_KEY,
  });


  
  const schema = {
    name: process.env.INDEX,
    fields: [
      { name: 'itemno', type: 'int32',  facet: false},
      { name: 'headline', type: 'string',  facet: false },
      { name: 'description', type: 'string',  facet: false },
      { name: 'category', type: 'string',  facet: false},
      { name: 'mfr', type: 'string',  facet: true },
      { name: 'model', type: 'string',  facet: false },
      { name: 'price', type: 'string',  facet: false },
      { name: 'unixTimeStamp', type: 'int32',  facet: true },
      { name: 'isFeatured', type: 'int32',  facet: true },
      { name: 'keywords', type: 'string',  facet: false },
      { name: 'popular', type: 'int32',  facet: false },
      { name: 'categories.lvl[0-5]',  type: 'auto', facet: true},
    ],
    default_sorting_field: 'popular',
  };

  console.log('Populating index in Typesense');

  try {
    await typesense.collections(process.env.INDEX).delete();
    console.log('Deleting existing collection');
  } catch (error) {
    console.log(error);
  }

  console.log('Creating schema: ');
  console.log(JSON.stringify(schema, null, 2));
  await typesense.collections().create(schema);
  
  console.log('Adding records: ');
  
  const thecollection = require('../../data/items.json');

  try {
    const returnData = await typesense
      .collections(process.env.INDEX)
      .documents()
      .import(thecollection);
    console.log(returnData);
    console.log('Done indexing.');

    const failedItems = returnData.filter(item => item.success === false);
    if (failedItems.length > 0) {
      throw new Error(
        `Error indexing the collection ${JSON.stringify(failedItems, null, 2)}`
      );
    }

    return returnData;
  } catch (error) {
    console.log(error);
  }
})();
