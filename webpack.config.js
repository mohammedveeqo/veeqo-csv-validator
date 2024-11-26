const path = require('path');

module.exports = {
  entry: './app/javascript/packs/application.js', // Path to your entry file
  output: {
    path: path.resolve(__dirname, 'public/packs'), // Output directory
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
  node: false, // Disables all Node.js polyfills and mocks
  performance: {
    hints: process.env.NODE_ENV === 'production' ? 'warning' : false,
  },
};
