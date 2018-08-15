import React from 'react';

export default function QuestionBox({selections, modifyChoice, id, style, text, active, choices}) {
  const handleClick = function(choiceId) {
    modifyChoice({statementId: id, choiceId: choiceId, singleChoice: (style == 'single_choice')});
  }

  const choicesList = choices.map((choice) =>
    <div className={selections.includes(choice.id) ? 'choice active' : 'choice'}
         key={choice.id}
         onClick={() => handleClick(choice.id)}>
        {choice.text}
    </div>
  );

  const styleNote = style == 'multiple_choice'
    ? <div className='subtitle'> Mehrfachauswahl möglich </div>
    : <div className='subtitle'> Nur eine Antwort möglich </div>

  return(
    <div className='active'>
      <div className='question'>
        {text}
        {styleNote}
      </div>
      {choicesList}
    </div>
  )
}
