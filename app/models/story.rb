class Story
  attr_reader :id, :title, :synopsis

  include BackedByYaml
  set_mock_path "mock_data/stories"

  def initialize(id, data)
    @id = id
    @title = data[:title]
    @synopsis = data[:synopsis]
    @summary = data[:summary]
    @background = data[:background]
  end

  def events_before(event)
  end

  def get_related_stories_for(event)
  end
end


