class Concept
  attr_reader :title, :definition

  include BackedByYaml
  set_mock_path "mock_data/concepts"

  def initialize(id, data)
    @id = id
    @title = data[:title]
    @definition = data[:definition]
  end
end
