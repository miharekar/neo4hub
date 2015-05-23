$LOAD_PATH.unshift(*['.', 'models/'])
require 'bundler'
Bundler.require
Dotenv.load

auth = {username: ENV['NEO4J_USERNAME'], password: ENV['NEO4J_PASSWORD']}
Neo4j::Session.open(:server_db, 'http://localhost:7474', basic_auth: auth)

users = %w(
  mrfoto mfilej otobrglez zzak tenderlove matz wycats josevalim dhh mislav
  bbatsov ahoward juliancheal benlovell sferik myabc bogdan listochkin le0pard
  petrokoriakin fxposter vladislav-gorbenko
)

require 'importer'
importer = Importer.new
users.each do |login|
  p "Importing #{login}..."
  user = importer.import_user(login)
  p '...followers'
  importer.import_followers(user)
  p '...followings'
  importer.import_followings(user)
  p '...repositories'
  importer.import_owned_repositories(user)
  p '...organizations'
  importer.import_organizations(user)
end
