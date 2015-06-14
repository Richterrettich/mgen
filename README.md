# spring-gen

spring-gen is a rails-like generator for spring microservices.

## Installation
Open a terminal and type 
```bash
gem install spring-gen
```



## Usage

First, create a new microservice:

```bash
spring-gen service com.mycompany.MyService
#output
      create  MyService/config
      create  MyService/config/checkstyle/checkstyle.xml
      create  MyService/config/codestyle/Codestyle.xml
      create  MyService/config/copyright/gnu.xml
      create  MyService/config/copyright/profiles_settings.xml
      create  MyService/src/main/java/com/mycompany/main/App.java
      create  MyService/src/main/java/com/mycompany/config/AppConfig.java
      create  MyService/.gitignore
      create  MyService/src/main/resources/application.yml
      create  MyService/src/main/resources/bootstrap.yml
      create  MyService/build.gradle
      create  MyService/service.yml
```
This will create a jpa based microservice. The service command expects an argument in the form `groupId.artifactId`.
So the argument `com.mycompany.MyService` will get interpreted as groupId: com.mycompany and artifactId: MyService.

You can specify a different spring-data  backend with the `r` option:

```bash
spring-gen service com.mycompany.MyService -r mongodb
#output
      create  MyService/config
      create  MyService/config/checkstyle/checkstyle.xml
      create  MyService/config/codestyle/Codestyle.xml
      create  MyService/config/copyright/gnu.xml
      create  MyService/config/copyright/profiles_settings.xml
      create  MyService/src/main/java/com/mycompany/main/App.java
      create  MyService/src/main/java/com/mycompany/config/AppConfig.java
      create  MyService/.gitignore
      create  MyService/src/main/resources/application.yml
      create  MyService/src/main/resources/bootstrap.yml
      create  MyService/build.gradle
      create  MyService/service.yml
```

with mongodb as a backend, different classes will be generated. spring-gen currently supports
jpa, mongodb and neo4j.

After creating the project layout, enter the project-root and generate some resources:

```bash
cd MyService
spring-gen resource User firstname:String lastname:String
#output
      create  src/test/resources/sampledata/userSampleData.xml
      create  src/main/java/com/mycompany/model/BaseEntity.java
      create  src/main/java/com/mycompany/model/User.java
      create  src/main/java/com/mycompany/repository/UserRepository.java
      create  src/test/java/com/mycompany/integration/user/UserIntegrationTestConfig.java
      create  src/test/java/com/mycompany/integration/user/UserIntegrationTest.java
      create  src/test/java/util/TestUtil.java
```
This will generate a new user-model (containing string attributes for firstname and lastname)
as well as a repository that matches your spring-data choice. spring-gen will assume that you use
spring-data-rest. If you don't want to use spring-data-rest you can set the --full option,
which will generate additional classes like REST-controllers:

```bash
spring-gen resource User firstname:String lastname:String --full
# output
      create  src/test/resources/sampledata/userSampleData.xml
      create  src/main/java/com/mycompany/model/BaseEntity.java
      create  src/main/java/com/mycompany/model/User.java
      create  src/main/java/com/mycompany/repository/UserRepository.java
      create  src/test/java/com/mycompany/integration/user/UserIntegrationTestConfig.java
      create  src/test/java/com/mycompany/integration/user/UserIntegrationTest.java
      create  src/test/java/util/TestUtil.java
      create  src/test/java/com/mycompany/unit/user/controller/UserControllerUnitTestConfig.java
      create  src/test/java/com/mycompany/unit/user/controller/UserControllerUnitTest.java
      create  src/test/java/com/mycompany/unit/user/assembler/UserAssemblerUnitTestConfig.java
      create  src/test/java/com/mycompany/unit/user/assembler/UserAssemblerUnitTest.java
      create  src/main/java/com/mycompany/controller/BaseController.java
      create  src/main/java/com/mycompany/controller/UserController.java
      create  src/main/java/com/mycompany/assembler/BaseAssembler.java
      create  src/main/java/com/mycompany/assembler/UserAssembler.java
      create  src/main/java/com/mycompany/resource/UserResource.java
      create  src/main/java/com/mycompany/exception/NotCreatedException.java
```




## Issues

Neo4j is not really working right now. This will get resolved after SDN4 hits the spot.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/Richterrettich/spring-gen/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Copyright
Copyright (c) 2015 Rene Richter.
spring-gen is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA