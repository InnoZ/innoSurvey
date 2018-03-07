// polyfills to provide es6 functions to tests
import 'whatwg-fetch';
import 'babel-polyfill';

import React from 'react';
import ReactDOM from 'react-dom';
import MobileScreen from './components/mobileScreen.jsx';

ReactDOM.render(
  <div>
    <MobileScreen />
    <div id='flash-message'></div>
  </div>,
  document.body.appendChild(document.createElement('div')),
)
