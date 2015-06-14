require 'yaml'

module Util
  Config = Struct.new(:service_name,:repository_technique,:group_id,:artifact_id)
  def content_root
    return @root_dir if @root_dir
    search_dir = Dir.pwd
    while search_dir && !File.exist?("#{search_dir}/service.yml")
      parent = File.dirname(search_dir)
      # project_root wird entweder der Root-pfad oder false. Wenn es false
      # wird, bricht die Schleife ab. Vgl. Rails
      search_dir = (parent != search_dir) && parent
    end
    project_root = search_dir if File.exist? "#{search_dir}/service.yml"
    raise 'you are not within a service directory.' unless project_root
    @root_dir = Pathname.new(File.realpath project_root)
  end

  def config
    return @config if @config
    config_hash = YAML.load_file("#{content_root}/service.yml")
    @config = Config.new(config_hash['service_name'],
                         config_hash['repository_technique'],
                         config_hash['group_id'],
                         config_hash['artifact_id'])
  end

  def user_name
    return @user_name if @user_name
    g = Git.open(content_root)
    @user_name = g.config['user.name']
  end

  def user_email
    return @user_email if @user_email
    g = Git.open(content_root)
    @user_email = g.config['user.email']
  end
end
