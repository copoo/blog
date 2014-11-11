# Play + Scala

[play!](https://www.playframework.com/)

[Scala语言与Play框架入门教程](http://www.jdon.com/idea/play/install.html)

[play ! scala](https://www.playframework.com/documentation/2.3.x/ScalaHome)


## Typesafe Activator

[Akka Typesafe Activator入门使用](http://zerosoft.iteye.com/blog/2117364)


## 编程

### Action

大部分的请求是由Action处理的。

#### Controllers

Controllers are action generators

### 路由

conf/routes

    # GET, POST, PUT, DELETE, HEAD
    # 静态路由
    GET   /clients/all          controllers.Clients.list()
    
    GET   /clients/:id          controllers.Clients.show(id: Long)