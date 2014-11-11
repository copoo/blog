# hbase 安装

    接 hadoop-install.md

## 安装

下载

    wget ...

安装

    tar -xzvf hbase-0.94.2-cdh4.2.1.tar.gz
    rm -rf hbase-0.94*/docs
    mv hbase-0.94.2-cdh4.2.1 $HOME/apps/
    ln -T -sf $HOME/apps/hbase-0.94.2-cdh4.2.1 $HOME/local/hbase

编辑环境

    vim ~/.bash_profile

        export HBASE_HOME=$HOME/local/hbase
        export HBASE_PREFIX=$HBASE_HOME
        export HBASE_BIN=$HBASE_HOME/bin
        export HBASE_CONF_DIR=$HBASE_HOME/conf
        export PATH=$HBASE_BIN:$PATH

编辑配置

    vim $HBASE_HOME/conf/hbase-env.sh
    
        # 修改如下配置
        shopt -s expand_aliases
        . $HOME/.bash_profile
        export JAVA_HOME=$HOME/local/jdk
        export HBASE_HEAPSIZE=2000
        export HBASE_OPTS="$HBASE_OPTS -XX:+UseConcMarkSweepGC -XX:+CMSIncrementalMode"
        export HBASE_SSH_OPTS="-p 22 -o ConnectTimeout=1 -o SendEnv=HBASE_CONF_DIR"
        export HBASE_PID_DIR=$HBASE_HOME/pids
        export HBASE_MANAGES_ZK=false

编辑配置

    cp src/main/resources/hbase-default.xml conf/
    vim conf/hbase-site.xml

        <?xml version="1.0"?>
        <?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
        <configuration>
        
            <property>
                <name>hbase.rootdir</name>
                <value>hdfs://mycluster/hbase</value>
            </property>
        
            <property>
                <name>hbase.master.port</name>
                <value>60000</value>
            </property>
            
            <property>
                <name>zookeeper.session.timeout</name>
                <value>180000</value>
            </property>
        
            <property>
                <name>zookeeper.znode.parent</name>
                <value>/hbase</value>
            </property>
        
            <property>
                <name>hbase.zookeeper.quorum</name>
                <value>hadoop1,hadoop2,hadoop3,hadoop4,hadoop5</value>
            </property>
        
            <property>
                <name>hbase.zookeeper.property.clientPort</name>
                <value>28188</value>
            </property>
        
            <property>
                <name>hbase.cluster.distributed</name>
                <value>true</value>
            </property>
        
            <property>
                <name>hbase.tmp.dir</name>
                <value>${user.home}/temp/hbase</value>
            </property>
        
            <property>
                <name>hbase.master.info.port</name>
                <value>28610</value>
            </property>
        
            <property>
                <name>hbase.regionserver.port</name>
                <value>28620</value>
            </property>
        
            <property>
                <name>hbase.regionserver.info.port</name>
                <value>28630</value>
            </property>
        
            <property>
                <name>hbase.regionserver.info.port.auto</name>
                <value>false</value>
            </property>
            
            <property>
                <name>hbase.rest.port</name>
                <value>28080</value>
            </property>
        
            <property>
                <name>hbase.rest.readonly</name>
                <value>true</value>
            </property>
        
            <property>
                <name>hbase.client.pause</name>
                <value>20</value>
            </property>
        
            <property>
                <name>hbase.client.retries.number</name>
                <value>10</value>
            </property>
        
            <property>
                <name>hbase.client.scanner.caching</name>
                <value>100</value>
            </property>
        
            <property>
                <name>hbase.client.keyvalue.maxsize</name>
                <value>10485760</value>
            </property>
        
            <property>
                <name>hbase.regionserver.handler.count</name>
                <value>20</value>
            </property>
        
            <property>
                <name>hbase.regionserver.flushlogentries</name>
                <value>1</value>
            </property>
        
            <property>
                <name>hbase.regionserver.optionallogflushinterval</name>
                <value>1000</value>
            </property>
        
            <property>
                <name>hbase.regionserver.regionSplitLimit</name>
                <value>2147483647</value>
            </property>
        
            <property>
                <name>hbase.regionserver.global.memstore.upperLimit</name>
                <value>0.35</value>
            </property>
        
            <property>
                <name>hbase.regionserver.global.memstore.lowerLimit</name>
                <value>0.35</value>
            </property>
        
            <property>
                <name>hbase.hregion.memstore.flush.size</name>
                <value>67108864</value>
            </property>
        
            <property>
                <name>hbase.hregion.preclose.flush.size</name>
                <value>5242880</value>
            </property>
        
            <property>
                <name>hbase.hregion.max.filesize</name>
                <value>2684354560</value>
            </property>
        
            <property>
                <name>hbase.hstore.compactionThreshold</name>
                <value>3</value>
            </property>
        
            <property>
                <name>hbase.hstore.blockingStoreFiles</name>
                <value>7</value>
            </property>
        
            <property>
                <name>hbase.hregion.majorcompaction</name>
                <value>86400000</value>
            </property>
        
            <property>
                <name>hfile.block.cache.size</name>
                <value>0.4</value>
            </property>
        
            <property>
                <name>hbase.defaults.for.version.skip</name>
                <value>true</value>
            </property>

        </configuration>
    
    创建对应的目录
    
        hdfs dfs -mkdir /hbase
        在所有机器上
        mkdir -p $HOME/temp/hbase

    vim conf/regionservers

        hadoop1
        hadoop2
        hadoop3
        hadoop4
        hadoop5

    配置同步到所有机器

启动

    start-hbase.sh
