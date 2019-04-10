import React, { Component } from 'react';
import Greeting from './Greeting';

class DemoComponent extends Component {
  render() {
    return(
      <div className="react-demo-component">
        <Greeting message={'Hello from react!'} />
      </div>
    );
  }
}

export default DemoComponent;