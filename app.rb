require 'rubygems'

require 'sinatra'
require 'erubis'

require 'yaml'

require 'lib/yaml'

require 'models/article'
require 'models/event'
require 'models/story'
require 'models/actor'
require 'models/page'
require 'models/role'

require 'services/trending'
require 'services/recommendation'

# -----

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
