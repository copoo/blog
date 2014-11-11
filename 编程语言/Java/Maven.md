# Maven

    当前版本 3.*
    mvn --version

*   <http://maven.apache.org>

## 安装配置

下载解压型安装。[download](http://maven.apache.org/download.cgi#Installation)

M2_HOME

m2eclipse

## 构建阶段

1.  validate 验证
2.  compile 编译
3.  test 测试
4.  package 打包
5.  integration-test 集成测试
6.  verify 包验证
7.  install 安装，安装包到本地仓库（local repository）
8.  deploy 发布，在集成或者发布环境之后，拷贝最终的包到远程仓库（remote repository）

额外的

1.  clean: 清理
2.  site: 生成站点文档

## 使用

<http://maven.apache.org/guides/getting-started/maven-in-five-minutes.html>

*   创建项目

        mvn archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -    DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false

*   创建项目

        mvn package

## [POM](http://maven.apache.org/pom.html)

