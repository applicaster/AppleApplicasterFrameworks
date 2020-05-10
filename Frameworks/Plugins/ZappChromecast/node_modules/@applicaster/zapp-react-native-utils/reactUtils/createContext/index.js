import * as React from "react";
import createReactContext from "create-react-context";
import * as R from "ramda";

import { getSetterName, NOOP } from "./helpers";
import { createProvider } from "./provider";
import { createWithConsumerDecorator } from "./withConsumer";
import { createWithProviderDecorator } from "./withProvider";

const reactContextCreator = React.createContext;

// Depending on the version of React used, the `createContext` function may not be available
// if this is the case, we fall back to a polyfill library
const contextCreatorFn =
  reactContextCreator && typeof reactContextCreator === "function"
    ? reactContextCreator
    : createReactContext;

/**
 * @typedef Context
 * @property {Object} Context.Provider react class component to use as context provider
 * @property {Function} Context.Consumer react functional component to use as context consumer
 * @property {Function} Context.withProvider HOC to apply the context provider
 * @property {function} Context.withConsumer HOC to apply the context consumer. passes the context as props
 * to the wrapped component
 */

/**
 * Creates a React Context and returns consumer & providers components & decorators to interact
 * with this context.
 * @param {Object} initialContext map of context properties and their initial values
 * @param {Function} stateValidator optional predicate to tell whether the state update is valid or not
 * @returns {Context} Object containing the context components & decorators {@link Context}
 */
export function createContext(initialContext, stateValidator = R.T) {
  // first we extract the properties name, and create setters name for those
  const contextPropertiesNames = R.keys(initialContext);
  const contextSettersNames = R.map(getSetterName, contextPropertiesNames);

  // we create a React Context with the properties & their setters, assigning a noop function
  // temporarily (will be overriden by proper setters in the provider component)
  const ReactContext = R.compose(
    contextCreatorFn,
    R.merge(initialContext),
    R.zipObj(contextSettersNames),
    R.map(R.always(NOOP))
  )(contextSettersNames);

  // we call the module function to fabricate the Provider & Consumer components
  const Provider = createProvider({
    ReactContext,
    initialContext,
    contextPropertiesNames,
    contextSettersNames,
    stateValidator,
  });

  const { Consumer } = ReactContext;

  // and their matching decorators
  const withProvider = createWithProviderDecorator(Provider);
  const withConsumer = createWithConsumerDecorator(Consumer);

  return {
    Provider,
    Consumer,
    withProvider,
    withConsumer,
  };
}
