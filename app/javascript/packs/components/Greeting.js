import React from 'react';
import PropTypes from 'prop-types'

const propTypes = {
  message: PropTypes.string
};

const Greeting = ({ message }) => (
  <h1>{message}</h1>
)

Greeting.propTypes = propTypes;

export default Greeting;