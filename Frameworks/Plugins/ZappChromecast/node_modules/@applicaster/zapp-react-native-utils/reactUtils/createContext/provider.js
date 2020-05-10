// @flow
import * as React from "react";
import * as R from "ramda";
import { createContextSetters } from "./helpers";

type Props = {
  children: React.ComponentType,
};

/**
 * Creates a Provider component for the provided React Context
 * @param {Object} Options
 * @param {Object} Options.ReactContext react context to use
 * @param {Object} Options.initialContext initial context
 * @param {Array<String>} Options.contextPropertiesNames list of properties in the context
 * @param {Array<String>} Options.contextSettersNames list of setters in the context
 * @param {?Function} stateValidator optional stateValidator Predicate to check whether the context
 * update is valid or not. Invoked with { property, value }
 * @returns {Function} Consumer functional component
 */
export function createProvider({
  ReactContext,
  initialContext,
  contextPropertiesNames,
  contextSettersNames,
  stateValidator,
}) {
  class Provider extends React.Component<Props> {
    constructor(props) {
      super(props);

      createContextSetters(contextPropertiesNames, this, { stateValidator });

      this.state = R.compose(
        R.merge(initialContext),
        R.zipObj(contextSettersNames),
        R.map(R.prop(R.__, this))
      )(contextSettersNames);
    }

    render() {
      const { children } = this.props;

      return (
        <ReactContext.Provider value={this.state}>
          {children}
        </ReactContext.Provider>
      );
    }
  }

  return Provider;
}
