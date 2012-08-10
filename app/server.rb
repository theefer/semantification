
TRENDING_SERVICE = TrendingService.new
RECOMMENDATION_SERVICE = RecommendationService.new

USER = 'you'


def prepare_content(root)
  case root
  when Story
    {}

  when Event
    main_image = root.main_image
    background = root.background

    latest_updates = root.latest_updates(5)

    previous_events = []
    related_stories = []

    main_story = root.main_story # stories?
    if main_story
      previous_events = main_story.events_before(event)
      # and next, when not on latest event

      related_stories = main_story.get_related_stories_for(event) # i.e. not the main story?
    end

    live_article = root.find_live_article
    quote = root.extract_related_quote

    all_articles = root.get_all_articles
    opinion_articles = root.get_articles_by_type('opinion', 2)

    # get impact on you articles?
    # get in depth articles?
    # get whatever man?

    # ad-hoc :'-(
    concept_widgets = root.widgets.map {|name| name.scan(/definition\/(.*)/)}.flatten.compact.map {|concept_name| Concept.get_by_id(concept_name)}
    {
      :event           => root,
      :main_story      => main_story,
      :all_articles    => all_articles,
      :concept_widgets => concept_widgets,
      :previous_events => previous_events
    }

  when Article
    main_story = root.main_story
    main_event = root.main_event
    # related_events = root.secondary_events
    latest_updates = main_event.latest_updates(5)

    main_actors = root.extract_main_actors(3)

    # quote = main_event.extract_related_quote
    {
      :article        => root,
      :main_event     => main_event,
      :main_story     => main_story,
      :main_actors    => main_actors,
      :latest_updates => latest_updates
    }
  end
end


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

  page = Page.new('event')
  event_data = prepare_content(event)

  case params[:format]
  when 'ahah'
    page.render_content(event_data)
  else
    page.render({:event => event_data})
  end
end

get '/articles/:id' do
  id, format = params[:id].scan(/^([^.]+)(?:\.(.+))?$/)[0]

  article = Article.get_by_id(id) or halt 404

  page = Page.new('article')
  article_data = prepare_content(article)

  case format
  when 'ahah'
    page.render_content(article_data)
  when nil, 'html'
    page.render({:article => article_data,
                 :event   => prepare_content(article.main_event)})
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
