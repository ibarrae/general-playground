const path = require("path");
const HTMLWebpackPlugin = require("html-webpack-plugin");
const webpack = require("webpack");
const env = require("dotenv").config();

module.exports = {
  entry: {
    app: ["./src/index.js"]
  },

  output: {
    path: path.resolve(__dirname + "/dist"),
    filename: "[name].js"
  },

  module: {
    rules: [
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: "html-loader"
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: "elm-webpack-loader",
            options: { verbose: true, debug: true }
          }
        ]
      }
    ],

    noParse: /\.elm$/
  },

  plugins: [
    new HTMLWebpackPlugin({
      template: "src/index.html",
      inject: "body"
    }),
    new webpack.DefinePlugin({
      API_ROOT: JSON.stringify(env.parsed.API_ROOT)
    })
  ],

  devServer: {
    inline: true,
    stats: { colors: true }
  }
};
