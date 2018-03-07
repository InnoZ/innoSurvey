import React from 'react';
import StatementSet from './statementSet.jsx';

export default class topicSelection extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      activeTopic: null,
      finishedTopics: [],
    }
  }

  topic() {
    return window.topics.find((topic) => topic.id == this.state.activeTopic)
  }

  statementSet() {
    return this.topic().statement_sets.find((set) => set.role_id == this.props.roleId)
  }

  reset() {
    this.setState({ activeTopic: null })
  }

  finishTopic(id) {
    this.setState((prevState, props) => ({
      finishedTopics: prevState.finishedTopics.concat([id])
    }));
  }

  topicClassNames(topic) {
    if (this.state.finishedTopics.includes(topic.id)) {
      return 'button choice topic-selection disabled';
    } else {
      return 'button choice topic-selection';
    }
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
                        reset={() => this.reset()}
                        finishTopic={this.finishTopic.bind(this)} />
        : <div>
            <h3>Hier gibt es keine Fragen für deine Rolle!</h3>
            <button className='button previous-button' onClick={this.reset.bind(this)}>zurück</button>
          </div>
    } else {
      main = window.topics.map((topic) => {
        let classNames, clickHandler;
        if (this.state.finishedTopics.includes(topic.id)) {
          classNames = 'button choice topic-selection disabled';
          clickHandler = null;
        } else {
          classNames = 'button choice topic-selection';
          clickHandler = () => this.setState({ activeTopic: topic.id });
        }
        return <h3 key={topic.id} className={classNames} onClick={clickHandler}>
          {topic.name}
        </h3>
      })
    }

    return (
      <div>{main}</div>
    );
  }
}
