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
      this.setState({
        scan: false,
        roleId: identJson['role_id'],
        uuid: identJson['uuid'],
      })
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
      <div>{main}</div>
    );
  }
}

ReactDOM.render(
  <div className='all-centered'>
    <MobileScreen />
    <div id='flash-message'></div>
  </div>,
  document.body.appendChild(document.createElement('div')),
)
