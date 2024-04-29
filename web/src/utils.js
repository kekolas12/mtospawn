const isEnvBrowser = () => !window.invokeNative;

const createNuiEventListener = (func) => {
    window.addEventListener('message', event => func(event));
};

const sendPost = (name, data) => {
    fetch(`https://${GetParentResourceName()}/${name}`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
    })
};

export {
    isEnvBrowser,
    sendPost,
    createNuiEventListener
};