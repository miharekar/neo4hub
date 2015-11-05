class User
  include Neo4j::ActiveNode

  property :login, index: :exact
  property :name
  property :blog
  property :location
  property :email

  has_many :out, :followings, type: 'FOLLOWS', model_class: 'User'
  has_many :out, :repositories, type: 'OWNS'
  has_many :in, :organizations, origin: :members

  def from_github(data)
    update_attributes!(
      name: data.name,
      blog: data.blog,
      location: data.location,
      email: data.email
    )
  end
end
