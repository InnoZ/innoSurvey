import React from 'react';
import QuestionBox from './questionBox.jsx';

export default class StatementSet extends React.Component {
  initialState = {
    activeStatementBox: null,
    visitedStatementBoxes: [],
    selections: this.props.statements.map(function(statement) {
      return {
        statement_id: statement.id,
        selected_choices: [],
      }
    })
  }

  constructor(props){
    super(props);
    this.state = this.initialState;
  }

  // vvvvvvvvvvvvv RESET TIMER vvvvvvvvvvvv //
  componentDidMount() { this.setTimer(); }
  componentWillUpdate() { this.setTimer(); }
  // clear any existing timer
  componentWillUnmount() { clearTimeout(this._timer); }

  setTimer() {
    // clear any existing timer
    this._timer != null ? clearTimeout(this._timer) : null;

    // hide after 10000 milliseconds
    this._timer = setTimeout(function(){
      this.props.resetStatementSet();
    }.bind(this), 10000);
  }
  // ^^^^^^^^^^^^^ RESET TIMER ^^^^^^^^^^^^^ //

  previewSelections(json) {
    const jsonDiv = document.getElementById('json-preview');
    jsonDiv.innerHTML = JSON.stringify(json, null, 4);
    const flashMessage = document.getElementById('flash-message');
    flashMessage.innerHTML = 'saved';
    setTimeout(function() {
      flashMessage.innerHTML = '';
      jsonDiv.innerHTML = '';
    }, 10000);
  }

  submitSelections() {
    const data = { answers: this.state.selections };
    this.sendSelections(data);
    this.previewSelections(data);
    this.props.resetStatementSet();
  }

  sendSelections(data) {
    const csrfToken = document.querySelector("[name='csrf-token']").content
    fetch('/answers', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken,
      },
      body: JSON.stringify(data),
      credentials: 'same-origin',
    });
  }

  modifyChoices({statementId, choiceId, check}) {
    const thisComponent = this;
    const updatedChoices = this.state.selections.slice().map(function(statement) {
      const selections = statement.statement_id == statementId ?
        (check ? statement.selected_choices.concat(choiceId) : statement.selected_choices.filter((c) => c != choiceId))
        : statement.selected_choices;
      return {
        statement_id: statement.statement_id,
        selected_choices: selections,
      };
    });
    this.setState({selections: updatedChoices})
  }

  activateStatementBox(id) {
    const visitedStatementBoxes = this.state.visitedStatementBoxes.slice();
    this.setState({
      activeStatementBox: id,
      visitedStatementBoxes: visitedStatementBoxes.concat(id),
    })
  }

  selectionsFor(statementId) {
    return this.state.selections.find((q) => q.statement_id == statementId).selected_choices
  }

  render() {
    const statements = this.props.statements.map((statement) =>
      <div key={statement.id} onClick={() => this.activateStatementBox(statement.id)}>
        <QuestionBox id={statement.id}
                     text={statement.text}
                     choices={statement.choices}
                     selections={this.selectionsFor(statement.id)}
                     select={this.modifyChoices.bind(this)}
                     unselect={this.modifyChoices.bind(this)}
                     active={statement.id == this.state.activeStatementBox}
                     visited={this.state.visitedStatementBoxes.includes(statement.id)}
                     resetTimer={this.setTimer.bind(this)}/>
      </div>
    );

    return(
      <div className='topic'>
        {statements}
        <button className='button submit-button'
                onClick={() => this.submitSelections()}>
          Send
        </button>
      </div>
    )
  }
}
