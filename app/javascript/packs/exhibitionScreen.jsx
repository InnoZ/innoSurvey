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
    this.backlinkUrl = getUrlParam(window.location.href, 'url');
    this.state = {
      scan: this.backlinkUrl !== null,
      roleId: null,
      uuid: null,
      answeredTopics: [],
    }
  }

  getAnsweredTopics() {
    const that = this;
    fetch('/topics/finished/' + this.state.uuid)
      .then(
        function(response) {
          if (response.status !== 200) {
            console.log('Looks like there was a problem. Status Code: ' + response.status);
            return;
          }
          response.json().then(function(data) {
            that.setState({ answeredTopics: data })
          });
        }
      )
      .catch(function(err) {
        console.log('Fetch Error :-S', err);
      });
  }

 ident(uuid, roleId) {
    const newState = {
      scan: false,
      uuid: uuid,
      roleId: roleId,
    };
    this.setState(newState, this.getAnsweredTopics)
  };

  reset() {
    if (this.backlinkUrl) {
      window.location.href = getUrlParam(window.location.href, 'url');
    } else {
      this.setState({
        scan: false,
        roleId: null,
        uuid: null,
      })
    }
  }

  statementSetFromRole(roleId) {
    return window.topicData.statement_sets.find((set) =>
      set.role_id == this.state.roleId
    );
  }

  wrongRoleMessage() {
    const flashMessage = document.getElementById('flash-message');
    flashMessage.innerHTML = 'Dein QR-Code passt nicht zu dieser Umfrage!';
    setTimeout(function() {
      flashMessage.innerHTML = '';
    }, 5000);
  }

  render() {
    let main;
    if (this.state.scan == true) {
      main = <Scanner ident={this.ident.bind(this)} reset={this.reset.bind(this)} />
    } else {
      const set = this.statementSetFromRole(this.state.roleId);
      if (set) {
        if (this.state.answeredTopics.includes(window.topicData.id)) {
          main =  <div className='question' onClick={() => this.setState({ scan: true })}>
            Hier warst du schon!
            <div className='subtitle'>Klicke hier, um zurück zu gelangen</div>
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
        if (this.state.roleId) { this.wrongRoleMessage(); }
        main =  <div className='question' onClick={() => this.setState({ scan: true })}>
          Klicke hier, um die Umfrage zu starten
          <div className='subtitle'>Du brauchst einen QR-Code um teilzunehmen</div>
        </div>
      }
    }

    return (
      <div>{main}</div>
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
