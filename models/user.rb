class User
  include Neo4j::ActiveNode

  property :login, index: :exact
  property :name
  property :blog
  property :location
  property :email

  has_many :out, :followers, type: 'FOLLOWS', model_class: 'User'
  has_many :out, :repositories, type: 'OWNS', model_class: 'Repository'
  has_many :in, :organizations, type: 'MEMBER', model_class: 'Organization'

  def from_github(data)
    update_attributes!(
      name: data.name,
      blog: data.blog,
      location: data.location,
      email: data.email
    )
  end
end
