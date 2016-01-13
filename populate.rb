$LOAD_PATH.unshift('.')
require 'init'
require 'importer'

importer = Importer.new
%w(
  vidmantas tadassce giedriusr bugo liucijus mmozuras
  andriusch tomasv jpalumickas eugenijusr nedomas
  tenderlove wycats ryanb holman
  mrfoto otobrglez matixmatix mfilej
).each do |login|
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
