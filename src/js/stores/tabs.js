import Alpine from 'alpinejs';
//--------------------
// TABS
//--------------------
Alpine.store('tabs', {

    openTab: 1,
    content: {
        specstable: '',
        shipterms: '',
        payterms: ''
    },
    activeTabClasses: 'activeTab',
    inactiveTabClasses: 'inActiveTab',
    activeBtnClasses: 'activeBtn',
    inactiveBtnClasses: 'inActiveBtn',

    showActiveTab(tab) {
        return this.openTab === tab ? this.activeTabClasses : this.inactiveTabClasses
    },

    showActiveButton(tab) {
        return this.openTab === tab ? this.activeBtnClasses : this.inactiveBtnClasses
    }

});
