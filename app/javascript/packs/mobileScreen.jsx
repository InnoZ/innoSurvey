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
      token: null,
    }
  }

  componentWillMount() {
    if (getUrlParam(window.location.href, 'uuid') && getUrlParam(window.location.href, 'role_id') && getUrlParam(window.location.href, 'token')) {
      const newState = {
        scan: false,
        uuid: getUrlParam(window.location.href, 'uuid'),
        roleId: getUrlParam(window.location.href, 'role_id'),
        token: getUrlParam(window.location.href, 'token'),
      };
      console.log('uuid: ' + newState.uuid)
      console.log('role id: ' + newState.roleId)
      console.log('token: ' + newState.token)
      this.setState(newState);
    }
  }

  ident(uuid, roleId, token) {
    const newState = {
      scan: false,
      uuid: uuid,
      roleId: roleId,
      token: token,
    };
    this.setState(newState)
  };

  render() {
    let main;
    if (this.state.scan) {
      main = <Scanner ident={this.ident.bind(this)} />
    } else {
      main = <TopicSelection roleId={this.state.roleId} uuid={this.state.uuid} token={this.state.token} />
    };

    return (
      <div>{main}</div>
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
