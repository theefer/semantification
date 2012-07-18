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

  def latest_updates(limit)
    if liveblog = find_live_article
      updates = liveblog.body[0..limit]
      updates.
        map {|upd| upd[:date] = Time.parse(upd[:date]); upd}.
        # hack: inject article to explicit the source
        map {|upd| upd[:article] = liveblog; upd}
    end
  end

  # return a live article (or nil if none)
  def find_live_article
    live_articles = get_articles_by_type('liveblog', 3)
    live_articles.find(&:is_live?)
  end

  def extract_related_quote
  end

  def get_all_articles(limit=nil)
    Article.filter({:main_event => self.id}, limit)
  end

  def get_articles_by_type(type, limit=nil)
    Article.filter({:main_event => self.id, :type => type}, limit)
  end
end
