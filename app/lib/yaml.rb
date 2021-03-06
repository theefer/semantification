class Storage
  def get_by_id(id)
    raise NotImplementedError
  end

  def filter(matcher, limit)
    raise NotImplementedError
  end
end

class YamlStorage < Storage
  def initialize(root_dir)
    @root_dir = root_dir
  end

  def get_by_id(id)
    path = "#{@root_dir}/#{id}.yml"
    YAML.load_file(path) if File.exists?(path)
  end

  def filter(matcher, limit=nil)
    # TODO: use limit if set
    item_ids = Dir.entries(@root_dir).map {|f| f.scan(/(.+)\.yml$/)[0]}.flatten.compact
    items = item_ids.
      # FIXME: correctly map id
      map {|id| [id, YAML.load_file("#{@root_dir}/#{id}.yml")]}.
      select {|id, data| data}.
      select {|id, data| matcher.all? {|key, val| match(data[key], val)} }
    items = items.take(limit) if limit
    items
  end

  def match(left, right)
    case right
    when Regexp
      left.match(right)
    else
      left == right
    end
  end
end


module BackedByYaml
  module ClassMethods
    def data_store
      @data_store ||= YamlStorage.new(@mock_dir)
    end

    def get_by_id(id)
      data = data_store.get_by_id(id)
      data && self.new(id, data)
    end

    def filter(matcher, limit=nil)
      items = data_store.filter(matcher, limit)
      items.map {|id, data| self.new(id, data)}
    end

    def set_mock_path(mock_dir)
      @mock_dir = mock_dir
    end
  end

  def self.included(klass)
    klass.extend(ClassMethods)
  end
end
