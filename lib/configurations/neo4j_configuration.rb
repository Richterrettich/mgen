module Neo4jConfiguration
  #TODO complete...
  REPOSITORY_IMPORT = "neo4j.repository.GraphRepository"
  REPOSITORY_TYPE = "GraphRepository<#{@model_name}>"
  ENTITY_ANNOTATION = "@NodeEntity"
end