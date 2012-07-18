
require 'rubygems'

require 'sinatra'
require 'erubis'
require 'yaml'

# libs 

require 'app/lib/yaml'

# models

require 'app/models/article'
require 'app/models/event'
require 'app/models/story'
require 'app/models/actor'
require 'app/models/page'
require 'app/models/role'

# services

require 'app/services/trending'
require 'app/services/recommendation'

# bootstrap

require 'app/server'

run Sinatra::Application


