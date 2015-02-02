# Python简要

	Python 版本：2.7.*

安装：
	
	yum install python27
	rm -rf /usr/bin/python
	ls -s /usr/bin/python2.6 /usr/bin/python
	python -V
		
	wget http://peak.telecommunity.com/dist/ez_setup.py 
	python ez_setup.py
	python ez_setup.py -U setuptools
	easy_install pip
	# 安装你想要的组件
	pip install thrift

[debug方式](http://www.ibm.com/developerworks/cn/linux/l-cn-pythondebugger/)

文档查看: python -c "print dir(str)"	列出全部str的方法


教程：
	
<http://woodpecker.org.cn/diveintopython/native_data_types/index.html> 深入Python

<http://www.tsnc.edu.cn/tsnc_wgrj/doc/python/basic.htm> Python基础

## 通用知识
	
*   头

		#!/usr/bin/env python
		# coding=utf-8

*   注释

		"""
		这里是注释
		"""
        # 这也是注释

*   main    

		if __name__ == '__main__':
			main()			


## 规范

**书写优美的代码**

[谷歌命名规范](http://google-styleguide.googlecode.com/svn/trunk/pyguide.html)

*   不要混用制表符和空格
*	函数名应该为小写，可以用下划线：this_is_a_function
*	在全局变量上加一个前导的下划线：_global_various
*	变量名全部小写，由下划线连接各个单词：this_is_a_various
*	常量名所有字母大写，由下划线连接各个单词：CONST_VALUE
*	异常，以“Error”作为后缀：RuntimeError
*	一个前导下划线，表示非公有:_
*	一个后缀下划线，避免关键字冲突：None_

## 变量

###	类型

*   没有显式类型声明

        bool, int, float, long

*   内建类型
    *   numerics：int, float, long, complex
    
        *   Booleans是int的子类
        *   int是由c的long实现的
        *   float是由c的double实现的
        *   int(), long(), float(), complex()可以生成指定类型的变量，可以用于类型转换。
        *   从float强制转换为int相当于math.trunc()，注意取整：向下math.floor()、向上math.ceil()
        *   1/2 is 0

    *   sequences：str, unicode, list, tuple, bytearray, buffer, xrange

        *   Unicode和str不是同一个类，虽然他们非常像。它通过前缀（'u'）声明: u'abc'
        *   Bytearray对象由内建函数bytearray()创建
        *   sequences的常用操作：（注意str是sequences）
            *   x in s， x not in s
            *   s + t
            *   s * n  # s重复拷贝多次（n），浅拷贝
            *   s[i]   # 基于0，如果是负数，从后倒数
            *   s[i:j] # 切片，从i到j，包含
            *   s[i:j:k] # 切片，k是step
            *   len(s), min(s), max(s)
            *   s.index(i)  # i在s中出现的位置
            *   s.count(i)  # i在s中出现的次数
        *   Buffer对象由内建函数buffer()创建，不支持：+ *
        *   xrange由内建函数xrange()创建，不支持多种特性，主要用于遍历
        *   List and bytearray 是可变的sequence类型

    *   mappings
    *   files
    *   classes
    *   instances
    *   exceptions

*   常用类型有
    *   数字
    *   string
    *   tuple ()
    *   set ()
    *   list []
    *   dict {}
*	None
*	True, False

*   布尔操作：not and or
*   比较操作

#### 字符串

常用方式

	sStr1 = sStr1[::-1]		翻转字符串
	a='a,bb,ccc'

### 类型转换

*   int([x[, base]])
*   long([x[, base]])

	int('1234')
	float('12.3')
	bool('true')

#### 字符串

	sStr1 = sStr1[::-1]		翻转字符串
	a='a,bb,ccc'
	a[:-4]  =>  a,bb		字符串截取
	stra+strb				字符关联
	''.join([stra,strb])	字符关联
	"%s%s" % tuple([stra,strb])	字符关联
	find()					index
	split(s[, sep[, maxsplit]]) 返回数组
	startswith('w'):boolean
    endswith('w'):boolean
    'a' in 'cdab'
    replace

<https://docs.python.org/2/library/stdtypes.html>

#### 元组 () tuple

声明后不可变，和list不一样

	(q, b)
	(a,) 单元素

#### 数组 [] List

*   li = ["a", "b", "mpilgrim", "z", "example"]
*   li[0] = 'a'
*   li[-1] = 'example'
*   li[1:3] = ['b', 'mpilgrim']
*   li.append('new')
*   li.insert(2, 'new')
*   li.extend(['bb','aa'])	连接两个list	
*   li.index('new')
*   'new' in li
*   li.remove('z')
*   li.pop()
*   li = li + ['aaa','bbb']
*   li += ['aaa','bbb']
*   li = [1,2] * 3

		列表推导
		[v for v in vs if v > 2]
		[v for vs in vvs for v in vs] 可迭代多次


#### Set

*   add(x)
*   clear()
*   pop()
*   remove(x)	移除，如不存在，抛出异常
*   discard(x)	丢弃，不会抛出报错		
*   x in s
*   支持特别的符号操作
    *   <   set < other
    *   <=  
    *   |   set |= other    新set包含全部元素 
    *   set & other         交集
    *   set - other         差集
    *   ^                   全集 - 交集
*   has(x)
*   x in s
*   set < other 
*   set |= other
*   update(other, ...)
*   set -= other
*   set | other 
*   set & other
*   set - other
	
#### Dictionary {}

*   ['key']

		作为右值，key必须存储

*   ['key']=value
*   key in d
*   items()
*   keys()
*   values()						
*   get(k[,x]) 

		获取，默认值为None

*   clear()
*   pop(k[,default])

		弹出，移除，如果没有默认值并且key不存在，异常

*	del d[key]
*	\- & | - ^

		viewitems() viewkeys() viewvalues() 这些的视图才可以使用这些，完全一致的才算&
	
字典列表推导

	dict([(v, v*10) for v in L])

#### 文件对象 File

*   open

        f = open("hello.txt")
        try:
            for line in f:
                print line
        finally:
            f.close()

        with open("hello.txt") as f:
            for line in f:
                print line

#### Modules

*   m.name
*   __dict__：包含了m的符号表，可以修改，C.x 等同于 C.__dict__["x"]

#### classes 和 类实例 : Objects, values and types

*   id()    # 对象的identity，创建时产生，不会改变
*   type()  # 类型，类似id
*   __name__
*   __module__  ： ()
*   __dict__    ： {}
*   __bases__   ： ()
*   __doc__

从2.1版本开始，有新旧2种类

*   旧类：x.__class__ ！= type(x)
*   新类：x.__class__ == type(x)

#### function

Callable类型的对象

*   __doc__
*   __name__
*   __module__

函数修饰符

    函数修饰符返回值为 callable

    @f1(arg)
    @f2
    def func(): pass

    等同于

    def func(): pass
    func = f1(arg)(f2(func))


### 内置变量、

*	\_\_main\_\_
*	\_\_debug\_\_
*   \_\_all\_\_ ： __all__指定的是指此包被import * 的时候, 哪些模块会被import进来
*   \_\_path\_\_ ： __init__.py的__path__变量指定了包的搜索路径

### 判断变量是否存在

    'var'   in   dir()
    'var'   in   locals().keys()

## 语法

*	表达式

*	赋值

*	assert 表达式 ["," 异常]

*	pass 空操作

*	print
	
	*	`print var_i,`	打印时不换行
	*	`print >> sys.stderr, var_i` 打印到错误流

*	return

*	yield 用于定义一个**生成器**函数

	示例，生成斐波那契數列

		def fab(max): 
	    n, a, b = 0, 0, 1 
	    while n < max: 
	        yield b 
	        # print b 
	        a, b = b, a + b 
	        n = n + 1 

		for n in fab(5):
			print n

*	raise

*	import

	*	import module [ as name ]
	*	from moudule import moudle [ as name ]
	*	from moudule import *

*	global

*	exec

        python -c "exec('try: from urllib2 import urlopen \nexcept: from urllib.request import urlopen');f=urlopen('https://raw.github.com/pypa/pip/master/contrib/get-pip.py').read();exec(f)"

*	del

*	not and or
	
*	if

		if * : 
		elif * :
		else:

		V1 if X else V2

*	while
	
		while *:

*	for 
	
		for * in *:

*	break, continue

*	try except finally

		try:
		except Exception, e:
		finally:

## 函数

function fun_name(arg1, *arg2, **arg3):


### 内置函数

*   abs()

*   all()
   
		如果迭代元素全部是True，返回True;迭代器为空，也返回True

*   any()

*   basestring()

		等同于isinstance(obj, (str, unicode))

*   bin() ？

*   bytearray() ？

*   callable() ？

*   chr(i)

		返回包含Ascii值i对应的char的字符串

*   classmethod() ？

*   cmp(x, y)

*   eval(expression[, globals[, locals]])

		globals和locals为了传递环境值变量

*   execfile(filename[, globals[, locals]])

*   **filter(function , sequence)**

		返回序列，元素是原序列中能使function返回true的值。  
	    等同于：[item for item in iterable if function(item)]

*   format(value[, format_spec])

*   frozenset([iterable]) 

		返回一个冻结的set

*   getattr(object, name[, default])

*   globals()

		返回当前全局符号表的字典

*   hasattr(object, name)

*   hash(object) *内置的哈希函数*

*   hex(x) 

		把数字转为16进制字符串

*   id(obj) 

		返回对象的身份标识 

*   isinstance(object, classinfo)

		判断实体类型

*   issubclass(class, classinfo)

*   len(s)

*   locals()

*	map(function,sequence,[sequence...])

		返回序列,为对原序列每个元素分别调用function获得的值
		map(lambda x,y,z:x+y+z,range(1,3),range(3,5),range(5,7))

*   max(iterable[, args...][, key])

	*	max(iterable) 最大值
	*	max(var1,var2,...)
	*	max(var1,var2,...,func) func是单参数的排序函数？

*   min(iterable[, args...][, key])

*   object()

	返回一个对象。

*   oct(x)

*   open(filename[, mode[, bufsize]])

		打开文件 open(fiel, "w")
	*	r	读
	*	w	写，文件存在会清空内容
	*	a	追加
	*	b	二进制方式处理
	*	r+	支持更新
	*	w+
	*	a+

*   ord(c)

*   pow(x, y[, z])

		pow(x, y) % z)

*   range([start], stop[, step])

		参数的含义为起点(默认为0),终点(不含终点),步长(默认为1)

*   raw_input([prompt])

		从标准流读入用户键入数据到变量。

*   reduce(function,sequence,[init])

		返回一个单值，计算为对每个序列值重复调用function
		reduce(lambda x,y:x+y,range(3),99)的计算为
		99+0=99 => 99+1=100 => 100+2=102

*   reversed(seq) 反向循环

*   round(x[, n]) 舍入x到小数点后n个数字

*   setattr(object, name, value)

*   sorted(iterable[, cmp[, key[, reverse]]])

		cmp：指定对比函数
		key：指定单参数函数，用于对key预处理
		reverse：是否倒序

		返回一个有序的新序列
		sorted(m_p[k], lambda x, y: x[1]-y[1])

*   str(obj) 返回打印友好的字符串

*   sum(iterable[, start])

*   vars(obj)

		返回对象或模型的属性 attribute

*   xrange() range的加速版

*   zip([iterable, ...])

		用于多个sequence的循环
		>>> x = [1, 2, 3]
		>>> y = [4, 5, 6]
		>>> zipped = zip(x, y)
		>>> zipped
		[(1, 4), (2, 5), (3, 6)]

## 模块

模块是对象，

所有的模块都有一个内置属性 __name__。一个模块的 __name__ 的值取决于您如何应用模块。如果 import 一个模块，那么模块__name__ 的值通常为模块文件名，不带路径或者文件扩展名。但是您也可以像一个标准的程序样直接运行模块，在这 种情况下, __name__ 的值将是一个特别缺省"__main__"。

## python安装

	wget http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz
	tar -xzvf Python-2.7.3.tgz
	cd Python-2.7.3
	configure --prefix=$HOME/local/python
	make -j 8

### easy_install 安装

	wget http://peak.telecommunity.com/dist/ez_setup.py 
	python ez_setup.py
	
使用 easy_install

	easy_install thrift
	easy_install python-memcached
	
easy_install可以通过 –user 选项来把软件包安装到用户目录
$HOME/.local/lib/python2.6/site-packages

### PIP 安装

	easy_install pip

安装你想要的组件

	pip install thrift

debug方式
http://www.ibm.com/developerworks/cn/linux/l-cn-pythondebugger/

文档查看
python -c "print dir(str)"	列出全部str的方法
>>>>>>> 4f85ec5a81000f3a1ba65b39c82c4e7bd9d2e0d5:blogs/blogs/编程语言/Python.md

## 类和对象

* 类的特殊

		@classmethod	类方法
		@staticmethod	静态方法


## 函数编程

## 常用类库

### Queue

*   Queue.Queue(maxsize=0)
*   Queue.LifoQueue(maxsize=0)
*   Queue.PriorityQueue(maxsize=0)
*   Queue.qsize()
*   Queue.empty()							判断是否为空
*   Queue.full()
*   Queue.put(item[, block[, timeout]])		
	
		放置数据，阻塞，最长时间，如设置不阻塞，或者阻塞超时，
		队列满的话会报错Queue.Full异常。
		timeout是大于0的浮点数，单位秒，小数部分表示毫秒。

*	Queue.get([block[, timeout]])			

		获取数据，阻塞，最长时间，如设置不阻塞，或者阻塞超时，
		队列空的话会报错Queue.Empty异常

*	Queue.task_done()						
		
		标记来自于队列的任务已经完成，用于消费者线程。当使用wait函数时才有意义。

### logging

	import logging
	logger = logging.getLogger("simple_example")
	logger.setLevel(logging.DEBUG)
	ch = logging.StreamHandler()
	ch.setLevel(logging.DEBUG)
	formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
	ch.setFormatter(formatter)
	logger.addHandler(ch)
	logger.exception(''), 会中处理Exception
		try:
			some_code()
		except:
			logging.exception('')

	
### 输入输出

	sys.stdout
	sys.stderr
	print >>f, message
	print >>f, message,
	getopt
	
### traceback

	import traceback
	traceback.print_exc()
	 
	def fifths(a):
		return 5/a
	 
	def myfunction(value):
		b = fifths(value) * 100
	 
	try:
		print myfunction(0)
	except Exception, ex:
		logfile = open('mylog.log','a')
		traceback.print_exc(file=logfile)
		logfile.close()
		print "Oops ! Something went wrong. Please look in the log file."

    Exception ex:
        Exception.

### 流重定向

Python的sys模块重包含标准输入、输出和错误流：sys.stdin, sys.stdout, sys.stderr.
流的重定向包括重定向到文件，程序，和Python对象。
stdin, stdout, stderr在Python中无非都是文件属性的对象，

	import sys

	buffer = ''

	class Logger:
		def write(self, s):
			global buffer
			buffer += s

	mylogger = Logger()
	stdout_ = sys.stdout # backup reference to the old stdout.
	sys.stdout = mylogger

	print 'ok'
	print '1'
	print {'a': 1, 'b': 2}, 'hello', [1,2,3]

	sys.stdout = stdout_
	print buffer


另一个示例：

	from StringIO import StringIO
	import sys
	buff =StringIO()
	temp = sys.stdout                               #保存标准I/O流
	sys.stdout = buff                                 #将标准I/O流重定向到buff对象
	print 42, 'hello', 0.001
	sys.stdout =temp                                 #恢复标准I/O流
	print buff.getvalue()
	
		
## 类库	

### sys

	version
	version_info
	
	
### random

- random
	- random()			随机浮点数
	- uniform(a,b)		生成一个指定范围内的随机浮点数
	- randint(a,b)		随机整数 [a,b]
	- seed([x])			随机数种子

### 时间 time datetime

-	time
	-   gmtime([secs]) 国际时间, 元组
	-   localtime([secs]) 本地时间，元组
	-   mktime(tupletime) 指定时间，秒数，浮点型
	-   sleep(secs)
	-   strftime(fmt[,tupletime]) 默认是localtime()的tupletime
	-   strptime(str,fmt='%a %b %d %H:%M%S %Y') 返回struct_time
	-   time() 当前时刻，秒数，浮点数	UTC

			Index Attribute Values 
			0 tm_year (for example, 1993) 
			1 tm_mon range [1, 12] 
			2 tm_mday range [1, 31] 
			3 tm_hour range [0, 23] 
			4 tm_min range [0, 59] 
			5 tm_sec range [0, 61]; see (1) in strftime() description 
			6 tm_wday range [0, 6], Monday is 0 
			7 tm_yday range [1, 366] 
			8 tm_isdst 0, 1 or -1; see below 


    "%Y-%m-%d %H:%M:%S"

### 文件和目录
	
-   os
	-   remove				只能删除存在的文件
	-   rename(src,dst)		重命名
	-   renames(old, new)
	-   listdir(path)		返回实体名列表，非递归
	-   mkdir
	-   makedirs				创建目录，并且自动创建中间目录，但如果叶节点目录存在，会报错
	-   readlink
	-   symlink
	-   walk					返回的是一个三元tupple(dirpath, dirnames, filenames)
	-   sep					路径分隔符
	-   chdir('D:\Program Files')
	-   getcwd()
	-   getpid()
	-   popen(command[, mode[, bufsize]])
	-   getenv(varname[, value])		
	-   open()
		
- os.path
	-   isabs(path)
	-   isfile(path) 
	-   isdir(path) 
	-   islink(path) 			是否是链接；但如果系统不支持链接，返回False 
	-   ismount(path)
	-   abspath(path) 			返回绝对路径 os.path.abspath('.')
	-   dirname(path) 			返回
	-   exists(path) 
	-   lexists(path) 			和exists函数一样 
	-   getsize(path) 
	-   getctime(path) 		
	
			返回浮点数的系统时间，在类Unix系统上是文件最近更改的时间，在Windows上是文件或目录的创建时间
 
	-   getmtime(path) 		文件或目录最后更改的时间 
	-   getatime(path) 		文件或目录最后存取的时间 
	-   samefile(path1,path2) 
	
			如果2个路径指向同样的文件或目录，返回True(Windows上不可用)

	-	split(path)	 
	
			分割路径，如果path是目录，返回[parentName, dirName]；如果path是文件，返回[dirName, fileName]

	-	splitext(path) 
	
			分割路径，如果path是目录，返回[parentName, '']；如果path是文件，返回[dirName+fileName, 文件后缀]

	-	basename
	
### 文件读写

	open
		f = open("d:\test.txt", "w")		open和os.open是不一样的
		
- file f
	- .read([size])				读取整个文件到字符串
	- .readline()					读取一行
	- .readlines()
	- .write(string)
	- .seek(0)
	- .seek(offset, from_what)
	- .close()
	
### 进程

	http://www.oschina.net/question/234345_52660
	os.system(cmd)
	os.open(cmd)
		os.O_RDONLY
		os.O_WRONLY
		os.O_RDWR
		os.O_APPEND
		
	subprocess
		.call
		p = subprocess.Popen('ls',stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
		
### mutilprocess

进程和父进程以某种方式保持联系，其中子进程的STDIN和STDOUT被重定向。  
和reload(sys)会有冲突。

	import multiprocessing

	def worker(num):
		"""thread worker function"""
		print 'Worker:', num
		return

	if __name__ == '__main__':
		jobs = []
		for i in range(5):
			p = multiprocessing.Process(target=worker, args=(i,))
			jobs.append(p)
			p.start()
		
### 进程	

-	Popen
	
	-	poll()						
	
			用于检查子进程是否已经结束。设置并返回returncode属性。

	-	wait() 等待子进程结束。设置并返回returncode属性。
	
	-	communicate(input=None)	
	
			与子进程进行交互。向stdin发送数据，或从stdout和stderr中读取数据。
			可选参数input指定发送到子进程的参数。
			Communicate()返回一个元组：(stdoutdata, stderrdata)。
			注意：如果希望通过进程的stdin向其发送数据，在创建Popen对象的时候，参数stdin必须被设置为PIPE。
			同样，如果希望从stdout和stderr获取数据，必须将stdout和stderr设置为PIPE。

	-	send_signal(signal)	向子进程发送信号。
	-	terminate()	停止(stop)子进程
	-	kill()	杀死子进程。和terminate相比，发送的信号量不同
	-	stdin	如果在创建Popen对象是，参数stdout被设置为PIPE，否则返回None。
	-	stdout
	-	stderr
	-	pid		获取子进程的进程ID。
	-	returncode	获取进程的返回值。如果进程还没有结束，返回None。

### PB protobuf

	ParseFromString
	SerializeToString

### 网络

	urlparse.urlparse(http://abc.com/path/file.php?a=b&d=c#flag)
		scheme 	 0 URL scheme specifier empty string 
		netloc 	 1 Network location part empty string 
		path 	 2 Hierarchical path empty string 
		params 	 3 Parameters for last path element empty string 
		query	 4 Query component empty string 
		fragment 5 Fragment identifier empty string 
		username   User name None 
		password   Password None 
		hostname   Host name (lower case) None 
		port 
	
	httplib.HTTPConnection(host[, port[, strict[, timeout[, source_address]]]])
		成功连接后，返回	
		httplib.HTTPResponse
			HTTPResponse.getheader(name[, default])
			HTTPResponse.read([amt])
			HTTPResponse.status
		httplib.HTTPMessage		hold the headers from an HTTP response
		httplib.HTTPException	此包的基础异常
		httplib.responses		字典，封装了HTTP 1.1 status codes对应的标准名称
		
		>>> import httplib
		>>> conn = httplib.HTTPConnection("www.python.org")
		>>> conn.request("GET", "/index.html")
		>>> r1 = conn.getresponse()
		>>> print r1.status, r1.reason
		200 OK
		>>> data1 = r1.read()
		>>> conn.request("GET", "/parrot.spam")
		>>> r2 = conn.getresponse()
		>>> print r2.status, r2.reason
		404 Not Found
		>>> data2 = r2.read()
		>>> conn.close()
		
		>>> import httplib, urllib
		>>> params = urllib.urlencode({'spam': 1, 'eggs': 2, 'bacon': 0})
		>>> headers = {"Content-type": "application/x-www-form-urlencoded",
		...            "Accept": "text/plain"}
		>>> conn = httplib.HTTPConnection("musi-cal.mojam.com:80")
		>>> conn.request("POST", "/cgi-bin/query", params, headers)
		>>> response = conn.getresponse()
		>>> print response.status, response.reason
		200 OK
		>>> data = response.read()
		>>> conn.close()



###　Bisect	二分查找

	bisect.bisect_left(a,x, lo=0, hi=len(a))	查找在有序列表a中插入x的index。lo和hi用于指定列表的区间，默认是使用整个列表。如果x已经存在，在其左边插入。返回值为index。
	bisect.bisect_right							和bisect_left类似，但如果x已经存在，在其右边插入。
	bisect.bisect								同bisect_right
	bisect.insort_left(a,x, lo=0, hi=len(a))	在有序列表a中插入x。和a.insert(bisect.bisect_left(a,x, lo, hi), x) 的效果相同。
	bisect.insort_right(a,x, lo=0, hi=len(a))	和insort_left类似，但如果x已经存在，在其右边插入。
	bisect.insort(a, x,lo=0, hi=len(a))			同insort_right
	
	import re

    re.I	使匹配对大小写不敏感
    re.L	做本地化识别（locale-aware）匹配
    re.M	多行匹配，影响 ^ 和 $
    re.S	使 . 匹配包括换行在内的所有字符
    re.U	根据Unicode字符集解析字符。这个标志影响 \w, \W, \b, \B.
    re.X	该标志通过给予你更灵活的格式以便你将正则表达式写得更易于理解。

	p = re.compile('ab*')
	p = re.compile('ab*', re.IGNORECASE)

	常规字符："\\\\section"
	raw字符：r"\\section"
	
	re.match(pattern, string, flags=0)		决定 RE 是否在字符串刚开始的位置匹配
	re.search(pattern, string, flags=0)	扫描字符串，找到这个 RE 匹配的位置
    re.sub(pattern, repl, string, max=0)   替换字符串中的匹配项,返回新的字符串

    MatchObject = p.match( 'tempo')
	p.findall(str)	找到 RE 匹配的所有子串，并把它们作为一个列表返回
	p.finditer(str)	找到 RE 匹配的所有子串，并把它们作为一个迭代器返回
    m = p.match( 'tempo')
	p.findall(str)	找到 RE 匹配的所有子串，并把它们作为一个列表返回
	p.finditer(str)	找到 RE 匹配的所有子串，并把它们作为一个迭代器返回
	

	MatchObject可以访问：
	group()	返回被 RE 匹配的字符串
	start()	返回匹配开始的位置
	end()	返回匹配结束的位置
	span()	返回一个元组包含匹配 (开始,结束) 的位置

	m.group()
	m.start()
	m.end()

	re 模块也提供了顶级函数调用如 match()、search()、sub() 等等，所以也可以：
	print re.match(r'From\s+', 'Fromage amk')
	num = re.sub(r'#.*$', "", phone)

		 
### 配置，命令行

	parser = OptionParser( "usage: %prog [config]", version = "%prog 0.1" )
	parser.add_option( "-p", "--package", dest="max_package_size", type="int", default=256, help="max package size(M)" )
	parser.add_option( "-s", "--speed", dest="speed_limit", type="int", default=10, help="speed limit(M/S)" )
	parser.add_option( "-r", "--time", dest="max_run_time", type="int", default=9, help="max run time(Minutes)" )
	parser.add_option( "-c", "--conf", dest="conf_dir", type="int", default="%s/conf" % base_dir, help="config file dir" )
	(config, args) = parser.parse_args()
	load_config( config )

### Mysql

<http://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html	>
	
	
### 调试

	代码中
	import pdb
	pdb.set_trace()
	
	进入调试界面后
	命令	解释
	break 或 b 设置断点	设置断点
	continue 或 c	继续执行程序
	list 或 l	查看当前行的代码段
	step 或 s	进入函数
	return 或 r	执行代码直到从当前函数返回
	exit 或 q	中止并退出
	next 或 n	执行下一行
	pp	打印变量的值
	help	帮助

import atexit

	atexit.register(func[, *args[, **kargs]])
	atexit.register(savecounter)
	atexit.register(goodbye, 'Donny', 'nice')
	atexit.register(goodbye, adjective='nice', name='Donny')

### 中断信号

	signal(SIGALRM,when_alarm);  	//当接收到SIGALRM信号时，调用when_alarm函数  
	signal(SIGINT,when_sigint);  	//当接收到SIGINT信号时，调用when_sigint函数  
	signal(SIGCHLD,when_sigchld);	//当接收到SIGCHLD信号时，调用when_sigchld函数  
	signal(SIGUSR1,when_sigusr1);	//当接收到SIGUSR1信号时，调用when_sigusr1函数  
	signal(SIGIO,when_sigio);		//当接收到SIGIO信号时，调用when_sigio函数
	
### 操作符重载

	重载是通过特殊命名的类方法来实现的
	__new__ 						在创建实例的时候被调用, 通常用在设置不变数据类型的子类
	__init__ 						在创建实例的时候被调用
	__cmp__(self, other)			在比较的时候调用
	__pos__(self)					一元加
	__neg__(self)					一元减
	__invert__(self)				取反
	__index__(self)					对象被作为索引使用的时候	x[self]
	__nonzero__(self)				对象的布尔值	bool(self)
	__getattr__(self, name)			访问一个不存在的属性时	self.name # name 不存在
	__getattribute__(self, name)	访问任何属性时	self.name
	__setattr__(self, name, val)	对一个属性赋值时	self.name = val
	__delattr__(self, name)			删除一个属性时	del self.name
	__getitem__(self, key)			使用索引访问元素时	self[key]
	__setitem__(self, key, val)		self[key] = val	对某个索引值赋值时
	__delitem__(self, key)	del 	self[key]	删除某个索引值时
	__iter__(self)	for x in self	迭代时
	__contains__(self, value)		value in self, value not in self	使用 in 操作测试关系时
	__concat__(self, value)			self + other	连接两个对象时
	__call__(self [,...])			self(args)	“调用”对象时
	__enter__(self)					with self as x:	with 语句环境管理
	__exit__(self, exc, val, trace)	with self as x:	with 语句环境管理
	__getstate__(self)				pickle.dump(pkl_file, self)		序列化
	__setstate__(self)				data = pickle.load(pkl_file)	序列化
	C.__str__(self) 				可打印的字符输出；内建str()及print 语句
	C.__repr__(self) 				运行时的字符串输出；内建repr()  ‘‘  和 操作符
	C.__unicode__(self)				b Unicode 字符串输出；内建unicode()
	C.__len__(self)					长度（可用于类）；内建len()
	C.__cmp__(self, obj)			对象比较；内建cmp()
	C.__lt__(self, obj)				小于/小于或等于；对应<及<=操作符
	C.__le__(self,obj)
	C.__gt__(self, obj)				大于/大于或等于；对应>及>=操作符
	C.__ge__(self,obj)
	C.__eq__(self, obj)				等于/不等于；对应==,!=及<>操作符
	C.__ne__(self,obj)
	C.__getattr__(self, attr)		获取属性；内建getattr()；仅当属性没有找到时调用
	C.__setattr__(self, attr, val)	设置属性
	C.__delattr__(self, attr)		删除属性
	C.__getattribute__(self, attr)	获取属性；内建getattr()；总是被调用
	C.__get__(self, attr)			（描述符）获取属性
	C.__set__(self, attr, val)		（描述符）设置属性
	C.__delete__(self, attr)		（描述符）删除属性
	C.__*add__(self, obj)			加；+操作符
	C.__*sub__(self, obj)			减；-操作符
	C.__*mul__(self, obj)			乘；*操作符
	C.__*div__(self, obj)			除；/操作符
	C.__*truediv__(self, obj)		True 除；/操作符
	C.__*floordiv__(self, obj)		Floor 除；//操作符
	C.__*mod__(self, obj)			取模/取余；%操作符
	C.__*divmod__(self, obj)		除和取模；内建divmod()
	C.__*pow__(self, obj[, mod])	乘幂；内建pow();**操作符
	C.__*lshift__(self, obj)		左移位；<<操作符
	C.__*rshift__(self, obj)		右移；>>操作符
	C.__*and__(self, obj)			按位与；&操作符
	C.__*or__(self, obj)			按位或；|操作符
	C.__*xor__(self, obj)			按位与或；^操作符
	C.__neg__(self) 				一元负
	C.__pos__(self) 				一元正
	C.__abs__(self) 				绝对值；内建abs()
	C.__invert__(self) 				按位求反；~操作符
	C.__complex__(self, com) 		转为complex(复数);内建complex()
	C.__int__(self) 				转为int;内建int()
	C.__long__(self) 				转为long；内建long()
	C.__float__(self) 				转为float；内建float()
	C.__oct__(self) 				八进制表示；内建oct()
	C.__hex__(self) 				十六进制表示；内建hex()
	C.__coerce__(self, num) 		压缩成同样的数值类型；内建coerce()
	C.__index__(self)g 				在有必要时,压缩可选的数值类型为整型（比如：用于切片索引等等
	C.__len__(self) 				序列中项的数目
	C.__getitem__(self, ind) 		得到单个序列元素
	C.__setitem__(self, ind,val) 	设置单个序列元素
	C.__delitem__(self, ind) 		删除单个序列元素
	C.__getslice__(self, ind1,ind2) 得到序列片断
	C.__setslice__(self, i1, i2,val) 设置序列片断
	C.__delslice__(self, ind1,ind2) 删除序列片断
	C.__contains__(self, val) 		f 测试序列成员；内建in 关键字
	C.__*add__(self,obj) 			串连；+操作符
	C.__*mul__(self,obj) 			重复；*操作符
	C.__iter__(self)  				创建迭代类；内建iter()
	C.__len__(self) 				mapping 中的项的数目
	C.__hash__(self) 				散列(hash)函数值
	C.__getitem__(self,key) 		得到给定键(key)的值
	C.__setitem__(self,key,val) 	设置给定键(key)的值
	C.__delitem__(self,key) 		删除给定键(key)的值
	C.__missing__(self,key) 		给定键如果不存在字典中，则提供一个默认值

	
## 特殊技巧
*   虽然可以，但别在一行中写多个语句
*	import sys; print sys.version	获取版本

### 动态

*   locals()['part'+str(i)]=i     str()是将变量变成字符串
    exec()
    eval()

----------

# tornado  Web Service

<http://blog.thisisfeifan.com/2012/06/deploy-tornado-application.html>

# python虚拟环境

<http://stackoverflow.com/questions/4750806/how-to-install-pip-on-windows/15915700#15915700>

<http://liuzhijun.iteye.com/blog/1872241>

# 重要的环境变量


*   PYTHONPATH：类似PATH. 加载模块的路径。
*   PYTHONSTARTUP：类型Unix的.profile。
*   PYTHONCASEOK：在Windows中用于取消大小敏感。 
*   PYTHONHOME：An alternative module search path. It's usually embedded in the PYTHONSTARTUP or PYTHONPATH directories to make switching module libraries easy.


        PATH=os.environ.get('PYTHONSTARTUP')

windows:
![](http://my.csdn.net/uploads/201205/30/1338348815_2484.png)
linux:    
![](http://my.csdn.net/uploads/201205/30/1338348870_8878.png)