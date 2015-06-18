require 'util'
require 'thor'
require 'thor/group'
require 'active_support/core_ext/string/inflections'

class Generator
  include Util
  include Thor::Actions





  attr_accessor :licence,:user_name,:package,:fs_path,:model_name,:repository_import,:repository_type,:full


  def initialize
    @licence = licence
    @user_name = user_name
    @package = config.group_id.split('.').each {|part| part.gsub!(/\W/,'')}.join('.')
    @fs_path = @package.gsub('.','/')
    @repository_import = Generator.repository_configuration(config.repository_technique).const_get :REPOSITORY_IMPORT
    @repository_type = Generator.repository_configuration(config.repository_technique).const_get :REPOSITORY_TYPE
    @destination_stack = [self.class.source_root]
  end

  def self.source_root
    File.expand_path('../',__dir__)
  end

  def generate(template,target)
    puts "take the template #{template}"
    puts "and put it here: #{target}"
    template(template,target)
  end

  def self.for_model(model_name,options,&block)
    instance = Generator.new
    instance.model_name = model_name
    instance.full = options['full']
    block.call instance
  end
end