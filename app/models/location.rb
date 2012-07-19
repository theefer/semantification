class Location
  attr_reader :id, :name, :lat, :long, :zoom, :description

  include BackedByYaml
  set_mock_path "mock_data/locations"

  def initialize(id, data)
    @id = id
    @name = data[:name]
    @lat = data[:lat]
    @long = data[:long]
    @zoom = data[:zoom]
    @description = data[:description]
  end
end
