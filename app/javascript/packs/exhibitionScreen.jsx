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
      scan: false,
      roleId: null,
      uuid: null,
      answeredTopics: [],
    }
  }

  getAnsweredTopics() {
    this.setState({
      answeredTopics: []
    })
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
      this.setState(newState, this.getAnsweredTopics)
    };
  };

  reset() {
    this.setState({
      scan: false,
      roleId: null,
      uuid: null,
    })
  }

  statementSetFromRole(roleId) {
    return window.topicData.statement_sets.find((set) =>
      set.role_id == this.state.roleId
    );
  }

  render() {
    let main;
    if (this.state.scan == true) {
      main = <Scanner ident={this.ident.bind(this)} reset={this.reset.bind(this)} />
    } else {
      const set = this.statementSetFromRole(this.state.roleId);
      if (set) {
        if (this.state.answeredTopics.includes(window.topicData.id)) {
          main = <div>
            <h3>Hier warst du schon!</h3>
            <button className='btn btn-lg' onClick={() => this.reset()}>zurück</button>
          </div>
        } else {
          main = <StatementSet
            roleId={set.role_id}
            uuid={this.state.uuid}
            roleName={set.role_name}
            statements={set.statements}
            reset={() => this.reset()}
          />
        }
      } else {
        main =  <div className='question' onClick={() => this.setState({ scan: true })}>
          Klicke hier, um die Umfrage zu starten
          <div className='subtitle'>Du brauchst einen QR-Code um teilzunehmen</div>
        </div>
      }
    }

    return (
      <div className='row'>
        <div className='col-xs-12'>
          {main}
        </div>
      </div>
    );
  }
}

ReactDOM.render(
  <div className='container all-centered'>
    <div className='row'>
      <div className='col-xs-12'>
        <ExhibitionScreen />
        <div id='flash-message'></div>
      </div>
    </div>
  </div>,
  document.body.appendChild(document.createElement('div')),
)
