# Scala

<http://docs.scala-lang.org/tutorials/tour/tour-of-scala.html>

[Scala 课堂!](https://twitter.github.io/scala_school/zh_cn/index.html)

[Effective Scala](http://twitter.github.io/effectivescala/index-cn.html) 

上面2个文档已经很全面，很深入了。 下面只是快速备查。


## 一些记录

1.  Scala不仅仅是更好的Java。你应该用全新的头脑来学习它
2.  以下都是函数的形式

        scala> val addOne = (x: Int) => x + 1
        scala> () => 1

        scala> { i: Int =>
          println("hello world")
          i * 2
        }
       
        scala> { _ + 2 }

        scala> def multiply(m: Int)(n: Int): Int = m * n
        scala> val timesTwo = multiply(2) _  // 这也是一个函数

        scala> (adder _).curried

        scala> { case 1 => "one" }  // 偏函数

3.  函数即对象

    具有一个参数的函数是Function1特质的一个实例。这个特征定义了apply()语法糖，让你调用一个对象时就像你在调用一个函数。

    apply语法糖有助于统一对象和函数式编程的二重性。

    可以传递类，并把它们当做函数使用，而函数本质上是类的实例。

    在类中定义的方法是方法而不是函数。

4.  [case 语句](https://twitter.github.io/scala_school/zh_cn/pattern-matching-and-functional-composition.html)

    是一个名为PartialFunction的函数的子类。
    多个case语句的集合，是共同组合在一起的多个PartialFunction。

5.  偏函数

        一个(Int) => String 的函数可以接收任意Int值，并返回一个字符串。
        一个定义为(Int) => String 的偏函数可能不能接受所有Int值为输入。
    


*   基于对象：每个值都是对象
*   函数编程：
    *   每个函数都是一个值
    *   支持高等函数：其参数，输出结果可以是其它函数

## 入门

### 一些特性

*   模板类
*   注解

    *   scala没有异常检查，必须使用注解方式处理抛出的异常

            @throws(classOf[IOException])
            def read() = {}

*   组合类型

        obj: Cloneable with Resetable

*   内部类
*   嵌套函数
*   匿名函数

        (x: Int) => x + 1
        (x: Int, y: Int) => "(" + x + ", " + y + ")"
        () => { System.getProperty("user.dir") }

*   模式匹配

### 变量

*   val：常量，只能初始化一次。鼓励使用。
*   var
*   lazy：初始化被推迟，直到第一次对它取值。

### 基本语法

*   如果一句话是一行，可以省略分号
*   操作符重载

        a 方法 b == a.方法(b)

*   apply方法
   
        Scala有一套通用规则，会把小括号转换成apply

*   import

        import scala.math._
        improt math._
        _是通配符
        前2个import语句是同义的

*   scala没有静态方法
*   不带参数的方法通常不使用圆括号
*   当方法参数只有一个的时候，可以不写括号和点

        for (i <- 0 to 2)
        to是0的一个方法

*   Scala中不能用i++或++i
*   if else 语法有值，就是跟在之后的表达式的值
*   {}语句块也有值，是它最后的表达式的值
*   赋值动作没有值
*   没有switch语句，对应的是模式匹配机制
*   while
*   foreach: args.foreach(arg => println(arg))
    
        args.foreach((arg: String) => println(arg))
        args.foreach(println)

*   for

        for (arg <- args)
            println(arg)

    *   可以多语句
    *   如果循环体以yield开始，构成推导式。

*   没有break和continue。
    *   用变量控制
    *   使用嵌套函数
    *   使用Breaks对象的break方法：这种方法是通过一次机制实现的，消耗较大。
*   函数，函数不属于哪个类。
*   递归函数必须有返回值类型。

*   数组

        new Array[String](10) 定长
        ArrayBuffer 变长 
        ArrayBuffer.toArray

*   Map

        Map("A" -> 0, "B" -> 2) 不可变
        new scala.collection.mutable.HashMap[String, Int] 可变
        
    *   Map是对偶（Pair）的集合 
        
            ->  此操作符用来创建对偶
            ("A", 0) 这样也可以

*   元组 (a,b,c) 元组从1开始，可以用方法 _1 _2访问 
*   类 class
    *   辅助构造器
    *   主构造器
*   对象 object
    *   单例对象
    *   伴生对象：类和同名伴生对象可以互相访问私有特性


## eclipse

[使用Scala IDE 阅读spark源码](http://cn.soulmachine.me/blog/20130611/)

前述已经安装scala和eclipse环境。继续安装

## sbt

官网正道 [安装](http://www.scala-sbt.org/index.html)

使用

编辑 build.sbt文件，内容类似如下：
    
    name := "hello"

    version := "1.0"

    scalaVersion := "2.10.3"

在cmd中，在项目目录，可以运行如下命令：

1. sbt
2. compile
3. run <argument>*
4. clean
5. ~ compile 继续编译
6. test
7. console  启动交互环境
8. package  打包，创建jar文件
9. help
10. reload 在build文件改变后运行
