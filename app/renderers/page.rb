
class Page
  include Templated

  def initialize(content_name)
    @content_name = content_name
    @page_template = read_template('page')
  end

  def template(type)
    read_template("content/#{type}")
  end

  def render_content(data)
    template(@content_name).result(data)
  end

  def render(data)
    content_position = {
      'story' => 'background',
      'event' => 'event',
      'article' => 'depth'
    }[@content_name]

    @page_template.result({
      :story_id => path_from_data(:story, data),
      :story => content_from_data(:story, data),
      :event_id => path_from_data(:event, data),
      :event => content_from_data(:event, data),
      :article_id => path_from_data(:article, data),
      :article => content_from_data(:article, data),
      :content_position => content_position,
      :content_name => @content_name
    })
  end

  def path_from_data(type, data)
    if id = data[type] && data[type][type] && data[type][type].id
      "/#{plural(type)}/#{id}"
    else
      ''
    end
  end

  def content_from_data(type, data)
    (data[type] && template(type.to_s).result(data[type])) || ''
  end

  def plural(type)
    {
      :story => 'stories',
      :event => 'events',
      :article => 'articles'
    }[type]
  end
end
