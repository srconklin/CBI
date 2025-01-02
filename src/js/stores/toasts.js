import Alpine from 'alpinejs';
import { getConfigSetting } from '../config';

//--------------------
// TOASTS
//--------------------
Alpine.store('toasts', {
    counter: 0,
    list: [],
    containerTop: '-50px',

    createToast({title, message, type = "info"}) {
        const index = this.list.length;
        let totalVisible = this.list.filter((toast) => toast.visible).length + 1;

        this.list.push({
            id: this.counter++,
            message,
            title,
            type,
            visible: true,
        });

        if (this.list.length > 0) {
            this.showContainer();
        }

        if (type != 'info') {
            setTimeout(() => {
                this.destroyToast(index);
            }, 2500 * totalVisible);
        }
    },

    destroyToast(index) {
        this.list[index].visible = false;
        this.list.splice(index, 1);

        if (this.list.length === 0) {
            this.hideContainer();
        }
    },

    showContainer() {
        this.containerTop = '0';
    },

    hideContainer() {
        setTimeout(() => {
            this.containerTop = '-50px';
        }, 500); // Delay to allow for the toast leave transition
    },

    makeToast() {
        let keys = Object.keys(sessionStorage);
        for (let key of keys) {
            let toast = getConfigSetting('toasts', key);
            if (toast) {
                // Convert placeholders to live data
                toast.title = toast.title.replace('firstName', sessionStorage.getItem('firstName'));
                this.createToast(toast);
            }
        }
        sessionStorage.clear();
    }
});
