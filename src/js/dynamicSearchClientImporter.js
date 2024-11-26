
const importSearchClient = async ()  => {
    if (process.env.SE === 'typesenseSearch') {
        const module = await import('./typesenseSearch.js');
        return module.default;
    } else {
        const module = await import('./algoliaSearch.js');
        return module.default;
    }
}

export default importSearchClient;