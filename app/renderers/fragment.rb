class Fragment
  include Templated

  def initialize(fragment_name)
    @fragment_template = read_template("content/fragments/#{fragment_name}")
  end

  def render(data={})
    @fragment_template.result(data)
  end
end
