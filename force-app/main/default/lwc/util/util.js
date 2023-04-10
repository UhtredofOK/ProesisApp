import { NavigationMixin } from 'lightning/navigation';

// At least 1 lowercase, 1 uppercase, 1 number and 1 special character.
const passwordRegex = new RegExp("^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])");

/**
 * Checks if a given value is null or undefined.
 * @param {any} value The given value to check against null or undefined.
 * @returns {boolean} Whether or not the given value is null or undefined.
 */
export function isNullOrUndef(value) {
    return (value === null || value === undefined);
}

/**
 * Checks if a given value is null, undefined, an empty string, NaN, or an empty object.
 * @param {any} value The given value to check against null, undefined, an empty string, NaN, or an empty object.
 * @returns {boolean} Whether not the given value is null, undefined, an empty string, NaN, or an empty object.
 */
export function isBlank(value) {
    return (
        isNullOrUndef(value) ||
        (typeof value === 'string' && value.trim().length <= 0) ||
        (typeof value === 'number' && isNaN(value)) ||
        (typeof value === 'object' && Object.keys(value).length <= 0)
    );
}

export function isNotBlank(value) {
    return !isBlank(value);
}

export function validateZipCode(event) {
    const pasteShortcut =
        (event.ctrlKey || event.metaKey) && // Windows or Mac
        (event.which === 86 || event.keyCode === 86);

    // If it was not a paste.
    if (event?.key?.length === 1 && !pasteShortcut) {
        const validDigit = /\d/.test(event.key);

        if (!validDigit) {
            // This will allow users to highlight the current value and replace it
            // assuming that what is highlighted is what is currently in the field.
            let currentSelection = window.getSelection()?.toString();

            if (currentSelection) {
                if (!event.target.value.includes(currentSelection)) {
                    event.preventDefault();
                }
            } else {
                event.preventDefault();
            }
        }
    }
}

export function navigateToPage(component, name) {
    component[NavigationMixin.Navigate]({
        type: 'comm__namedPage',
        attributes: {
            name: name
        }
    });
}

export function showToast(component, variant = 'info', title = '', message = '', mode = 'dismissable') {
    console.log('toast', message);

    const event = new ShowToastEvent({
        title,
        message: this.getFilteredErrorMessage(message),
        variant,
        mode
    });

    component.dispatchEvent(event);
}

export function showGuestToast(component, variant = 'info', title = '', message = '', mode = 'dismissable') {
    console.log('toast', message);

    component?.template?.querySelector('c-guest-toast')?.show(variant, title, this.getFilteredErrorMessage(message), mode);
}

export function getFilteredErrorMessage(msg = '') {
    if (msg.hasOwnProperty && msg.hasOwnProperty('message')) {
        return msg.message;
    }

    if (msg.hasOwnProperty && msg.hasOwnProperty('body') && msg.body.hasOwnProperty('message')) {
        return msg.body.message;
    }

    if (msg.detail && msg.detail.detail) {
        return `${msg.detail.message} ${msg.detail.detail}`;
    }

    return msg;
}

export function logout(component) {
    component[NavigationMixin.Navigate]({
        type: 'comm__loginPage',
        attributes: {
            actionName: 'logout'
        }
    });
}

export function isValidPassword(password) {
    return passwordRegex.test(password);
}