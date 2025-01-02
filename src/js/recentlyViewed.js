

const getRecentlyViewedItems = () => {
    const cookieValue = window.getCookie('recentlyViewedItems');
    return cookieValue ? JSON.parse(cookieValue) : [];
};


const createCardHtml = ({ mainImage, headline, mfr, model, location, URI, itemno }) => `
    <div class="mini-item-card">
        <img src="${mainImage}" alt="${headline}">
        <div class="content">
            <h1 itemprop="name" class="headline">${headline}</h1>
            <div class="specs-summary mt-2">
                <p itemprop="manufacturer" class="mfr">
                    <span>Make:</span>
                    <span>${mfr}</span>
                </p>
                <p itemprop="model" class="model">
                    <span>Model:</span>
                    <span>${model}</span>
                </p>
                <p class="location">
                    <span>Location:</span>
                    <span>${location}</span>
                </p>
                <p itemprop="productID" class="itemno">
                    <span>Item ID:</span>
                    <span><a href="${URI}">${itemno}</a></span>
                </p>
            </div>
        </div>
    </div>
`;

// const getItems = async () => {
//     const recentlyViewedItems = getRecentlyViewedItems();

//     if (recentlyViewedItems.length > 0) {
//         const items = await fetchItemDetails(recentlyViewedItems);
//         return items;
//     }
//     return [];
// };
const getItems = async () => {
    const recentlyViewedItems = getRecentlyViewedItems();
    if (recentlyViewedItems.length > 0) {
        const path = `recentlyviewed/items/${recentlyViewedItems.join('/')}`;
        return window.httprequest(path, {
            method: 'GET'
        }).then(data => {
            return data.payload;
        }).catch(error => {
            console.error('Error fetching item details:', error);
            return [];
        });
    }
    return [];
};



export {getItems, createCardHtml };
