export const mockContextData = {
  context: "foo",
  setContext: jest.fn(),
};

export const ReactContext = {
  Provider: jest.fn(({ value, children }) => children),
  Consumer: jest.fn(({ children }) => {
    return children(mockContextData);
  }),
};
