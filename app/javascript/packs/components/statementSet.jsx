import React from 'react';
import QuestionBox from './questionBox.jsx';

export default class StatementSet extends React.Component {
  initialState = {
    activeStatementBox: this.props.statements[0].id,
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
  componentWillUnmount() { clearTimeout(this._timer); }
  setTimer() {
    this._timer != null ? clearTimeout(this._timer) : null;
    // hide after 10000 milliseconds
    this._timer = setTimeout(function(){
      this.props.reset();
    }.bind(this), 10000);
  }
  // ^^^^^^^^^^^^^ RESET TIMER ^^^^^^^^^^^^^ //

  successMessage() {
    const flashMessage = document.getElementById('flash-message');
    flashMessage.innerHTML = 'Vielen Dank! Deine Antworten wurden gespeichert...';
    setTimeout(function() {
      flashMessage.innerHTML = '';
    }, 5000);
  }

  submitSelections() {
    this.sendSelections();
    this.props.reset();
  }

  sendSelections() {
    const data = { answers: this.state.selections, uuid: this.props.uuid };
    // const csrfToken = document.querySelector("[name='csrf-token']").content;
    fetch('/answers', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        // 'X-CSRF-Token': csrfToken,
      },
      body: JSON.stringify(data),
      credentials: 'same-origin',
    }).catch(error => console.error('An error occured: ', error))
      .then((responseObj) =>
        responseObj.status == 201 ? this.successMessage()
                                  : console.error('An error occured on server!') )
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

  selectionsFor(statementId) {
    return this.state.selections.find((q) => q.statement_id == statementId).selected_choices;
  }

  everyStatementAnswered() {
    return this.state.selections.every(s => s.selected_choices.length > 0);
  }

  answered(statementId) {
    return this.selectionsFor(statementId).length > 0;
  }

  render() {
    const statements = this.props.statements.map((statement) =>
      <div key={statement.id} onClick={() => this.setState({ activeStatementBox: statement.id })}>
        <QuestionBox id={statement.id}
                     text={statement.text}
                     choices={statement.choices}
                     selections={this.selectionsFor(statement.id)}
                     select={this.modifyChoices.bind(this)}
                     unselect={this.modifyChoices.bind(this)}
                     active={statement.id == this.state.activeStatementBox}
                     answered={this.answered(statement.id)}
                     resetTimer={this.setTimer.bind(this)}/>
      </div>
    );
    const submitButton = this.everyStatementAnswered() ?
        <button className='button submit-button'
                onClick={() => this.submitSelections()}>
          Senden
        </button>
      : null

    return(
      <div className='topic'>
        {statements}
        {submitButton}
      </div>
    )
  }
}
