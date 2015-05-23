require 'bundler'
Bundler.require
$LOAD_PATH.unshift(*['.', 'models/'])

auth = {username: ENV['NEO4J_USERNAME'], password: ENV['NEO4J_PASSWORD']}
Neo4j::Session.open(:server_db, 'http://localhost:7474', basic_auth: auth)

require 'importer'
users = %w(mrfoto mfilej otobrglez)
Importer.new(users).import
