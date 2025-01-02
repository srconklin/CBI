<script>
function getCookie(name) {
    const value = `; ${document.cookie}`;
    const parts = value.split(`; ${name}=`);
    if (parts.length === 2) return parts.pop().split(';').shift();
    return null; // Return null if the cookie is not found
}

function setCookie(name, value, days) {
    const date = new Date();
    date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
    const expires = `; expires=${date.toUTCString()}`;
    document.cookie = `${name}=${value || ''}${expires}; path=/`;
}

function addRecentlyViewedItem(itemNumber) {
    // Retrieve the current list from cookies
    let viewedItems = JSON.parse(getCookie('recentlyViewedItems') || '[]');

    // Check if item already exists
    if (!viewedItems.includes(itemNumber)) {
        // Add new item
        viewedItems.push(itemNumber);

        // Limit to last 10 items
        if (viewedItems.length > 10) {
            viewedItems.shift();
        }

        // Save updated list to cookies
        setCookie('recentlyViewedItems', JSON.stringify(viewedItems), 7);
    }
}

function getRecentlyViewedItems() {
    const cookieValue = getCookie('recentlyViewedItems');
    if (cookieValue) {
        return JSON.parse(cookieValue);
    }
    return [];
}

// Example usage
addRecentlyViewedItem('item1');
addRecentlyViewedItem('item2');

const viewedItems = getRecentlyViewedItems();
viewedItems.forEach(item => {
    console.log('Recently viewed item:', item);
});

</script>
