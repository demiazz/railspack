var path = require('path');
var fs = require('fs');
var yaml = require('js-yaml');
var normalize = require('normalize-object');
var webpack = require('webpack');
var StatsPlugin = require('stats-webpack-plugin');
var ExtractTextPlugin = require('extract-text-webpack-plugin');
var CompressionPlugin = require('compression-webpack-plugin');


//--- Utilities

function getRailspackConfigFor(environment) {
  var filePath = path.join(__dirname, 'railspack.yml');
  var content = fs.readFileSync(filePath, 'utf8');
  var config = yaml.safeLoad(content);

  return normalize(config[environment], 'camel');
}

//--- Environment

var railsEnv = process.env.RAILS_ENV || 'development';

if (!process.env.NODE_ENV) {
  process.env.NODE_ENV = railsEnv;
}

var nodeEnv = process.env.NODE_ENV;

var isProduction = nodeEnv === 'production';

//--- Railspack configuration

var railspack = getRailspackConfigFor(railsEnv);

//--- Paths

var railsRoot = path.join(__dirname, '..');

//--- Base configuration

var config = {
  entry: path.join(railsRoot, 'front', 'index.js'),

  output: {
    path: path.join(railsRoot, railspack.paths.outputPath),
    publicPath: path.join('/', railspack.paths.publicPath, '/'),
  },

  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel',
      },
    ],
  },

  plugins: [
    new webpack.EnvironmentPlugin(['NODE_ENV']),

    new webpack.DefinePlugin({
      __DEV__: !isProduction,
    }),

    new StatsPlugin(railspack.paths.manifest, {
      chunkModules: false,
      source: false,
      chunks: false,
      modules: false,
      assets: true,
    }),
  ],
};

//--- Output configuration

config.output.filename = isProduction ? '[name]-[chunkhash].js' : '[name].js';

//--- Development tools

config.devtool = isProduction ? 'source-map' : 'eval';

if (!isProduction) {
  config.output.pathinfo = true;
}

//--- CSS loader

var cssLoader = {
  test: /\.css$/,
};
var cssLoaders = [
  'css-loader?' + JSON.stringify({
    sourceMap: !isProduction,
    minimize:  isProduction,
  }),
  'postcss-loader',
];

if (isProduction) {
  cssLoader.loader = ExtractTextPlugin.extract('style-loader', cssLoaders);
} else {
  cssLoader.loaders = ['style-loader'].concat(cssLoaders);
}

config.module.loaders.push(cssLoader);

//--- PostCSS loader

var pcssLoader = {
  test: /\.pcss/,
};
var pcssLoaders = [
  'css-loader?' + JSON.stringify({
    sourceMap: !isProduction,
    modules: true,
    localIdentName: isProduction
      ? '[hash:base64:4]'
      : '[name]__[local]___[hash:base64:3]',
    camelCase: true,
    minimize: isProduction,
  }),
  'postcss-loader?pack=modules',
];

if (isProduction) {
  pcssLoader.loader = ExtractTextPlugin.extract('style-loader', pcssLoaders);
} else {
  pcssLoader.loaders = ['style-loader'].concat(pcssLoaders);
}

config.module.loaders.push(pcssLoader);

// PostCSS

config.postcss = function postcssPacks() {
  return {
    defaults: [autoprefixer],
    modules: [autoprefixer],
  };
};

//--- Plugins

if (!isProduction) {
  config.plugins.push(
    new ExtractTextPlugin('[name]-[hash].css')
  );

  config.plugins.push(
    new webpack.optimize.UglifyJsPlugin({
      compressor: {
        warnings: false,
        screw_ie8: true,
      },
    })
  );

  config.plugins.push(
    new webpack.optimize.DedupePlugin()
  );

  config.plugins.push(
    new webpack.optimize.OccurenceOrderPlugin(true)
  );

  config.plugins.push(
    new CompressionPlugin({
      algorithm: 'zopfli',
    })
  );
} else {
  config.plugins.push(
    new webpack.NoErrorsPlugin()
  );
}

//--- Development server

config.devServer = {
  host: railspack.server.host,
  port: railspack.server.port,
  https: railspack.server.https,
  headers: {
    'Access-Control-Allow-Origin': '*',
  },
  stats: {
    colors: true,
  },
};

if (railspack.server.enabled) {
  var protocol = railspack.server.https ? 'https://' : 'http://';
  var address = railspack.server.host + ':' + railspack.server.port;

  config.output.publicPath = protocol + address + config.output.publicPath;
}


module.exports = config;
