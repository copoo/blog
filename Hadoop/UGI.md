# UserGroupInformation
 
## 主要函数


## 伪装用户

    //创建远程用户，以指定的用户来运行程序 
    //把要运行的程序代码放到run方法体里 
    UserGroupInformation ugi = UserGroupInformation.createRemoteUser("hadoop"); 
    ugi.doAs(new PrivilegedAction<Void>() { 
        public Void run() { 
            try{ //以hadoop用户身份做事情
                    
            }catch(Exception e){ 
              e.printStackTrace(); 
            } 
            return null; 
        }
    }); 

## 代理用户

<http://dongxicheng.org/mapreduce-nextgen/hadoop-secure-impersonation/>

允许一个超级用户代理其他用户执行作业或者命令，但对外看来执行者仍是普通用户。也可以这样理解，用户user1  sudo 成用户oozie，执行作业流。
