class Event
  attr_reader :id, :title, :synopsis, :summary, :background

  include BackedByYaml
  set_mock_path "mock_data/events"

  def initialize(id, data)
    @id = id
    @title = data[:title]
    @synopsis = data[:synopsis]
    @summary = data[:summary]
    @background = data[:background]

    @main_story_id = data[:main_story]
    @roles_ids = data[:roles]
  end

  def roles
    @roles ||= @roles_ids.map do |role|
      actor = Actor.get_by_id(role[:actor])
      Role.new(role[:type], actor)
    end
  end

  def main_story
    @main_story ||= @main_story_id && Story.get_by_id(@main_story_id)
  end

  def is_live? # or active?
  end

  def is_latest_event_in_story?
  end

  def main_image
  end

  def latest_updates
    []
  end

  def find_live_articles
    # or not, if none
  end

  def extract_related_quote
  end

  def get_articles_by_type(type, limit)
    articles = Article.filter({:main_event => self.id, :type => type}, limit)
  end
end
