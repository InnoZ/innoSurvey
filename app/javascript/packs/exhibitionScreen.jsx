// polyfills to provide es6 functions to tests
import 'whatwg-fetch';
import 'babel-polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import Scanner from './components/scanner.jsx';
import StatementSet from './components/statementSet.jsx';

class ExhibitionScreen extends React.Component {
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

  reset() {
    this.setState({
      scan: true,
      roleId: null,
      uuid: null,
    })
  }

  statementSetFromRole(roleId) {
    return window.data.statement_sets.find((set) =>
      set.role_id == this.state.roleId
    );
  }

  render() {
    let main;
    if (this.state.scan == true) {
      main = <Scanner ident={this.ident.bind(this)} />
    } else {
      const set = this.statementSetFromRole(this.state.roleId);
      if (set) {
        main = <StatementSet
          roleId={set.role_id}
          uuid={this.state.uuid}
          roleName={set.role_name}
          statements={set.statements}
          reset={() => this.reset()}
        />
      } else {
        main = <div>
          <h3>Mit deinem QR-Code kann ich nichts anfangen :(</h3>
          <div onClick={() => this.reset()}>Klicke hier um zum Scanner zurück zu gelangen</div>
        </div>
      }
    }

    return (
      <div>{main}</div>
    );
  }
}

ReactDOM.render(
  <div className='all-centered'>
    <ExhibitionScreen />
    <div id='flash-message'></div>
  </div>,
  document.body.appendChild(document.createElement('div')),
)
