
class Page
  include Templated

  def initialize(content_name)
    @page_template = read_template('page')
    @content_template = read_template("content/#{content_name}")
  end

  def render_content(data)
    @content_template.result(data)
  end

  def render(data)
    content = render_content(data)
    @page_template.result(:content => content)
  end
end
