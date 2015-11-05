class Repository
  include Neo4j::ActiveNode

  property :full_name, index: :exact
  property :name
  property :source, type: Boolean
  property :description
  property :url

  has_many :out, :forks, type: 'FORK', model_class: 'Repository'
  has_one :in, :owner, origin: :repositories, model_class: 'User'

  def from_github(data)
    update_attributes!(
      name: data.name,
      source: !data.fork,
      description: data.description,
      url: data.url
    )
  end
end
