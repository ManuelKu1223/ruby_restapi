import React  from 'react';
import ReactDOM from 'react-dom'
import DemoComponent from './components/Demo';

const container = document.querySelector('.react-container');

document.addEventListener('DOMContentLoaded', () => {
  ReactDOM.render(
    <DemoComponent />,
    container
  );
});