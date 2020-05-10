import * as React from "react";

/**
 * Creates a Provider decorator with the given Provider component
 * @param {Object} Provider react component to use as context provider
 * @returns {Function} Wrapped react functional component with the given context Provider
 */
export function createWithProviderDecorator(Provider) {
  return function withProvider(Component) {
    return function WithContextProviderComponent(props) {
      return (
        <Provider>
          <Component {...props} />
        </Provider>
      );
    };
  };
}
