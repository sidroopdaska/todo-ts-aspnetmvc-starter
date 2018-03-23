import * as React from 'react';
import * as ReactDOM from 'react-dom';
import App from './app';

let appContainer = document.getElementById('react-app');

let Component = (props: any) => {
    return (
        <div>Hello</div>
    );
}

ReactDOM.render(<Component />, appContainer);