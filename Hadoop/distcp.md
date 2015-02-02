# distcp

    distcp是个MapReduce任务，但只有map没有reducer。

    distcp [OPTIONS] <srcurl>* <desturl>
    
    OPTIONS:
    -p[rbugp]              Preserve status
                           r: replication number
                           b: block size
                           u: user
                           g: group
                           p: permission
                           -p alone is equivalent to -prbugp
    -i                     Ignore failures
    -log <logdir>          Write logs to <logdir>
    -m <num_maps>          Maximum number of simultaneous copies
    -overwrite             Overwrite destination
    -update                Overwrite if src size different from dst size
    -skipcrccheck          Do not use CRC check to determine if src is 
                           different from dest. Relevant only if -update
                           is specified
    -f <urilist_uri>       Use list at <urilist_uri> as src list
    -filelimit <n>         Limit the total number of files to be <= n
    -sizelimit <n>         Limit the total size to be <= n bytes
    -delete                Delete the files existing in the dst but not in src
    -mapredSslConf <f>     Filename of SSL configuration for mapper task


## 示例

    hadoop distcp hftp://namenode:50070/user/hadoop/input hdfs://namenode:9000/user/hadoop/input1


    hadoop distcp webhdfs://namenode:50070/user/hadoop/input webhdfs://namenode:50070/user/hadoop/input1




## HA 下使用

    <property>
    <name>dfs.nameservices</name>
    <value>clusterA,clusterB</value>
    <final>true</final>
    </property>
    <property>
    <name>dfs.nameservice.id</name>
    <value>clusterA</value>
    <description>
    The ID of this nameservice. If the nameservice ID is not
    configured or more than one nameservice is configured for
    dfs.nameservices it is determined automatically by
    matching the local node's address with the configured address.
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.ha.namenodes.clusterA</name>
    <value>clusterAnn1,clusterAnn2</value>
    <description>
    The prefix for a given nameservice, contains a comma-separated
    list of namenodes for a given nameservice (eg EXAMPLENAMESERVICE).
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.namenode.rpc-address.clusterA.clusterAnn1</name>
    <value>clusterAnn1:8000</value>
    <description>
    Set the full address and IPC port of the NameNode process
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.namenode.rpc-address.clusterA.clusterAnn2</name>
    <value>clusterAnn1:8000</value>
    <description>
    Set the full address and IPC port of the NameNode process
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.ha.namenodes.clusterB</name>
    <value>clusterBnn1,clusterBnn2</value>
    <description>
    The prefix for a given nameservice, contains a comma-separated
    list of namenodes for a given nameservice (eg EXAMPLENAMESERVICE).
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.namenode.rpc-address.clusterB.clusterBnn1</name>
    <value>clusterBnn1:8000</value>
    <description>
    Set the full address and IPC port of the NameNode process
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.namenode.rpc-address.clusterB.clusterBnn2</name>
    <value>clusterBnn2:8000</value>
    <description>
    Set the full address and IPC port of the NameNode process
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.client.failover.proxy.provider.clusterA</name>
    <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
    <description>
    Configure the name of the Java class which the DFS Client will 
    use to determine which NameNode is the current Active, 
    and therefore which NameNode is currently serving client requests.
    </description>
    <final>true</final>
    </property>
    <property>
    <name>dfs.client.failover.proxy.provider.clusterB</name>
    <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
    <description>
    Configure the name of the Java class which the DFS Client will 
    use to determine which NameNode is the current Active, 
    and therefore which NameNode is currently serving client requests.
    </description>
    <final>true</final>
    </property>