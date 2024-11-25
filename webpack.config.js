const path = require('path');

module.exports = {
  // Entry file: specify the starting point of your application
  entry: './app/javascript/packs/application.js', // Adjust this to your entry file location
  
  // Output: where Webpack will save the bundled file
  output: {
    path: path.resolve(__dirname, 'public/packs'), // Adjust this to your desired output directory
    filename: 'bundle.js',
  },

  // Mode: specify development or production mode
  mode: 'development', // Change to 'production' for optimized builds

  // Module: define how files are processed
  module: {
    rules: [
      {
        test: /\.js$/, // Process JavaScript files
        exclude: /node_modules/, // Exclude node_modules
        use: {
          loader: 'babel-loader', // Use Babel to transpile JavaScript
        },
      },
    ],
  },

  // Resolve: specify file extensions Webpack should look for
  resolve: {
    extensions: ['.js', '.jsx', '.json'],
  },
};
