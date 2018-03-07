import React from 'react';
import Scanner from './scanner.jsx';
import TopicSelection from './topicSelection.jsx';

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
