class Place
  attr_reader :location, :latitude, :longitude 

  include BackedByYaml
  set_mock_path "mock_data/places"

  def initialize(id, data)
    @id = id
    @location = data[:location]
    @latitude = data[:latitude]
    @longitude = data[:longitude]
    # more stuff
  end
end
