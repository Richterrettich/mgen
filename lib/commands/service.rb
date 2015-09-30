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
    copy_file 'templates/project/licence.erb',"#{@name}/.spring-gen/licence.erb"
    template 'templates/project/service.yml.erb',"#{@name}/.spring-gen/service.yml"
    directory 'templates/config',"#{@name}/config"
    copy_file 'templates/.gitignore',"#{@name}/.gitignore"
  end

  def init_git
    g = Git.init @name
    @user_name = g.config['user.name']
    @user_email = g.config['user.email']
  end

  def add_sources
    Dir.chdir(@name) {@licence = licence}
    template 'templates/src/main/java/main/App.java.erb',"#{@name}/src/main/java/#{@group_id.gsub(".","/")}/main/App.java"
    template 'templates/src/main/java/config/AppConfig.java.erb',"#{@name}/src/main/java/#{@group_id.gsub(".","/")}/config/AppConfig.java"
    template 'templates/src/main/resources/application.yml.erb',"#{@name}/src/main/resources/application.yml"
    template 'templates/src/main/resources/bootstrap.yml.erb',"#{@name}/src/main/resources/bootstrap.yml"
    template "templates/gradle/#{@repository_technique}_build.gradle.erb","#{@name}/build.gradle"

  end

end
