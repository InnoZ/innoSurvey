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
      let classNames, clickHandler, topicText;
      if (this.state.answeredTopics.includes(topic.id)) {
        classNames = 'btn btn-default topic-btn topic-selection disabled';
        clickHandler = null;
        topicText = topic.name + ' ✓';
      } else {
        classNames = 'btn btn-default topic-btn topic-selection';
        clickHandler = () => this.setState({ activeStation: station.id, activeTopic: topic.id });
        topicText = topic.name;
      }
      return <div key={topic.id} className="text-center"><h3 className={classNames} onClick={clickHandler}>
        {topicText}
        </h3>
      </div>
    })
  }

  render() {
    let main, intro;
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
      intro = <h1>Wählen Sie eine der folgenden Stationen aus:</h1>;
      main = window.stations.map((station) => {
        return <div className='station' key={station.id}>
          <h3> Station: {station.name}</h3>
          {this.topicButtons(station)}
        </div>
      })
    }

    return (
      <div>
        {intro}
        {main}
      </div>
    );
  }
}
