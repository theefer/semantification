require 'rubygems'

require 'sinatra'
require 'erubis'

require 'yaml'

class Storage
  def get_by_id(id)
    raise NotImplementedError
  end
end


class YamlStorage < Storage
  def initialize(root_dir)
    @root_dir = root_dir
  end

  def get_by_id(id)
    path = "#{@root_dir}/#{id}.yml"
    YAML.load_file(path) if File.exists?(path)
  end

  def filter(matcher, limit=nil)
    # TODO: use limit if set
    item_ids = Dir.entries(@root_dir).map {|f| f.scan(/(.+)\.yml$/)[0]}.flatten.compact
    item_ids.
      # FIXME: correctly map id
      map {|id| [id, YAML.load_file("#{@root_dir}/#{id}.yml")]}.
      select {|id, data| matcher.all? {|key, val| data[key] == val} }
  end
end


module BackedByYaml
  module ClassMethods
    def data_store
      @data_store ||= YamlStorage.new(@mock_dir)
    end

    def get_by_id(id)
      data = data_store.get_by_id(id)
      data && self.new(id, data)
    end

    def filter(matcher, limit=nil)
      items = data_store.filter(matcher, limit)
      items.map {|id, data| self.new(id, data)}
    end

    def set_mock_path(mock_dir)
      @mock_dir = mock_dir
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end
end


class Article
  attr_reader :id, :title, :author, :body, :published_date, :main_image, :main_image_caption

  include BackedByYaml
  set_mock_path "mock_data/articles"

  def initialize(id, data)
    @id = id
    @type = data[:type]
    @title = data[:title]
    @author = data[:author]
    @body = data[:body]
    @published_date = data[:published_date]
    @main_image = data[:main_image]
    @main_image_caption = data[:main_image_caption]

    @main_event_id = data[:main_event]
  end

  def main_event
    @main_event ||= @main_event_id && Event.get_by_id(@main_event_id)
  end

  def secondary_events
    []
  end

  def main_story
    main_event.main_story
  end

  def extract_main_actors(limit)
    # TODO: parse?
    @body.scan(/<span class="gu-ref.*" data-ref-id="(.*?)">.*?<\/span>/)
  end
end


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


class Actor
  attr_reader :first_name, :last_name

  include BackedByYaml
  set_mock_path "mock_data/actors"

  def initialize(id, data)
    @id = id
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @bio = data[:bio]
    @image = data[:image]
    # more stuff
  end
end

# class Person < Actor
# end

# class Organisation < Actor
# end

class Role
  attr_reader :type, :actor

  def initialize(type, actor)
    @type = type
    @actor = actor
  end
end






class Page
  def initialize(content_name)
    @page_template = read_template('page')
    @content_template = read_template("content/#{content_name}")
  end

  def render(data)
    content = @content_template.result(data)
    @page_template.result(:content => content)
  end

  private

  def read_template(name)
    template = File.read("templates/#{name}.erb")
    Erubis::Eruby.new(template)
  end
end


class TrendingService
  def initialize
  end

  def get_top_items(limit)
  end
end

class RecommendationService
  def initialize
  end

  def find_next_articles(article, user)
  end
end


TRENDING_SERVICE = TrendingService.new
RECOMMENDATION_SERVICE = RecommendationService.new

USER = 'you'


# static assets in /public
set :public_folder, 'public'


get '/' do
  # Hacky index of all articles on the root page
  all_articles = Article.filter({})
  "<ul>" + all_articles.map {|a| "<li><a href=\"/article/#{a.id}\">#{a.title}</a></li>"}.join + "</ul>"
end


get '/story/:id' do
  id = params[:id]
  # render STORY
end

get '/event/:id' do
  id = params[:id]
  event = Event.get_by_id(id)
  main_image = event.main_image
  background = event.background

  latest_updates = event.latest_updates

  main_story = event.main_story # stories?
  previous_events = main_story.events_before(event)
  # and next, when not on latest event

  # TODO: determine:
  # - is the event live/current
  # - is the event the most recent in its story

  related_stories = main_story.get_related_stories_for(event) # i.e. not the main story?
  

  live_articles = event.find_live_articles
  quote = event.extract_related_quote

  opinion_articles = event.get_articles_by_type(:opinion, 2)

  # get impact on you articles?
  # get in depth articles?
  # get whatever man?

  # render EVENT
  page = Page.new('event')
  page.render({ :event => event,
                :main_story => main_story })
end

get '/article/:id' do
  id = params[:id]
  article = Article.get_by_id(id) or halt 404
  main_story = article.main_story
  main_event = article.main_event
  related_events = article.secondary_events
  latest_updates = main_event.latest_updates

  main_actors = article.extract_main_actors(3)

  quote = main_event.extract_related_quote

  next_articles = RECOMMENDATION_SERVICE.find_next_articles(article, USER)

  trending_items = TRENDING_SERVICE.get_top_items(3)

  # render ARTICLE
  page = Page.new('article')
  page.render({ :article    => article,
                :main_event => main_event,
                :main_story => main_story })
end




# Or an API?

get '/api/story/:id' do
  # STORY
end
