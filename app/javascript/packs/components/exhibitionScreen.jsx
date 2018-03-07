import React from 'react';
import Scanner from './scanner.jsx';
import StatementSet from './statementSet.jsx';

import jsQR from "jsqr";

export default class ExhibitionScreen extends React.Component {
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
