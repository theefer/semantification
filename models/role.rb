
class Role
  attr_reader :type, :actor

  def initialize(type, actor)
    @type = type
    @actor = actor
  end
end
