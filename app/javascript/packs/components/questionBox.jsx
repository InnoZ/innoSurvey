import React from 'react';

export default function QuestionBox({selections, select, unselect, id, text, visited, active, choices, resetTimer}) {

  const handleClick = function(questionId, choiceId) {
    if (!selections.includes(choiceId)) {
      select({statementId: questionId, choiceId: choiceId, check: true})
    } else {
      unselect({statementId: questionId, choiceId: choiceId, check: false})
    };
    // start timer reset after each click
    resetTimer();
  }

  const choicesList = choices.map((choice) =>
    <div className={selections.includes(choice.id) ? 'button choice active' : 'button choice'}
         key={choice.id}
         onClick={() => handleClick(id, choice.id)}>
      {choice.text}
    </div>
  );

  if (active) {
    return(
      <div className='question'>
        {text}
        {choicesList}
      </div>
    )
  } else {
    return (
      <div className='question inactive'>
        {text}
        {visited ? ' ✓' : null}
      </div>
    )
  }
}
