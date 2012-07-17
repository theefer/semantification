require 'rubygems'

require 'sinatra'
require 'erubis'


def read_template(name)
  template = File.read("templates/#{name}.erb")
  Erubis::Eruby.new(template)
end

get '/' do
  # HOMEPAGE
  template = read_template('welcome')
  template.result(:who => "You")
end

get '/demo-page' do
  read_template('test').result
end

get '/story/:id' do
  id = params[:id]
  # STORY
end

get '/event/:id' do
  id = params[:id]
  # EVENT
end

get '/article/:id' do
  id = params[:id]
  # ARTICLE
end


# Or an API?

get '/api/story/:id' do
  # STORY
end
