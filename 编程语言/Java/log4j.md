# Log4j

    现在已经转到apache

    当前版本 1.2.17

[log4j.properties配置详解](http://www.cnblogs.com/ITEagle/archive/2010/04/23/1718365.html)

## 配置

    ### set log levels ###
    log4j.rootLogger = WARN,stdout,D
    
    ### 输出到控制台 ###
    log4j.appender.stdout = org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.Target = System.out
    log4j.appender.stdout.layout = org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern =  %d{ABSOLUTE} %5p %c{ 1 }:%L - %m%n
    
    ### 输出到日志文件 ###
    log4j.appender.D = org.apache.log4j.DailyRollingFileAppender
    log4j.appender.D.File = logs/log.log
    log4j.appender.D.Append = true
    log4j.appender.D.Threshold = INFO
    log4j.appender.D.layout = org.apache.log4j.PatternLayout
    log4j.appender.D.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss} [ %t:%r ] - [ %p ] %m%n
    
    ### 保存异常信息到单独文件 ###
    log4j.appender.R = org.apache.log4j.DailyRollingFileAppender
    log4j.appender.R.File = /logs/error.log
    log4j.appender.R.Append = true
    log4j.appender.R.Threshold = ERROR
    log4j.appender.R.layout = org.apache.log4j.PatternLayout
    log4j.appender.R.layout.ConversionPattern = %-d{yyyy-MM-dd HH:mm:ss}  [ %l:%c:%t:%r ] - [ %p ]  %m%n
    
    #还可以单独指定输出某个包的日志级别 
    #log4j.logger.com.study.HelloLog4j=INFO