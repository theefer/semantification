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

  def events_before(event, limit=nil)
    all_events = Event.filter({:main_story => self.id}, limit)
    all_events.select do | e |
      event_date = Time.parse(event.date)
      e_date = Time.parse(e.date)
      e_date > event_date
    end   
  end

  def events
    all_events = Event.filter({:main_story => self.id})
    all_events.sort do |a, b|
      Time.parse(a.date) <=> Time.parse(b.date)
    end   
  end

  def get_related_stories_for(event)
    
  end

  def data
    @data.merge(:id => @id)
  end

  def main_image
  end
end
