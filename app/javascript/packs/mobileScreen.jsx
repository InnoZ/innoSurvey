// polyfills to provide es6 functions to tests
import 'whatwg-fetch';
import 'babel-polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import Scanner from './components/scanner.jsx';
import TopicSelection from './components/topicSelection.jsx';
import StatementSet from './components/statementSet.jsx';

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
    //Check if neccesary parameters are given to prevent qr code reading
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

      //Check if a station is allready given otherwise station overview is presented
      if (getUrlParam(window.location.href, 'topic_id') && getUrlParam(window.location.href, 'station_id')) { 
        this.setState({
          activeStation: getUrlParam(window.location.href, 'station_id'),
          activeTopic: getUrlParam(window.location.href, 'topic_id')
        });
      }

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

  topic() {
    const station = window.stations.find((station) => station.id == this.state.activeStation)
    return station.topics.find((topic) => topic.id == this.state.activeTopic)
  }

  statementSet() {
    return this.topic().statement_sets.find((set) => set.role_id == this.state.roleId)
  }
  reset(){
   console.log("schmu");
  }

  render() {
    let main;
    if (this.state.scan) {
      main = <Scanner ident={this.ident.bind(this)} />
    } else if (this.state.activeTopic) {
      const statementSet = this.statementSet();
      main = statementSet
        ? <StatementSet topicId={this.state.activeTopic}
                        roleId={this.state.roleId}
                        uuid={this.state.uuid}
                        token={this.state.token}
                        roleName={statementSet.role_name}
                        statements={statementSet.statements}
                        reset={() => this.reset()} />
        : <div className='question' onClick={this.reset.bind(this)}>
            Hier gibt es leider keine Fragen für deine Rolle.
            <div className='subtitle'>Klicke hier um zurück zu gelangen.</div>
          </div>
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
