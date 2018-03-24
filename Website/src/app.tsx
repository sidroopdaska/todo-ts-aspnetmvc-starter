import * as React from 'react';
import * as ReactDOM from 'react-dom';
import App from './app';

let appContainer = document.getElementById('react-app');

function renderApp(Component: any) {
    // This code starts up the React App when it runs in the browser. It
    // injects the app into a DOM Element.
    ReactDOM.render(<Component />, appContainer);
}

renderApp(App);