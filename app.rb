require 'rubygems'

require 'sinatra'
require 'erubis'




class Article
  def initialize()
    @id
    @title
    @author
    @body
    @published_date
    @main_image
  end

  def self.get_by_id(id)
    data = somehow_by_id
    Article.new(data)
  end
end


class Event
  def initialize()
    @id
    @title
    @synopsis
    @summary
    @background
    @main_story
    @roles
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
  end

  def self.get_by_id(id)
    data = somehow_by_id
    Event.new(data)
  end  
end


class Story
  def initialize()
    @id
    @title
    @synopsis
    # @summary
    # @background
  end

  def events_before(event)
  end

  def get_related_stories_for(event)
  end
end


class Actor
  def initialize
    @first_name
    @last_name
    @bio
    @image
    # more stuff
  end
end

class Person < Actor
  def initialize
  end
end

class Organisation < Actor
  def initialize
  end
end

class Role
  def initialize
    @type
    @actor
  end
end





def read_template(name)
  template = File.read("templates/#{name}.erb")
  Erubis::Eruby.new(template)
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

  def find_next_articles(article)
  end
end


TRENDING_SERVICE = TrendingService.new
RECOMMENDATION_SERVICE = RecommendationService.new

USER = 'you'


get '/' do
  # HOMEPAGE
  template = read_template('welcome')
  template.result(:who => "You")
end

get '/tests' do
  read_template('test').result
end


get '/story/:id' do
  id = params[:id]
  # STORY
end

get '/event/:id' do
  id = params[:id]
  event = Event.get_by_id(id)
  main_image = event.main_image
  background = event.background

  latest_updates = event.latest_updates

  story = event.main_story # stories?
  previous_events = story.events_before(event)
  # and next, when not on latest event

  # TODO: determine:
  # - is the event live/current
  # - is the event the most recent in its story

  related_stories = story.get_related_stories_for(event) # i.e. not the main story?
  

  live_articles = event.find_live_articles
  quote = event.extract_related_quote

  opinion_articles = event.get_articles_by_type(:opinion, 2)

  # get impact on you articles?
  # get in depth articles?
  # get whatever man?

  # render EVENT
  template = read_template('event')
  template.result(stuff)
end

get '/article/:id' do
  id = params[:id]
  article = Article.get_by_id(id)
  body = article.body
  story = article.main_story
  main_event = article.main_event
  related_events = article.secondary_events
  latest_updates = main_event.latest_updates

  main_actors = article.extract_main_actors(3)

  quote = main_event.extract_related_quote

  next_articles = RECOMMENDATION_SERVICE.find_next_articles(article, USER)

  trending_items = TRENDING_SERVICE.get_top_items(3)

  # render ARTICLE
  template = read_template('article')
  template.result(stuff)
end




# Or an API?

get '/api/story/:id' do
  # STORY
end
