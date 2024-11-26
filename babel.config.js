module.exports = function (api) {
  const isDevelopmentEnv = api.env('development');
  const isProductionEnv = api.env('production');
  const isTestEnv = api.env('test');

  return {
    presets: [
      // For Tests (Node.js environment)
      isTestEnv && [
        '@babel/preset-env',
        {
          targets: {
            node: 'current',
          },
        },
      ],
      // For Development & Production (Browser environment)
      (isProductionEnv || isDevelopmentEnv) && [
        '@babel/preset-env',
        {
          forceAllTransforms: true,
          useBuiltIns: 'entry', // Polyfills based on usage
          corejs: 3, // Polyfill using core-js version 3
          modules: false, // Avoid transforming ES6 module syntax (Webpack handles it)
        },
      ],
    ].filter(Boolean),
    plugins: [
      'babel-plugin-macros',
      '@babel/plugin-syntax-dynamic-import',
      // For modern JavaScript features
      '@babel/plugin-proposal-class-properties',
      '@babel/plugin-proposal-object-rest-spread',
      '@babel/plugin-proposal-private-methods',
      '@babel/plugin-proposal-private-property-in-object',
      // Optimizing helpers and polyfills
      '@babel/plugin-transform-runtime',
      '@babel/plugin-transform-regenerator',
    ].filter(Boolean),
  };
};
