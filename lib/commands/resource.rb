require 'thor'
require 'thor/group'
require 'util'

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

  def self.source_root
    File.expand_path('../',__dir__)
  end

  def prepare_attributes
    @attributes = @attributes.map{|k,v| Attribute.new k,v}
  end

  def create_model
    @user_name = user_name
    @user_email = user_email
    @package = config.group_id.split(".").each {|part| part.gsub!(/\W/,"")}.join(".")
    fs_path = @package.gsub(".","/")
    @artifact_id = config.artifact_id
    @full = options['full']


    case config.repository_technique
      when "jpa"
        @repository_import = "jpa.repository.JpaRepository"
        @repository_type = "JpaRepository<#{@model_name},Long>"
        @entity_annotation = "@Entity"
        @annotation_import = "import javax.persistence.Entity;"
        template "templates/resource/test/integration/#{config.repository_technique}/sampleData.xml.erb",
                 "#{content_root}/src/test/resources/sampledata/#{@model_name.downcase}SampleData.xml"
      when "mongodb"
        @repository_import = "mongodb.repository.MongoRepository"
        @repository_type = "MongoRepository<#{@model_name},String>"
        @annotation_import = 'import org.springframework.data.mongodb.core.mapping.Document;'
        @entity_annotation = "@Document"
        template "templates/resource/test/integration/#{config.repository_technique}/SampleData.java.erb",
                 "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}SampleData.java"
      when "neo4j"
        @repository_import = "neo4j.repository.GraphRepository"
        @repository_type = "GraphRepository<#{@model_name}>"
        @entity_annotation = "@NodeEntity"
        template "templates/resource/test/integration/#{config.repository_technique}/SampleData.java.erb",
                 "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}SampleData.java"
      else
        raise ("not a suitable repository-technique.")
    end


    template "templates/resource/model/#{config.repository_technique.capitalize}BaseEntity.java.erb",
             "#{content_root}/src/main/java/#{fs_path}/model/BaseEntity.java"
    template(
      'templates/resource/model/Model.java.erb',
      "#{content_root}/src/main/java/#{fs_path}/model/#{@model_name}.java")

    template(
        'templates/resource/repository/Repository.java.erb',
        "#{content_root}/src/main/java/#{fs_path}/repository/#{@model_name}Repository.java")

    template(
        "templates/resource/test/integration/#{config.repository_technique}/IntegrationTestConfig.java.erb",
        "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}IntegrationTestConfig.java")

    template(
        "templates/resource/test/integration/#{config.repository_technique}/IntegrationTest.java.erb",
        "#{content_root}/src/test/java/#{fs_path}/integration/#{@model_name.downcase}/#{@model_name}IntegrationTest.java")


    template(
        'templates/resource/test/TestUtil.java.erb',
        "#{content_root}/src/test/java/util/TestUtil.java") unless File.exist?("#{content_root}/src/test/java/util/TestUtil.java")

    if @full

      template(
          'templates/resource/test/unit/controller/ControllerUnitTestConfig.java.erb',
          "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/controller/#{@model_name}ControllerUnitTestConfig.java")

      template(
          'templates/resource/test/unit/controller/ControllerUnitTest.java.erb',
          "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/controller/#{@model_name}ControllerUnitTest.java")

      template(
          'templates/resource/test/unit/assembler/AssemblerUnitTestConfig.java.erb',
          "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/assembler/#{@model_name}AssemblerUnitTestConfig.java")

      template(
          'templates/resource/test/unit/assembler/AssemblerUnitTest.java.erb',
          "#{content_root}/src/test/java/#{fs_path}/unit/#{@model_name.downcase}/assembler/#{@model_name}AssemblerUnitTest.java")


      template 'templates/resource/controller/BaseController.java.erb',
                "#{content_root}/src/main/java/#{fs_path}/controller/BaseController.java"  unless File.exist?("#{content_root}/src/main/java/#{fs_path}/controller/BaseController.java")

      template(
          'templates/resource/controller/Controller.java.erb',
          "#{content_root}/src/main/java/#{fs_path}/controller/#{@model_name}Controller.java")

      template 'templates/resource/assembler/BaseAssembler.java.erb',
                "#{content_root}/src/main/java/#{fs_path}/assembler/BaseAssembler.java" unless File.exist?("#{content_root}/src/main/java/#{fs_path}/assembler/BaseAssembler.java")
      template(
          'templates/resource/assembler/Assembler.java.erb',
          "#{content_root}/src/main/java/#{fs_path}/assembler/#{@model_name}Assembler.java")

      template(
          'templates/resource/resource/Resource.java.erb',
          "#{content_root}/src/main/java/#{fs_path}/resource/#{@model_name}Resource.java")

      template 'templates/resource/exception/NotCreatedException.java.erb',
                "#{content_root}/src/main/java/#{fs_path}/exception/NotCreatedException.java" unless File.exist? "#{content_root}/src/main/java/#{fs_path}/exception/NotCreatedException.java"

    end
  end

end