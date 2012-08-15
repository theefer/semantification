
class Role
  attr_reader :type, :actor, :description

  def initialize(type, actor, description)
    @type = type
    @actor = actor
    @description = description
  end
end
