import * as React from "react";

/**
 * Creates a Consumer Decorator with the provided ContextConsumer component
 * @param {Object} ContextConsumer Consumer component to use
 * @returns {Function} decorated functional component where the context data is merged with
 * the unwrapped component's own props
 */
export function createWithConsumerDecorator(ContextConsumer) {
  return function withConsumer(Component) {
    return function WithContextConsumerComponent(props) {
      return (
        <ContextConsumer>
          {context => <Component {...props} {...context} />}
        </ContextConsumer>
      );
    };
  };
}
