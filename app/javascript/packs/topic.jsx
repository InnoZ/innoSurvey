// polyfills to provide es6 functions to tests
import 'whatwg-fetch';
import 'babel-polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import Topic from './components/topic.jsx';

ReactDOM.render(
  <div>
    <Topic statementSets={window.data.statement_sets}/>
    <div id='flash-message'></div>
    <div id='json-preview'></div>
  </div>,
  document.body.appendChild(document.createElement('div')),
)
