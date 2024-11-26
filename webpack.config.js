const path = require('path');

module.exports = {
  entry: './app/javascript/packs/application.js', // Adjust to your app's entry point
  output: {
    path: path.resolve(__dirname, 'public/packs'), // Adjust to your output directory
    filename: 'bundle.js',
  },
  mode: process.env.NODE_ENV === 'production' ? 'production' : 'development',
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
        },
      },
    ],
  },
  resolve: {
    extensions: ['.js', '.jsx', '.json'],
  },
  node: false, // Disable all Node.js polyfills and mocks
  performance: {
    hints: process.env.NODE_ENV === 'production' ? 'warning' : false,
  },
};
