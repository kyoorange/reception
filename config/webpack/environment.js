// config/webpack/environment.js
const { environment } = require('@rails/webpacker'); // Shakapackerバージョンではこれを変更する場合もあるので確認が必要
const webpack = require('webpack');

// Babelの設定を追加（JSXのサポート）
environment.loaders.append('babel', {
    test: /\.jsx?$/,
    exclude: /node_modules/,
    use: {
        loader: 'babel-loader',
        options: {
            presets: ['@babel/preset-react'] // JSXの変換
        }
    }
});

// Provide PluginでReactとReactDOMを自動インポート
environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
        React: 'react',
        ReactDOM: 'react-dom'
    })
);

module.exports = environment;
