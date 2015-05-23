class Organization
  include Neo4j::ActiveNode

  property :login, index: :exact
  property :description
  property :url

  has_many :out, :members, type: 'MEMBER', model_class: 'User'
  has_many :out, :repositories, type: 'OWNS', model_class: 'Repository'

  def from_github(data)
    update_attributes!(
      description: data.description,
      url: data.url
    )
  end
end
