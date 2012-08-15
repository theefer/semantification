class Actor

  attr_reader :id, :bio, :thumbnail, :wide_thumbnail, :image
  include BackedByYaml
  set_mock_path "mock_data/actors"

  def initialize(id, data)
    @id = id
    @name = data[:name]
    @bio = data[:bio]
    @thumbnail = data[:thumbnail]
    @wide_thumbnail = data[:wide_thumbnail]
    @image = data[:image]
    # more stuff
  end

  def full_name
    @name
  end
end

# class Person < Actor
# end

# class Organisation < Actor
# end
