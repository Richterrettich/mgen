require 'thor/group'
require 'thor'
require 'git'


class Service < Thor::Group
  include Thor::Actions

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
  end

  def init_git
    g = Git.init @name
    @user_name = g.config['user.name']
    @user_email = g.config['user.email']
  end

  # TODO evtl. für andere entwicklugnsumgebungen erweitern.

  def create_layout

    @repository_technique = options['repository_technique'] || 'jpa'

    #TODO templates vervollständigen.
    directory 'templates/layout/intellij/config',"#{@name}/config"

    template 'templates/layout/src/java/main/App.java.erb',"#{@name}/src/main/java/#{@group_id.gsub(".","/")}/main/App.java"
    template 'templates/layout/src/java/config/AppConfig.java.erb',"#{@name}/src/main/java/#{@group_id.gsub(".","/")}/config/AppConfig.java"
    copy_file 'templates/layout/.gitignore',"#{@name}/.gitignore"
    template 'templates/layout/src/resources/application.yml.erb',"#{@name}/src/main/resources/application.yml"
    template 'templates/layout/src/resources/bootstrap.yml.erb',"#{@name}/src/main/resources/bootstrap.yml"
    template 'templates/layout/build.gradle.erb',"#{@name}/build.gradle"
    template 'templates/service.yml.erb',"#{@name}/service.yml"
  end



end