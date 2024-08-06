const config = {
    'toasts': {
        'register': {
            title: 'Welcome! Your new profile was sucessfully created',
            message: 'Please check your email to verify your account. You can then manage your membership by visiting  the My Profile section',
            type: 'info'

        },
        'offer': {
            title: 'Success! Your offer was received',
            message: 'Someone will contact you soon.',
            type: 'success'

        },
        'inquiry': {
            title: 'Success! Your message was received',
            message: 'Someone will contact you soon.',
            type: 'success'

        },
        'isNewPerson': {
            title: 'Welcome firstName, We created a user account for you!',
            message: 'Consider verifying your email by clicking the link in the email we sent you. After that, you can set a password on your profile to enjoy all the benefits of a membership.',
            type: 'info'

        },
        'existingPerson': {
            title: 'Welcome Back firstName!',
            message: 'We noticed you have made an offer/inquiry before. Consider verifying your email and setting a password so that you can enjoy all the benefits of a membership.',
            type: 'info'

        },
        // 'loginviaForm': {
        //     title: 'Welcome Back firstName!',
        //     message: 'We have logged you in to simplify making additional inquiries and offers. You can view or change your membership by visiting <a href="/myprofile">My Profile</a>.',
        //     type: 'info'

        // },
        'updatecontactinfo': {
            title: 'Success!',
            message: 'Contact information was updated',
            type: 'success'

        },
        'updateaddress': {
            title: 'Success!',
            message: 'Address was updated',
            type: 'success'

        },
        'changepassword': {
            title: 'Success!',
            message: 'Password sucessfully changed',
            type: 'success'

        },
        'updateCommPref': {
            title: 'Success!',
            message: 'Communication settings were sucessfully updated',
            type: 'success'

        },
        'contact': {
            title: 'We Got Your Message!',
            message: 'We will be in touch very soon',
            type: 'success'

        }
    }

}

// util to return requested setting
export const getConfigSetting = (setting, key) => {
    const section = config[setting];
    if (section.hasOwnProperty(key))
        return section[key];
    else
        return null;


};
