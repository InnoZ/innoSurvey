import React from 'react';

export default function QuestionBox({selections, modifyChoice, id, style, text, active, choices}) {
  const handleClick = function(choiceId) {
    modifyChoice({statementId: id, choiceId: choiceId, singleChoice: (style == 'single_choice')});
  }

  const choicesList = choices.map((choice) =>
    <div className={selections.includes(choice.id) ? 'button choice active' : 'button choice'}
         key={choice.id}
         onClick={() => handleClick(choice.id)}>
      {choice.text}
    </div>
  );

  return(
    <div className='question active'>
      {text}
      {choicesList}
    </div>
  )
}
