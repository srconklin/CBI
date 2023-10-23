import Alpine from 'alpinejs';
import { getConfigSetting } from '../config';

//--------------------
// TOASTS
//--------------------
Alpine.store('toasts', {

    counter: 0,
    list: [],

    //title, message, type = "info"
    createToast({title, message, type = "info"}) {
        const index = this.list.length
        let totalVisible =
            this.list.filter((toast) => {
                return toast.visible
            }).length + 1
        this.list.push({
            id: this.counter++,
            message,
            title,
            type,
            visible: true,
        })
        if (type != 'info') {
            setTimeout(() => {
                this.destroyToast(index)
            }, 2500 * totalVisible)
        }

    },

    destroyToast(index) {
        this.list[index].visible = false
    },

    makeToast() {

        let keys = Object.keys(sessionStorage);
        for(let key of keys) {
          
           let toast = getConfigSetting('toasts', key)
           if (toast) {
            // convert placeholders to live data
            toast.title = toast.title.replace('firstName', sessionStorage.getItem('firstName'))
            this.createToast(toast);
           }
           
        }
        sessionStorage.clear();
    }
});
