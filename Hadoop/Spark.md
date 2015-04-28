# Spark

    Spark 1.1.0 uses Scala 2.10

本文包括：原理，安装，编程

## 原理

### 物理

![](https://spark.apache.org/docs/latest/img/cluster-overview.png)

*   driver : 运行main函数的进程。

*   executors ： 实际执行任务的进程。任务在它的线程中执行。它包括内存缓存（存储内存的RDD）和执行器

在yarn下，以deploy mode = cluster方式运行时，获取资源和启动的简单示意如下：

<iframe id="embed_dom" name="embed_dom" frameborder="0" style="border:1px solid #000;display:block;width:500px; height:400px;" src="http://www.processon.com/embed/543e1fcb0cf2c48c6df3568e"></iframe>


### 计算

核心思想是对RDD的DGA操作。

传递函数给spark，有2个方法：

1.  匿名函数
2.  全局单例对象的静态方法

#### 数据：RDD

可以考虑成一个数据集合。它存储在内存或磁盘中，存储在这台或那台机器中。你可以用RDD预定的操作处理这些数据，不用考虑它具体在哪台机器上，以什么形式存在。

创建RDD的方式只有2种:

1.  parallelizing 
2.  referencing a dataset in an external storage system

#### 操作RDD

1.  transformations: which create a new dataset from an existing one

    All transformations in Spark are lazy. The transformations are only computed when an action requires a result to be returned to the driver program

    *   map(func)
    *   mapWith()
    *   mapValues(func):key不变，只对value进行f操作。
    *   mapPartitions(func) : 类似map，在每个Partitions上map
    *   mapPartitionsWithIndex(func) : 类上，带了Partitions的序号值       
    *   flatMap(func) ： 类似scala的flatMap
    *   flatMapValues
    *   filter(func)
    *   filterWith[A:ClassTag](constructA:Int => A)(p: (T, A) => Boolean )
: RDD[T]：第一个函数在partition中仅执行一次
    *   sample(withReplacement, fraction, seed)：随机数据
    *   keys:返回key数据集合 map(._1)
    *   values:返回value数据集合 map(._2)
    *   union(otherDataset)：集合 并 操作，也可以写作：++
    *   intersection(otherDataset)：集合 交 操作
    *   distinct([numTasks]))：将元素变成(x,null)再reduceByKey((x,y)=>x), 所以是按整个元素进行distinct，并不是按key
    *   groupByKey([numTasks])：(K, V) => (K, Iterable<V>)
    *   reduce (f: (T, T) => T): T
    *   reduceByKey(func, [numTasks]) : ？
    *   aggregateByKey(zeroValue) ： ？
    *   sortByKey([ascending], [numTasks]):该方法在OrderedRDDFunctions中，实现了按key进行排序。采用RangePartitioner而不是HashPartitioner。(注意：数据倾斜，OOM)
    *   join(otherDataset, [numTasks])：(K, V) join (K, W) => (K, (V, W))，只会保留两个rdd共同key对应的记录
    *   leftOuterJoin
    *   rightOuterJoin
    *   cogroup(otherDataset, [numTasks]),groupWith : (K, V) cogroup (K, W) => (K, Iterable<V>, Iterable<W>) 
    *   cartesian(otherDataset) ： 两个集合的 笛卡尔 集，T + U => all of (T, U)
    *   pipe(command, [envVars]) : 通过标准输入输出运行命令行
    *   coalesce(numPartitions) : (联合)减少分区Partition数，做了大的过滤后，要用
    *   repartition(numPartitions) : Reshuffle the data randomly，主要为了balance it
    *   subtract(rdd):去掉rdd1中与rdd2相同的值
    *   zip:将rdd1和rdd2的元素依次组成(x,y)
    *   zipPartitions:
    
2.  actions: which return a value to the driver program

    如非特殊说明，都是先拿回数据集到driver，再计算的
    
    action主要调用SparkContext.runJob方法。

        def runJob[T, U: ClassTag](rdd: RDD[T], func: (TaskContext, Iterator[T]) => U, partitions: Seq[Int], allowLocal: Boolean, resultHandler: (Int, U) => Unit)

    *   reduce(func) ： 将各元素从左到右按f进行合并，仍然是分布式执行的
    *   reducePartition(func) ： 在各worker上对其分配的Partition的数据进行计算
    *   reduceByKeyLocally(func)：将RDD[K,V]转化成drvier上的Map[K,V]。先在各分区上进行map合并(各分区就一个map)，然后将各分区的map传到driver进行map的两两合并得到最终结果。
    *   collect(),toArray() ： 纯粹的返回数据到driver
    *   collect [U: ClassTag ](f: PartialFunction [T, U]): RDD [U] ?
    *   collectAsMap：将RDD转成Map。先调用collect()将kvparis汇总到driver上，然后将kvpairs放到Map中。遇到相同key时后来的value会把之前的value给覆盖，如果需要将value进行合并，则用reduceByKeyLocally。
    *   fold
    *   aggregate
    *   lookup：通过key获得其所有的value。
    *   count()：各task计算各自分区的记录数，结果后会放到results中，然后调用results.sum求得总和
    *   countApprox：和count相似，但有个timeout，即在规定时间内返回结果，结果并不一定是总数。
    *   countByKey() ： 返回 (K, Int)
    *   first()
    *   take(n) : 拿回前n条记录，非分布，driver端执行
    *   takeSample ： 随机拿
    *   takeOrdered(n, [ordering]) ：
    *   keyBy(f)：变成(f(x),x)对，即map(x => (f(x), x))
    *   saveAsTextFile(path) ： 写文件，hadoop fs支持的都可以
    *   saveAsSequenceFile(path)
    *   saveAsObjectFile(path)
    *   foreach(func) ： 主要是结果集的处理，例如存储之类的
    *   foreachPartition(func)：func操作的是整个分区，即在用户的f中自己调用Iterator遍历方法进行相关操作

补充， runJob，比较重要的入口函数

    def runJob[T, U: ClassTag](
        rdd: RDD[T],
        func: (TaskContext, Iterator[T]) => U,
        partitions: Seq[Int],
        allowLocal: Boolean,
        resultHandler: (Int, U) => Unit) {
      if (dagScheduler == null) {
        throw new SparkException("SparkContext has been shutdown")
      }
      val callSite = getCallSite
      val cleanedFunc = clean(func)
      logInfo("Starting job: " + callSite)
      val start = System.nanoTime
      dagScheduler.runJob(rdd, cleanedFunc, partitions, callSite, allowLocal,
        resultHandler, localProperties.get)
      logInfo("Job finished: " + callSite + ", took " + (System.nanoTime - start) / 1e9 + " s")
      rdd.doCheckpoint()
    }

3.  持久化和缓存 

    persist() or cache() 

    对一个重要的，或者多次重用的rdd，最好persist。特别是对后面的action有好处。

    *   MEMORY_ONLY ： 默认等级，内存不足，会导致一些分区不能被存储，后续使用动态计算
    *   MEMORY\_AND_DISK： 内存不足用磁盘
    *   MEMORY\_ONLY_SER ： 序列换存储，内存占用少
    *   MEMORY\_AND_DISK_SER
    *   DISK_ONLY
    *   MEMORY\_ONLY_2 ： 2个副本
    *   OFF_HEAP ： 外部介质      
    
4.  移除数据

    缓存使用LRU自动移除，或者RDD.unpersist()主动移除。

5.  变量共享

    These variables are copied to each machine, and no updates

    1.  Broadcast

            val broadcastVar = sc.broadcast(Array(1, 2, 3))

    2.  Accumulators ： 存储器？ 值可以变，但只能原子"增加"，主要用于实现counter

            val accum = sc.accumulator(0, "My Accumulator")
            sc.parallelize(Array(1, 2, 3, 4)).foreach(x => accum += x)


6.  checkpoint

    需要先设置hdfs存储目录：spark.setCheckpointDir(/path/...)

    调用 RDD.checkpoint() mark，在执行action时才会真正的CP到文件系统。SparkContext.checkpointFile用于读取文件。因为sc.checkpointFile(path)是private[spark]的，所以该类要写在自己工程里新建的package org.apache.spark中。

    1.  需要在Job被执行前被mark,
    2.  最好选择persist这个RDD, 否则在存CP文件时需要重新computeRDD内容
    3.  当RDD被CP后, 所有dependencies都会被清除
    4.  checkpoint会将结果写到hdfs上，当driver 关闭后数据不会被清除


#### 操作的本质

[spark RDD keyvalue操作](ttp://dataknocker.github.io/2014/07/22/spark%20rdd%20keyvalue%E6%93%8D%E4%BD%9C/)

*   涉及shuffle的操作

    *   partitionBy
    *   combineByKey
    *   reduceByKey
    *   groupByKey
    *   foldByKey
    *   cogroup,groupWith
    *   join
    *   leftOuterJoin
    *   rightOuterJoin
    *   subtractByKey

#### 其它

1   传递函数到集群
    
    1.  匿名函数
    2.  全局单例对象的静态方法

2.  提交spark程序到yarn
        
    <https://spark.apache.org/docs/latest/submitting-applications.html>

        nohup \
        ../bin/spark-submit \
          --master yarn \
          --deploy-mode cluster \
          --num-executors 10 \
          --executor-cores 1 \
          --driver-memory 512m \
          --executor-memory 1g \
          --jars ./xmemcached-2.0.0.jar \
          --class com.ucweb.RealTimeStatics \
          ./wa-realtime_2.10-1.0.jar > ./log.log 2>&1 &

    参数说明：

    *   --num-executors：
    *   spark.eventLog.enabled=true

3.  Deploy mode
    
    *   In "client" mode, the submitter launches the driver outside of the cluster
    *   In "cluster" mode, the framework launches the driver inside of the cluster

## 基本环境

*   jdk 1.6+
*   scala

    <http://www.scala-lang.org/download/>
    
        wget http://downloads.typesafe.com/scala/2.11.2/scala-2.11.2.tgz
    
    解压可用

    *   环境

            export SCALA_HOME=$HOME/local/scala
            pathmunge $SPARK_SBIN after

*   scala ide

    <http://scala-ide.org/download/sdk.html>

## 安装

    wget http://d3kbcqa49mib13.cloudfront.net/spark-1.0.2.tgz
    
<https://spark.apache.org/docs/latest/building-with-maven.html>

    export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=512m"
    mvn -Pyarn-alpha -Dhadoop.version=2.0.0-cdh4.2.1 -DskipTests clean package

    ./make-distribution.sh --tgz --skip-java-test -Pyarn-alpha -Dhadoop.version=2.0.0-cdh4.2.1

    ./make-distribution.sh --name 2.4.1 --with-tachyon --tgz -Pspark-ganglia-lgpl -Pyarn -Pkinesis-asl -Phive-0.13.1 -Phive-thriftserver -Phadoop-2.4 -Djava.version=1.6 -Dhadoop.version=2.4.1 -DskipTests

打包后的文件在每个子项目的 target 目录中。编译后就可以使用了。其中在 assembly 项目，它把spark需要的class集合成一个大的jar包，方便转移和使用。

## 配置

<https://spark.apache.org/docs/latest/configuration.html>

其中，conf/spark-env.sh

    export SPARK_HOME=$HOME/local/spark
    HADOOP_CONF_DIR=/etc/hadoop/conf
    SPARK_LOCAL_IP=$(hostname -i)
    SPARK_PUBLIC_DNS=$(hostname -s)

conf/spark-defaults.conf

    spark.master            spark://hadoop1:7077
    spark.eventLog.enabled  true
    spark.eventLog.dir      hdfs://nameservice1/user/spark/.eventlog
    spark.serializer        org.apache.spark.serializer.KryoSerializer

slaves

    hadoop1
    hadoop2
    hadoop3
    hadoop4
    hadoop5

另外，如果你的ssh端口不是22，需要修改`bin/slaves.sh`中相关代码。

## 启动

### 以独立方式启动

    独立方式部署，需要在一台机器上配置好后，在所有机器上分发。
    
    1.  需要配置好conf中的spark-env.sh
    2.  需要配置好conf中的spark-default.conf

    sbin/start-all

### 以yarn方式启动

<http://blog.csdn.net/lsshlsw/article/details/41787537>

    #!/usr/bin/env exit 1
    #SPARK_YARN_USER_ENV="JAVA_HOME=/jdk64,FOO=bar"
    
    SUBMIT=../spark/bin/spark-submit
    
    #nohup \
    #  ./wa-realtime_2.10-1.0.jar > ./log.log 2>&1 &
        
    JOPTS="-server -XX:+UseParNewGC -XX:+UseConcMarkSweepGC \
    -XX:-CMSConcurrentMTEnabled -XX:CMSInitiatingOccupancyFraction=70 \
    -XX:+CMSParallelRemarkEnabled -XX:+DisableExplicitGC \
    -XX:+UseCMSCompactAtFullCollection \
    -Dclient.encoding.override=UTF-8 -Dfile.encoding=UTF-8 \
    -Duser.language=zh -Duser.region=CN" 
    
    # 下面这些系统变量，也可以在 spark-env.sh 中定义
    # 支持LZO    
    export SPARK_CLASSPATH=$SPARK_CLASSPATH:/usr/lib/hadoop/lib/hadoop-lzo-cdh4-0.4.15-gplextras.jar
    export SPARK_SUBMIT_LIBRARY_PATH=$SPARK_LIBRARY_PATH:/usr/lib/hadoop/lib/native
    SPARK_LIBRARY_PATH=$SPARK_LIBRARY_PATH:/usr/lib/hadoop/lib/native
    JAVA_LIBRARY_PATH=$JAVA_LIBRARY_PATH:/usr/lib/hadoop/lib/native
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/hadoop/lib/native


    # Options read in YARN client mode
    export HADOOP_CONF_DIR=/etc/hadoop/conf
    #export SPARK_EXECUTOR_INSTANCES=5
    export SPARK_EXECUTOR_CORES=1
    #export SPARK_EXECUTOR_MEMORY=1G
    #export SPARK_DRIVER_MEMORY=512M
    #export SPARK_YARN_APP_NAME=RealTimeStatics
    export SPARK_YARN_QUEUE=default
    # SPARK_YARN_DIST_FILES
    # SPARK_YARN_DIST_ARCHIVES
    
    mycluster=`hdfs getconf -confKey dfs.nameservices`
    
    hdfs dfs -rm -f -R hdfs://$mycluster/user/zhaigy/waup_spark/out*
    
    $SUBMIT --class com.ucweb.WaupUserAttrs \
      --name "WaupUserAttrs" \
      --master yarn \
      --deploy-mode client \
      --num-executors 5 \
      --executor-memory 1g \
      --driver-memory 512m \
      --verbose \
      --jars ./lib/config-0.3.1.jar \
      --conf "spark.eventLog.enabled=false" \
      --conf "spark.serializer=org.apache.spark.serializer.JavaSerializer" \
      --conf "spark.executor.extraJavaOptions= $JOPTS" \
      --conf "spark.default.parallelism=5" \
      --conf "spark.ui.port=50004" \
      ./waup_spark_2.10-1.0.jar \
      --logs=foxy_log=hdfs://$mycluster/user/zhaigy/waup_spark/in/ \
      --output=hdfs://$mycluster/user/zhaigy/waup_spark/out/ \
      --confPath=hdfs://$mycluster/user/zhaigy/waup_spark/conf/waup_conf.conf

### spark shell

    spark shell 连接到一个存在的cluster

MASTER=spark://localhost:7077 ./spark-shell

    sc是在进入spark shell 时候创建一个spark content

### 重要的参数

1.  spark.yarn.executor.memoryOverhead ： 非堆内存

    spark不允许用户通过JavaOpt指定堆内存。只能通过指定executor堆内存和非堆内存。spark用这两者的和，来向yarn申请内存资源。    

2.  spark.yarn.historyServer.address：？


### 支持LZO

正常的安装Hadoop的LZO支持，然后



启动后，你可以在浏览器中访问：http://hadoop1:8081

## 测试

以10个core运行Pi运算程序。需要明确指定MASTER，否则是local方式运行。

    MASTER=spark://hadoop1:7077 ./bin/run-example SparkPi 10

## 编程

    Scala Java Python  

*   SparkConf：环境变量设置

        val conf = new SparkConf().setAppName(appName).setMaster(master)

*   SparkContext:执行场景

        new SparkContext(conf)

简单示例

[Apache Spark学习：利用Scala语言开发Spark应用程序](http://dongxicheng.org/framework-on-yarn/spark-scala-writing-application/)

    import org.apache.spark._
    import SparkContext._
    object SparkJoin {
      def main(args: Array[String]) {
        if (args.length != 4 ){
          println("usage is org.test.WordCount <master> <rating> <movie> <output>")
          return
        }
        val sc = new SparkContext(args(0), "WordCount",
        System.getenv("SPARK_HOME"), Seq(System.getenv("SPARK_TEST_JAR")))
     
        // Read rating from HDFS file
        val textFile = sc.textFile(args(1))
     
        //extract (movieid, rating)
        val rating = textFile.map(line => {
            val fileds = line.split("::")
            (fileds(1).toInt, fileds(2).toDouble)
           })
     
        val movieScores = rating
           .groupByKey()
           .map(data => {
             val avg = data._2.sum / data._2.size
             (data._1, avg)
           })
     
         // Read movie from HDFS file
         val movies = sc.textFile(args(2))
         val movieskey = movies.map(line => {
           val fileds = line.split("::")
            (fileds(0).toInt, fileds(1))
         }).keyBy(tup => tup._1)
     
         // by join, we get <movie, averageRating, movieName>
         val result = movieScores
           .keyBy(tup => tup._1)
           .join(movieskey)
           .filter(f => f._2._1._2 > 4.0)
           .map(f => (f._1, f._2._1._2, f._2._2._2))
     
        result.saveAsTextFile(args(3))
      }
    }

## 流式计算

    sbt：
    libraryDependencies += "org.apache.spark" % "spark-streaming_2.10" % "1.1.0"

### DStream 

![](https://spark.apache.org/docs/latest/img/streaming-dstream.png)


1.  Receiver : which receives the data from a source and stores it in Spark’s memory

    A receiver is run within a Spark worker/executor as a long-running task

2.  DStream操作

    [Transformations on DStreams](https://spark.apache.org/docs/latest/streaming-programming-guide.html#transformations-on-dstreams)

    1.  Transformations on DStreams

        Transform : RDD-to-RDD

        *   map(func) : DStream => DStream
        *   flatMap(func) : 扩散型的map
        *   filter(func)
        *   repartition(numPartitions)
        *   union(otherStream)
        *   count() ： 和RDD的不同，返回一个DStream，它包含着单元素的RDDs（多个RDD，每个RDD有一个元素）， 此元素就是每个RDD的此前元素数量。
        *   reduce(func) ： RDD内的聚合操作，操作后此RDD中只有一个元素
        *   countByValue() ： k => (k, long)
        *   reduceByKey(func, [numTasks]) : 
        *   join(otherStream, [numTasks]): (K, V) join (K, W) => (K, (V, W))
        *   cogroup(otherStream, [numTasks]) ： (K, V) + (K, W) => (K, Seq[V], Seq[W])
        *   transform(func) : RDD to RDD
        *   updateStateByKey(func) : 运行更新状态（内存中累积计数？）!!!

        特别说明一下 updateStateByKey ，允许您维护任意状态而不断更新新的信息。
    
3.  窗口操作

    apply transformations over a sliding window of data

    ![](https://spark.apache.org/docs/latest/img/streaming-dstream-window.png)

    需要指定：

    1.  window length ： 窗口长度，上图是3
    2.  sliding interval ： 滑动长度， 上图是2

    窗口操作和Dstream操作类似

    *   window(windowLength, slideInterval) : 返回窗口范围内的 DStream
    *   countByWindow(windowLength, slideInterval)
    *   reduceByWindow(func, windowLength, slideInterval)
    *   reduceByKeyAndWindow(func, windowLength, slideInterval, [numTasks])
    *   reduceByKeyAndWindow(func, invFunc, windowLength, slideInterval, [numTasks])
    *   countByValueAndWindow(windowLength, slideInterval, [numTasks])


4.  输出

    输出触发实际的执行，类似action。

    *   print() : 打印10个元素 
    *   saveAsTextFiles(prefix, [suffix])
    *   saveAsHadoopFiles(prefix, [suffix])
    *   foreachRDD(func) ： 需要注意，func是在driver执行的

5.  持久和缓存

    类似 persist()，通常不需要

6.  Checkpointing

    涉及到状态的操作是会操作多个批次数据块。包括：基于窗口的操作和updateStateByKey。由于状态型操作要用到先前的数据，他们不得不长时间保持这些元数据。为了清理这些数据，steram通过保存中间数据到HDFS来支持checkping操作。
    
        ssc.checkpoint(hdfsPath)
        dstream.checkpoint(checkpointInterval)


## Spark使用Kryo序列化

conf.set("spark.serializer", "org.apache.spark.serializer.KryoSerializer")
conf.set("spark.kryo.registrator", "mypackage.MyRegistrator")

或者重载，把自己声明的，用于RDD和广播，缓存等相关的类都注册。示例代码如下：

    class MyRegistrator extends KryoRegistrator {
      override def registerClasses(kryo: Kryo) {
        kryo.register(classOf[InputLogs])
        kryo.register(classOf[Parameters])        
      }
    }
    
    object MyRegistrator extends Logging {
      def useKryo(conf: SparkConf, registor: KryoRegistrator) {
        conf.set("spark.kryo.registrator", registor.getClass.getCanonicalName)
      }
      def useKryo(conf: SparkConf) {
        log.info("use kryo serializer")
        conf.set("spark.kryo.registrator", classOf[MyRegistrator].getCanonicalName)
      }
    }

如果你不注册你的类，Kryo依然可以工作，但是它会对每个对象都存储全类名

## spark + parquet

<https://github.com/Arnonrgo/spark-parquet-example/blob/master/src/test/scala/com/rgoarchitects/example/tests/CsvToParquetSample.scala>

这个示例挺清楚：<https://github.com/adobe-research/spark-parquet-thrift-example>


需要：
  
    $CDH_BASE/lib/hive/lib/libthrift*jar


## spark sql

spark sql支持用户接口，不需要写任何代码，使用sql就可以。

1. thriftserver

    Thrift JDBC/ODBC server implemented here corresponds to the HiveServer2 in Hive 0.12.

        export HIVE_SERVER2_THRIFT_PORT=<listening-port>
        export HIVE_SERVER2_THRIFT_BIND_HOST=<listening-host>
        ./sbin/start-thriftserver.sh    --help
            --hiveconf hive.server2.thrift.port=<listening-port> \
            --hiveconf hive.server2.thrift.bind.host=<listening-host> \
    
        beeline> !connect jdbc:hive2://localhost:10000
        在非安全模式下，用户名随便，密码空格或者随便

    把hive-site.xml放到conf目录可以快速配置完成hive

2. sql cli 

    相当于快速运行 hive metastore的本地模式并提供sql查询的工具

        ./bin/spark-sql --help

3.  sql

        SET spark.sql.shuffle.partitions=10;

        SELECT page, count(*) c
        FROM logs_last_month_cached
        GROUP BY page ORDER BY c DESC LIMIT 10;
        
        CACHE TABLE logs_last_month;
        UNCACHE TABLE logs_last_month;


## 一些问题

### 大数据下，Lost executor on YARN



## 分析文章

*   <http://www.cnblogs.com/cenyuhai/p/3577204.html>
*   <http://www.cnblogs.com/cenyuhai/>
