class PluginLoader
  BASE_DIR = File.dirname(__FILE__)
  
  class NoPluginFound < Exception
  end
  
  def initialize
    # load all ruby files in subdirectories
    Dir[File.join(BASE_DIR, '*')].each do |f|
      if File.directory?(f)
        Dir[File.join(f, '*.rb')].each do |rb_file|
          require rb_file
        end
      end
    end
    
    @plugins = {}
    ObjectSpace::each_object(Class) do |k|
      if k.include?(Plugin) and k.plugin_name
        @plugins[k.plugin_name] = k
      end
    end
    
  end
  
  def each(&blk)
    @plugins.each_value(&blk)
  end
  
  def get_matching(required, optional = [])
    plugins = @plugins.values.
      reject {|x| not x.matches?(required) }.
      sort_by {|x| x.score(optional) }
    raise NoPluginFound if plugins.empty?
    plugins.last
  end
end