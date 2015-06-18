module MongodbConfiguration
  REPOSITORY_IMPORT = "mongodb.repository.MongoRepository"
  REPOSITORY_TYPE = "MongoRepository<#{@model_name},String>"
  ANNOTATION_IMPORT = 'import org.springframework.data.mongodb.core.mapping.Document;'
  ENTITY_ANNOTATION = "@Document"
end