// polyfills to provide es6 functions to tests
import 'whatwg-fetch';
import 'babel-polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import ExhibitionScreen from './components/exhibitionScreen.jsx';

ReactDOM.render(
  <div>
    <div>exhibition Screen</div>
    <ExhibitionScreen />
    <div id='flash-message'></div>
  </div>,
  document.body.appendChild(document.createElement('div')),
)
