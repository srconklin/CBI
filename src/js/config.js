const config = {
    'toasts': {
        'register': {
            title: 'Welcome! Your new profile was sucessfully created',
            message: 'You can view or change your membership by visiting <a href="/myprofile">My Account</a>.',
            type: 'info'

        },
        'offer': {
            title: 'Success! Your offer was recieved',
            message: 'Someone will contact you soon.',
            type: 'success'

        },
        'inquiry': {
            title: 'Success! Your message was recieved',
            message: 'Someone will contact you soon.',
            type: 'success'

        },
        'isNewPerson': {
            title: 'Welcome firstName, We created a user account for you!',
            message: 'Consider verifying your email, setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.',
            type: 'info'

        },
        'hasNotLoggedIn': {
            title: 'Welcome Back firstName!',
            message: 'We noticed you have made an offer/inquiry before. Consider verifying  your email, setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.',
            type: 'info'

        },
        'loginviaForm': {
            title: 'Welcome Back firstName!',
            message: 'We have logged you in to simplify making additional inquiries and offers. You can view or change your membership by visiting <a href="/myprofile">My Account</a>.',
            type: 'info'

        },
        'updatecontactinfo': {
            title: 'Success!',
            message: 'Contact information was updated',
            type: 'success'

        }
    }

}

// if (sessionStorage.getItem('register'))
// this.createToast('Welcome! Your new profile was sucessfully created', 'You can view or change your membership by visiting <a href="/myprofile">My Account</a>.', 'info');
// if (sessionStorage.getItem('offer'))
// this.createToast('Success! Your offer was recieved', 'Someone will contact you soon.', 'success');
// if (sessionStorage.getItem('inquiry'))
// this.createToast('Success! Your message was recieved', 'Someone will contact you soon.', 'success');
// if (sessionStorage.getItem('isNewPerson'))
// this.createToast('Welcome firstName! We created a user account for you!', 'Consider verifying your email, setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.', 'info');
// else if (sessionStorage.getItem('hasNotLoggedIn'))
// this.createToast('Welcome Back firstName!', 'We noticed you have made an offer/inquiry before. Consider verifying  your email, setting a password and completing your profile to enjoy all the benefits of a membership by visiting <a href="/myprofile">My Account</a>.', 'info');
// else if (sessionStorage.getItem('loginviaForm'))
// this.createToast('Welcome Back firstName!', 'We have logged you in to simplify making additional inquiries and offers. You can view or change your membership by visiting <a href="/myprofile">My Account</a>.', 'info');
// else if (sessionStorage.getItem('updatecontactinfo'))
// this.createToast('Success!', 'Contact information was updated', 'success');




// util to return requested setting
export const getConfigSetting = (setting, key) => {
    const section = config[setting];
    if (section.hasOwnProperty(key))
        return section[key];
    else
        return null;


};
