const webpack = require('webpack')
const path = require('path')

module.exports = {
	context: path.resolve(__dirname, './src/js'),
	entry: {
		index: './index.js'
	},
	output: {
		path: path.join(__dirname, 'dist/js/'),
		filename: '[name].js'
	},
	module: {
		loaders: [{
			test: /\.tag$/,
			enforce: 'pre',
			exclude: /node_modules/,
			loader: 'tag-pug-loader'
		},{
			test: /\.js|\.tag$/,
			enforce: 'post',
			exclude: /node_modules/,
			use: {
				loader: 'babel-loader',
				query: {
					presets: ['es2015-riot']
				}
			}
		}]
	},
	resolve: {
		extensions: ['.js', '.tag']
	},
	plugins: [
		new webpack.ProvidePlugin({
			riot: 'riot'
		}),
		new webpack.DefinePlugin({
			'process.env': {
				NODE_ENV: JSON.stringify('production')
			}
		}),
		new webpack.optimize.UglifyJsPlugin({
			compress: {
				warnings: false
			},
			mangle: true
		})
	]
}