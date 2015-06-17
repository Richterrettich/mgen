require 'thor/group'
require 'thor'
require 'git'
require 'erb'


class Service < Thor::Group
  include Thor::Actions
  include Util

  argument :name, :type => :string, :desc => 'Microservice name'

  class_option :repository_technique,
               :type => :string,
               :desc => 'repository technique',
               :aliases => 'r',
               :required => false

  def self.source_root
    File.expand_path('../',__dir__)
  end

  def prepare_artifact
    parts = @name.split(".")
    @name = @artifact_id = parts.pop
    @group_id = parts.length > 0 ?  parts.join('.') : @name
    @package = @group_id.split(".").each {|part| part.gsub!(/\W/,"")}.join(".")
  end


  def prepare_project
    @repository_technique = options['repository_technique'] || 'jpa'
    copy_file 'templates/licence.erb',"#{@name}/.spring-gen/licence.erb"
    template 'templates/service.yml.erb',"#{@name}/.spring-gen/service.yml"
    directory 'templates/layout/config',"#{@name}/config"
    copy_file 'templates/layout/.gitignore',"#{@name}/.gitignore"
  end

  def init_git
    g = Git.init @name
    @user_name = g.config['user.name']
    @user_email = g.config['user.email']
  end

  def add_sources
    Dir.chdir(@name) {@licence = licence}
    template 'templates/layout/src/java/main/App.java.erb',"#{@name}/src/main/java/#{@group_id.gsub(".","/")}/main/App.java"
    template 'templates/layout/src/java/config/AppConfig.java.erb',"#{@name}/src/main/java/#{@group_id.gsub(".","/")}/config/AppConfig.java"
    template 'templates/layout/src/resources/application.yml.erb',"#{@name}/src/main/resources/application.yml"
    template 'templates/layout/src/resources/bootstrap.yml.erb',"#{@name}/src/main/resources/bootstrap.yml"
    template 'templates/layout/build.gradle.erb',"#{@name}/build.gradle"

  end

end