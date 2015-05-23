require 'organization'
require 'repository'
require 'user'

class Importer
  attr_reader :users, :client

  def initialize(users)
    @users = users
    Octokit.auto_paginate = true
    @client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
  end

  def import
    # empty_db
    users.each do |login|
      p "Importing #{login}..."
      user = import_user(login)
      import_followers(user)
      import_followings(user)
      import_owned_repositories(user)
      import_organizations(user)
    end
  end

  private

  def empty_db
    User.delete_all
    Repository.delete_all
    Organization.delete_all
  end

  def import_user(login)
    User.find_or_create_by(login: login) do |user|
      data = client.user(login)
      user.from_github(data)
    end
  end

  def import_followers(user)
    p '...followers'
    client.followers(user.login).each do |data|
      follower = User.find_or_create_by(login: data.login)
      create_followers(follower, user)
    end
  end

  def import_followings(user)
    p '...followings'
    client.following(user.login).each do |data|
      following = User.find_or_create_by(login: data.login)
      create_followers(user, following)
    end
  end

  def create_followers(follower, following)
    return if follower.followers.include?(following)
    follower.create_rel('FOLLOWS', following)
  end

  def import_owned_repositories(user)
    p '...repositories'
    client.repos(user.login).each do |data|
      Repository.find_or_create_by(full_name: data.full_name) do |repo|
        repo.from_github(data)
        user.create_rel('OWNS', repo)
        if data.fork
          source = create_source_repository(repo)
          source.create_rel('FORK', repo)
        end
      end
    end
  end

  def create_source_repository(fork)
    data = client.repo(fork.full_name).source
    Repository.find_or_create_by(full_name: data.full_name) do |source|
      source.from_github(data)
      klass = data.owner.type.constantize
      owner = klass.find_or_create_by(login: data.owner.login)
      owner.create_rel('OWNS', source)
    end
  end

  def import_organizations(user)
    p '...organizations'
    client.organizations(user.login).each do |data|
      organization = Organization.find_or_create_by(login: data.login) do |org|
        org.from_github(data)
      end
      organization.create_rel('MEMBER', user) unless org.members.include?(user)
    end
  end
end
