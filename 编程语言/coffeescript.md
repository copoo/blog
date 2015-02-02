# coffee script

<http://coffeescript.cn/>

CoffeeScript 的指导原则是: "她仅仅是 JavaScript"

	sudo npm install -g coffee-script

例子：

*	编译一个 .coffee 文件的树形目录 src 到一个同级  .js 文件树形目录 lib:

		coffee --compile --output lib/ src/

*	监视一个文件的改变, 每次文件被保证时重新编译:

		coffee --watch --compile experimental.coffee

*	合并一组文件到单个脚本:

		coffee --join project.js --compile src/*.coffee

*	从一个 one-liner 打印编译后的 JS:

		coffee -bpe "alert i for i in [0..10]"

*	现在全部一起, 在你工作时监视和重复编译整个项目:

		coffee -o lib/ -cw src/

*	运行 CoffeeScript REPL (Ctrl-D 来终止, Ctrl-V 激活多行):

		coffee

## 函数

	square = (x) -> x * x
	cube   = (x) -> square(x) * x

	fill = (container, liquid = "coffee") ->
  		"Filling the #{container} with #{liquid}..."

	# 无参数的函数
	changeNumbers = ->
	  inner = -1
	  outer = 10
	
	# 变长参数
	awardMedals = (first, second, others...) ->
	  gold   = first
	  silver = second
	  rest   = others

	contenders = [
	  "Michael Phelps"
	  "Liu Xiang"
	]
	
	awardMedals contenders...

=> 符号和 ->符号一样可以生成函数，前者可以绑定this，保证它不会变化

	Account = (customer, cart) ->
	  @customer = customer
	  @cart = cart
	
	  $('.shopping_cart').bind 'click', (event) =>
	    @customer.purchase @cart

## 字符串

	author = "Wittgenstein"
	quote  = "A picture is a fact. -- #{ author }"
	
	sentence = "#{ 22 / 7 } is a decent approximation of π"

允许多行

	# 简单的以空格串联多行
	mobyDick = "Call me Ishmael. Some years ago --
	  world..."

	# 块状字符串可以保持格式
	html = """
       <strong>
         cup of coffeescript
       </strong>
       """

	# 块状注释
	###
	SkinnyMochaHalfCaffScript Compiler v1.0
	Released under the MIT License
	###

	# 块状正则 /// 方便阅读
	OPERATOR = /// ^ (
	  ?: [-=]>             # 函数
	   | [-+*/%<>&|^!?=]=  # 复合赋值 / 比较
	   | >>>=?             # 补 0 右移
	   | ([-+:])\1         # 双写
	   | ([&|<>])\2=?      # 逻辑 / 移位
	   | \?\.              # soak 访问
	   | \.{2,3}           # 范围或者 splat
	) ///

## 对象和数组

	song = ["do", "re", "mi", "fa", "so"]

	singers = {Jagger: "Rock", Elvis: "Roll"}
	
	bitlist = [
	  1, 0, 1
	  0, 0, 1
	  1, 1, 0
	]
	
	kids =
	  brother:
	    name: "Max"
	    age:  11
	  sister:
	    name: "Ida"
	    age:  9

	$('.account').attr class: 'active'、

	# 数组切割
	numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9]
	# .. 包含end
	start   = numbers[0..2]
	# ... 不包含end
	middle  = numbers[3...-2]
	# 最后2个	
	end     = numbers[-2..]
	# 从0开始到最后	
	copy    = numbers[..]
	# 可以用来做数组替换
	numbers[3..6] = [-3, -4, -5, -6]
	
## 简单语法

	# if
	mood = greatlyImproved if singing

	if happy and knowsIt
	  clapsHands()
	  chaChaCha()
	else
	  showIt()
	
	date = if friday then sue else jill

	# for
	eat food for food in ['toast', 'cheese', 'wine']

	courses = ['greens', 'caviar', 'truffles', 'roast', 'cake']
	menu i + 1, dish for dish, i in courses
	
	eat food for food in foods when food isnt 'chocolate'

	# 推导，类似python的列表推导
	countdown = (num for num in [10..1])
	evens = (x for x in [0..10] by 2)

	## 这是个对象
	yearsOld = max: 10, ida: 9, tim: 11
	## 遍历这个对象，生成字符串数组
	ages = for child, age of yearsOld
	  "#{child} is #{age}"

	# while, until
	if this.studyingEconomics
	  buy()  while supply > demand
	  sell() until supply > demand

	num = 6
	lyrics = while num -= 1
	  "#{num} little monkeys, jumping on the bed.
	    One fell out and bumped his head."

	for filename in list
	  do (filename) ->
	    fs.readFile filename, (err, contents) ->
	      compile filename, contents.toString()

	# switch
	switch day
	  when "Mon" then go work
	  when "Tue" then go relax
	  when "Thu" then go iceFishing
	  when "Fri", "Sat"
	    if day is bingoDay
	      go bingo
	      go dancing
	  when "Sun" then go church
	  else go work


## 其它语法

*	全部都是表达式

	不需要return，都是表达式，都有返回值。类似scala。

*	多赋值

		
		theBait   = 1000
		theSwitch = 0
		
		[theBait, theSwitch] = [theSwitch, theBait]
	
		# 函数可以返回多个
		weatherReport = (location) ->
		  # 发起一个 Ajax 请求获取天气...
		  [location, 72, "Mostly Sunny"]
		
		[city, temp, forecast] = weatherReport "Berkeley, CA"

		# 可以用于任意深度的数组和对象嵌套
		futurists =
		  sculptor: "Umberto Boccioni"
		  painter:  "Vladimir Burliuk"
		  poet:
		    name:   "F.T. Marinetti"
		    address: [
		      "Via Roma 42R"
		      "Bellagio, Italy 22021"
		    ]
		
		{poet: {name, address: [street, city]}} = futurists

		# 甚至可以用于变长数据
		tag = "<impossible>"

		[open, contents..., close] = tag.split("")
		[first, ..., last] = text.split " "


		# 在类构造函数也很有用
		class Person
		  constructor: (options) -> 
		    {@name, @age, @height} = options
		
		tim = new Person age: 4

*	捕获异常

	alert(
	  try
	    nonexistent / undefined
	  catch error
	    "And the error is ... #{error}"
	)

	try
	  allHellBreaksLoose()
	  catsAndDogsLivingTogether()
	catch error
	  print error
	finally
	  cleanUp()

*	一些操作符

		CoffeeScript	JavaScript
		---------------------------------
		is				===
		isnt			!==
		not				!
		and				&&
		or				||
		true, yes, on	true
		false, no, off	false
		@, this			this
		of				in
		in				no JS equivalent
		a ** b			Math.pow(a, b)
		a // b			Math.floor(a / b)
		a %% b			(a % b + b) % b

*	判断变量是否存在？ 

		# 存在并且不为null
		solipsism = true if mind? and not world?

		# 是函数就调用，否则返回 void 0
		zip = lottery.drawWinner?().address?.zipcode

*	嵌入js

		hi = `function() {
		  return [document.title, "Hello JavaScript"].join(": ");
		}`

*	链式判断

		cholesterol = 127
		healthy = 200 > cholesterol > 60


## 类和继承

		class Animal
		  constructor: (@name) ->
		
		  move: (meters) ->
		    alert @name + " moved #{meters}m."
		
		# super 表示调用父类的move函数
		class Snake extends Animal
		  move: ->
		    alert "Slithering..."
		    super 5
		
		class Horse extends Animal
		  move: ->
		    alert "Galloping..."
		    super 45
		
		sam = new Snake "Sammy the Python"
		tom = new Horse "Tommy the Palomino"
		
		sam.move()
		tom.move()

		# prototype扩充
		String::dasherize = ->
  			this.replace /_/g, "-"
		## 上面的语句翻译为JS
		String.prototype.dasherize = function() {
		  return this.replace(/_/g, "-");
		};

## JQuery

