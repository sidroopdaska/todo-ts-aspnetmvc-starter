import * as React from 'react';

interface IAppProps { }

export default class App extends React.Component<IAppProps, {}> {
    constructor(props: IAppProps) {
        super(props);
    }

    public render() {
        return (
            <div>
                Hello, world!
            </div>
        );
    }
}