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
    secondsLeft: 99
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
    flashMessage.innerHTML = 'Vielen Dank! Die Antworten wurden gespeichert...';
    setTimeout(function() {
      flashMessage.innerHTML = '';
    }, 5000);
  }

  sendSelections() {
    const that = this;
    const data = { answers: this.state.selections, uuid: this.props.uuid, token: this.props.token };
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
        responseObj.status == 201 ? this.successMessage() : console.error('An error occured on server!') )
        setTimeout(function() { that.props.reset() }, 500);
  }

  modifyChoices({statementId, choiceId, singleChoice}) {
    this.setTimer();
    const updatedChoices = this.state.selections.slice().map(function(statement) {
      let selections;
      if (statement.statement_id !== statementId) {
        selections = statement.selected_choices
      } else {
        if (singleChoice) {
          selections = [choiceId]
        } else {
          selections = (statement.selected_choices.includes(choiceId))
            ? statement.selected_choices.filter((c) => c !== choiceId)
            : statement.selected_choices.concat(choiceId)
        }
      };
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

  pageIndicator() {
    const n = this.statementIds.length
    const current = this.statementIds.indexOf(this.state.activeStatementBox) + 1
    return `${current} von ${n}`
  }

  render() {
    const statement = this.props.statements.find((statement) => statement.id == this.state.activeStatementBox)
    const question = <QuestionBox id={statement.id}
                                   text={statement.text}
                                   style={statement.style}
                                   choices={statement.choices}
                                   selections={this.selectionsFor(statement.id)}
                                   modifyChoice={this.modifyChoices.bind(this)}
                                   answered={this.answered(statement.id)} />

    const nextButton =
      (this.state.activeStatementBox !== this.statementIds[this.statementIds.length - 1]) ?
        <div className='next-button' onClick={() => this.browseStatement(+1)}>{'>'}</div> : null

    const previousButton =
      (this.state.activeStatementBox !== this.statementIds[0]) ?
        <div className='previous-button' onClick={() => this.browseStatement(-1)}>{'<'}</div> : null

    const submitButton = (this.state.activeStatementBox == this.statementIds[this.statementIds.length - 1]) ?
      <button className='btn btn-lg' onClick={() => this.sendSelections()}>Absenden</button> :
      <div className='page-indicator'>{this.pageIndicator()}</div>

    const countdown = <div className='countdown'>{this.state.secondsLeft} sec</div>

    return(
      <div className='topic'>
        {question}
        <div className='button-row row'>
          <div className='col-xs-offset-2 col-xs-2'>{previousButton}</div>
          <div className='col-xs-4'>{submitButton}</div>
          <div className='col-xs-2'>{nextButton}</div>
        </div>
        {countdown}
      </div>
    )
  }
}
