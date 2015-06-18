require 'thor/group'
require 'util'
#require_relative '../../lib/generators/generator'
require 'active_support/core_ext/string/inflections'



Attribute = Struct.new(:name,:data_type)
class Resource < Thor::Group
  include Util
  include Thor::Actions

  argument :model_name, :type => :string, :desc => 'Name of the model'
  argument :attributes,
           :type => :hash,
           :desc => 'attributes',
           :default => {}

  class_option :full,
               :type => :boolean,
               :desc => 'invoke all templates',
               :aliases => 'f',
               :default => false

  def prepare_attributes
    @attributes = @attributes.map{|k,v| Attribute.new k,v}
  end

  def self.source_root
    File.expand_path('../',__dir__)
  end



  def create_model
    @licence = licence
    @user_name = user_name
    @package = config.group_id.split('.').each {|part| part.gsub!(/\W/,'')}.join('.')
    fs_path = @package.gsub('.','/')

    @full = options['full']
    template("templates/src/main/java/model/#{config.repository_technique}/#{config.repository_technique.capitalize}BaseEntity.java.erb",
               "#{content_root}/src/main/java/#{fs_path}/model/BaseEntity.java") unless File.exist?("#{content_root}/src/main/java/#{fs_path}/model/BaseEntity.java")
    template(
          "templates/src/main/java/model/#{config.repository_technique}/#{config.repository_technique.capitalize}Model.java.erb",
          "#{content_root}/src/main/java/#{fs_path}/model/#{@model_name}.java")

    template("templates/src/main/java/repository/#{config.repository_technique}/#{config.repository_technique.capitalize}Repository.java.erb",
             "#{content_root}/src/main/java/#{fs_path}/repository/#{@model_name}Repository.java")

    template(
          "templates/src/test/java/integration/#{config.repository_technique}/IntegrationTestConfig.java.erb",
          "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}IntegrationTestConfig.java")
      template(
          "templates/src/test/java/integration/#{config.repository_technique}/IntegrationTest.java.erb",
          "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}IntegrationTest.java")
      template(
          'templates/src/test/java/TestUtil.java.erb',
          "#{content_root}/src/test/java/util/TestUtil.java") unless File.exist?("#{content_root}/src/test/java/util/TestUtil.java")

      case config.repository_technique
        when 'jpa'
          @id_type = "Long"
          #TODO unify sample data. This check should not need to exist.
          template "templates/src/test/java/integration/#{config.repository_technique}/sampleData.xml.erb",
                   "#{content_root}/src/test/resources/sampledata/#{@model_name.downcase}SampleData.xml"
        when "mongodb"
          @id_type = "String"
          template "templates/src/test/java/integration/#{config.repository_technique}/SampleData.java.erb",
                   "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}SampleData.java"
        when "neo4j"
          @id_type = "Long"
          template "templates/src/test/java/integration/#{config.repository_technique}/SampleData.java.erb",
                   "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}SampleData.java"
        else
          raise ("not a suitable repository-technique.")
      end

      if @full

        template(
            'templates/src/test/java/unit/controller/ControllerUnitTestConfig.java.erb',
            "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/controller/#{@model_name}ControllerUnitTestConfig.java")

        template(
            'templates/src/test/java/unit/controller/ControllerUnitTest.java.erb',
            "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/controller/#{@model_name}ControllerUnitTest.java")

        template(
            'templates/src/test/java/unit/assembler/AssemblerUnitTestConfig.java.erb',
            "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/assembler/#{@model_name}AssemblerUnitTestConfig.java")

        template(
            'templates/src/test/java/unit/assembler/AssemblerUnitTest.java.erb',
            "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/assembler/#{@model_name}AssemblerUnitTest.java")


        template 'templates/src/main/java/controller/BaseController.java.erb',
                 "#{content_root}/src/main/java/#{fs_path}/controller/BaseController.java"  unless File.exist?("#{content_root}/src/main/java/#{fs_path}/controller/BaseController.java")

        template(
            'templates/src/main/java/controller/Controller.java.erb',
            "#{content_root}/src/main/java/#{fs_path}/controller/#{@model_name}Controller.java")

        template 'templates/src/main/java/assembler/BaseAssembler.java.erb',
                 "#{content_root}/src/main/java/#{fs_path}/assembler/BaseAssembler.java" unless File.exist?("#{content_root}/src/main/java/#{fs_path}/assembler/BaseAssembler.java")
        template(
            'templates/src/main/java/assembler/Assembler.java.erb',
            "#{content_root}/src/main/java/#{fs_path}/assembler/#{@model_name}Assembler.java")

        template(
            'templates/src/main/java/resource/Resource.java.erb',
            "#{content_root}/src/main/java/#{fs_path}/resource/#{@model_name}Resource.java")
    end
  end

  no_tasks do
    def augment_test_id(id)
      case @id_type
        when "String" then "String.valueOf(#{id})"
        when "Long" then "Long.valueOf(#{id})"
        else id
      end
    end
  end


end