import React from 'react';
import StatementSet from './statementSet.jsx';

export default class topicSelection extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      activeStation: null,
      activeTopic: null,
      answeredTopics: [],
    }
  }

  componentWillMount() {
    this.setState({
      answeredTopics: [1]
    })
  }

  topic() {
    const station = window.stations.find((station) => station.id == this.state.activeStation)
    return station.topics.find((topic) => topic.id == this.state.activeTopic)
  }

  statementSet() {
    return this.topic().statement_sets.find((set) => set.role_id == this.props.roleId)
  }

  reset() {
    this.setState({
      activeTopic: null,
      answeredTopics: [1, 2]
    })
  }

  topicButtons(station) {
    return station.topics.map((topic) => {
      let classNames, clickHandler;
      if (this.state.answeredTopics.includes(topic.id)) {
        classNames = 'choice topic-selection disabled';
        clickHandler = null;
      } else {
        classNames = 'choice topic-selection';
        clickHandler = () => this.setState({ activeStation: station.id, activeTopic: topic.id });
      }
      return <h3 key={topic.id} className={classNames} onClick={clickHandler}>
        {topic.name}
      </h3>
    })
  }

  render() {
    let main;
    if (this.state.activeTopic) {
      const statementSet = this.statementSet();
      main = statementSet
        ? <StatementSet topicId={this.state.activeTopic}
                        roleId={this.props.roleId}
                        uuid={this.props.uuid}
                        roleName={statementSet.role_name}
                        statements={statementSet.statements}
                        reset={() => this.reset()} />
        : <div>
            <h3>Hier gibt es keine Fragen für deine Rolle!</h3>
            <button className='button previous-button' onClick={this.reset.bind(this)}>zurück</button>
          </div>
    } else {
      main = window.stations.map((station) => {
        return <div className='station' key={station.id}>
          <h2>{station.name}</h2>
          {this.topicButtons(station)}
        </div>
      })
    }

    return (
      <div>{main}</div>
    );
  }
}
