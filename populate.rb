users = %w(
  mrfoto mfilej otobrglez zzak tenderlove matz wycats josevalim dhh mislav
  bbatsov ahoward juliancheal benlovell sferik myabc bogdan listochkin le0pard
  petrokoriakin fxposter vladislav-gorbenko
)

$LOAD_PATH.unshift('.')
require 'init'
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
