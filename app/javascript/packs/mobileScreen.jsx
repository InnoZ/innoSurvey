// polyfills to provide es6 functions to tests
import 'whatwg-fetch';
import 'babel-polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import Scanner from './components/scanner.jsx';
import TopicSelection from './components/topicSelection.jsx';

class MobileScreen extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      scan: true,
      roleId: null,
      uuid: null,
    }
  }

  ident(identString) {
    if (identString.includes('uuid') && identString.includes('role_id')) {
      let identJson = JSON.parse(identString);
      const newState = {
        scan: false,
        roleId: identJson['role_id'],
        uuid: identJson['uuid'],
      };
      console.log(newState);
      this.setState(newState)
    };
  };

  render() {
    let main;
    if (this.state.scan) {
      main = <Scanner ident={this.ident.bind(this)} />
    } else {
      main = <TopicSelection roleId={this.state.roleId} uuid={this.state.uuid} />
    };

    return (
      {main}
    );
  }
}

ReactDOM.render(
  <div className='container all-centered'>
    <div className='row'>
      <div className='col-xs-12'>
        <MobileScreen />
        <div id='flash-message'></div>
      </div>
    </div>
  </div>,
  document.body.appendChild(document.createElement('div')),
)
