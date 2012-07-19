
TRENDING_SERVICE = TrendingService.new
RECOMMENDATION_SERVICE = RecommendationService.new

USER = 'you'

# static assets in /public
set :public_folder, 'app/public'

set :protection, :except => :json_csrf

get '/' do
  # Hacky index of all articles on the root page
  all_articles = Article.filter({})
  "<ul>" + all_articles.map {|a| "<li><a href=\"/articles/#{a.id}\">#{a.title}</a></li>"}.join + "</ul>"
end


get '/stories/:id' do
  id, format = params[:id].scan(/^([^.]+)(?:\.(.+))?$/)[0]
  # render STORY
end

get '/events/:id' do
  id, format = params[:id].scan(/^([^.]+)(?:\.(.+))?$/)[0]

  event = Event.get_by_id(id)
  main_image = event.main_image
  background = event.background

  latest_updates = event.latest_updates(5)

  previous_events = []
  related_stories = []

  main_story = event.main_story # stories?
  if main_story
    previous_events = main_story.events_before(event)
    # and next, when not on latest event

    related_stories = main_story.get_related_stories_for(event) # i.e. not the main story?
  end

  live_article = event.find_live_article
  quote = event.extract_related_quote

  all_articles = event.get_all_articles
  opinion_articles = event.get_articles_by_type('opinion', 2)

  # get impact on you articles?
  # get in depth articles?
  # get whatever man?

  # ad-hoc :'-(
  concept_widgets = event.widgets.map {|name| name.scan(/definition\/(.*)/)}.flatten.compact.map {|concept_name| Concept.get_by_id(concept_name)}

  # render EVENT
  page = Page.new('event')
  data = {
    :event => event,
    :main_story => main_story,
    :all_articles => all_articles,
    :concept_widgets => concept_widgets,
    :previous_events => previous_events
  }
  case params[:format]
  when 'ahah'
    page.render_content(data)
  else
    page.render(data)
  end
end

get '/articles/:id' do
  id, format = params[:id].scan(/^([^.]+)(?:\.(.+))?$/)[0]

  article = Article.get_by_id(id) or halt 404
  main_story = article.main_story
  main_event = article.main_event
  related_events = article.secondary_events
  latest_updates = main_event.latest_updates(5)

  main_actors = article.extract_main_actors(3)

  quote = main_event.extract_related_quote

  # render ARTICLE
  page = Page.new('article')
  data = {
    :article    => article,
    :main_event => main_event,
    :main_story => main_story,
    :main_actors => main_actors,
    :latest_updates => latest_updates
  }
  case format
  when 'ahah'
    page.render_content(data)
  when nil, 'html'
    page.render(data)
  else
    halt 404
  end
end




# Or an API?

get '/api/search/:query' do
  query = params[:query]
  events = Event.filter({:title => Regexp.new(query, 'i')})
  events_data = events.map do |ev|
    { :type  => 'event',
      :title => ev.title,
      :id    => ev.id }
  end

  content_type "application/json"
  events_data.to_json
end

get '/api/stories/:id' do
  id = params[:id]
  story = Story.get_by_id(id) or halt 404
  story_data = story.data
  data = story_data.merge({
    :uri => "/api/stories/#{story_data[:id]}",
    :links => [{:rel => 'main_actors',
                :href => "/api/stories/#{story_data[:id]}/main_actors"}]
  })

  content_type "application/json"
  data.to_json
end

get '/api/stories/:id/main_actors' do
  id = params[:id]
  story = Story.get_by_id(id) or halt 404
  story_data = story.data
  data = story_data.merge({
                            :uri => "/api/stories/#{story_data[:id]}",
                            :links => [{:rel => '', :href => ''}
                                      ]
  })

  content_type "application/json"
  story.data.to_json
end
