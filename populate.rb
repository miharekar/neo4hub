$LOAD_PATH.unshift('.')
require 'init'
require 'importer'

importer = Importer.new
%w(
  ahoward amcaplan jodosha jessitron acuppy
  kickinbahk mrfoto kerrizor ryanstout GregBaugues
  CoralineAda schneems xionon freddyrangel indirect
  tenderlove
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
