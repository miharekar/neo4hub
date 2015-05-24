require 'organization'
require 'repository'
require 'user'

class Importer
  attr_reader :client

  def initialize
    Octokit.auto_paginate = true
    @client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
  end

  def import_user(login)
    User.find_or_create_by(login: login).tap do |user|
      data = client.user(login)
      user.from_github(data)
    end
  end

  def import_followers(user)
    client.followers(user.login).each do |data|
      follower = User.find_or_create_by(login: data.login)
      create_followers(follower, user)
    end
  end

  def import_followings(user)
    client.following(user.login).each do |data|
      following = User.find_or_create_by(login: data.login)
      create_followers(user, following)
    end
  end

  def import_owned_repositories(user)
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

  def import_organizations(user)
    client.organizations(user.login).each do |data|
      org = Organization.find_or_create_by(login: data.login) do |o|
        o.from_github(data)
      end
      org.create_rel('MEMBER', user) unless org.members.include?(user)
    end
  end

  private

  def create_followers(follower, following)
    return if follower.followings.include?(following)
    follower.create_rel('FOLLOWS', following)
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
end
