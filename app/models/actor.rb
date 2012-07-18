class Actor
  attr_reader :first_name, :last_name

  include BackedByYaml
  set_mock_path "mock_data/actors"

  def initialize(id, data)
    @id = id
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @bio = data[:bio]
    @image = data[:image]
    # more stuff
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end

# class Person < Actor
# end

# class Organisation < Actor
# end
