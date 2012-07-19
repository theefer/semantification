
require 'rubygems'

require 'sinatra'
require 'erubis'
require 'yaml'
require 'json'
require 'time-ago-in-words'
require 'auto_excerpt'

# libs 

require 'app/lib/yaml'

# models

require 'app/models/article'
require 'app/models/event'
require 'app/models/story'
require 'app/models/actor'
require 'app/models/role'
require 'app/models/concept'
require 'app/models/location'

# renderers

require 'app/renderers/templated'
require 'app/renderers/page'
require 'app/renderers/fragment'

# services

require 'app/services/trending'
require 'app/services/recommendation'

# bootstrap

require 'app/server'

run Sinatra::Application


