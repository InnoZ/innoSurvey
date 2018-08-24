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
    this.getAnsweredTopics()
  }

  componentDidUpdate() {
    this.getAnsweredTopics()
  }

  getAnsweredTopics() {
    const that = this;
    fetch('/topics/finished/' + this.props.uuid)
      .then(
        function(response) {
          if (response.status !== 200) {
            console.log('Looks like there was a problem. Status Code: ' + response.status);
            return;
          }
          response.json().then(function(data) {
            if (JSON.stringify(data) !== JSON.stringify(that.state.answeredTopics)) {
              that.setState({ answeredTopics: data })
            }
          });
        }
      )
      .catch(function(err) {
        console.log('Fetch Error :-S', err);
      });
  }

  topic() {
    const station = window.stations.find((station) => station.id == this.state.activeStation)
    return station.topics.find((topic) => topic.id == this.state.activeTopic)
  }

  statementSet() {
    return this.topic().statement_sets.find((set) => set.role_id == this.props.roleId)
  }

  reset() {
    this.setState({ activeTopic: null })
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
                        token={this.props.token}
                        roleName={statementSet.role_name}
                        statements={statementSet.statements}
                        reset={() => this.reset()} />
        : <div className='question' onClick={this.reset.bind(this)}>
            Hier gibt es leider keine Fragen für deine Rolle.
            <div className='subtitle'>Klicke hier um zurück zu gelangen.</div>
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
