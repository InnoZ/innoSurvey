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
    }),
    secondsLeft: 9
  }

  constructor(props){
    super(props);
    this.state = this.initialState;
    this.statementIds = this.props.statements.map((s) => s.id);
  }

  // vvvvvvvvvvvvv RESET TIMER vvvvvvvvvvvv //
  componentDidMount() { this.setTimer(); }
  componentWillUnmount() { clearInterval(this._interval); }

  componentDidUpdate() {
    if (this.state.secondsLeft == 0) {
      this.props.reset();
    };
  }

  setTimer() {
    this.setState({ secondsLeft: this.initialState['secondsLeft'] })
    this._interval != null ? clearInterval(this._interval) : null;
    // jump back after 10000 milliseconds
    const that = this;
    this._interval = setInterval(function(){
      that.setState({ secondsLeft: that.state.secondsLeft - 1 })
    }, 1000);
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
    // mark as finished in mobile view's topic selection component
    // not available in exhibition view
    if (this.props.finishTopic !== undefined) {
      this.props.finishTopic(this.props.topicId);
    }
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
    this.setTimer();
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

  browseStatement(operator) {
    const indexOfSelected = this.statementIds.indexOf(this.state.activeStatementBox);
    const nextId = this.statementIds[indexOfSelected + operator];
    if (nextId) {
      this.setState({ activeStatementBox: nextId })
    }
  }

  render() {
    const statement = this.props.statements.find((statement) => statement.id == this.state.activeStatementBox)
    const question = <QuestionBox id={statement.id}
                                   text={statement.text}
                                   choices={statement.choices}
                                   selections={this.selectionsFor(statement.id)}
                                   select={this.modifyChoices.bind(this)}
                                   unselect={this.modifyChoices.bind(this)}
                                   answered={this.answered(statement.id)}
                                   resetTimer={this.setTimer.bind(this)}/>

    const previousButton =
      (this.state.activeStatementBox !== this.statementIds[0]) ?
        <button className='button previous-button' onClick={() => this.browseStatement(-1) }>zurück</button> : null

    const nextButton =
      (this.state.activeStatementBox !== this.statementIds[this.statementIds.length - 1]
        && this.answered(this.state.activeStatementBox)) ?
        <button className='button next-button' onClick={() => this.browseStatement(+1) }>weiter</button> : null

    const submitButton = this.everyStatementAnswered() ?
      <button className='button submit-button' onClick={() => this.submitSelections()}>Absenden</button> : null

    const countdown = <div className='countdown'>{this.state.secondsLeft}</div>

    return(
      <div className='topic'>
        {question}
        {previousButton}
        {nextButton}
        {submitButton}
        {countdown}
      </div>
    )
  }
}
