class Story
  attr_reader :id, :title, :synopsis
  # TODO: find a way to do something like:
  # attr_reader :id
  # data_attr :title, :synopsis, :summary, :background

  include BackedByYaml
  set_mock_path "mock_data/stories"

  def initialize(id, data)
    @id = id
    @data = data
    @title = data[:title]
    @synopsis = data[:synopsis]
    @summary = data[:summary]
    @background = data[:background]
  end

  def events_before(event)
    
  end

  def get_related_stories_for(event)
    
  end

  def data
    @data.merge(:id => @id)
  end

  def main_image
  end
end
