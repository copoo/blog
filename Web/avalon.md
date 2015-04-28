# avalon 快速参考

![](http://images.cnblogs.com/cnblogs_com/rubylouvre/495346/o_msbindings.png)


-   {{}}		
	
	实际是文本绑定(ms-text)的一种形式

-   ms-skip                

	忽略扫描绑定
-	ms-include

	模板绑定

	如果大家想在模板加载后，加工一下模板，可以使用data-include-loaded来指定回调的名字
	
	如果大家想在模板扫描后，隐藏loading什么的，可以使用data-include-rendered来指定回调的名字

	ms-include-src="src" 加载外部模板

-	ms-text, ms-html

	数据填充, 等同 {{}}， 可以修改
	
		avalon.config({
		   interpolate:["<%","%>"]
		})

	只限那些能返回字符串的绑定属性，如：ms-attr、ms-css、ms-include、ms-class、 ms-href、 ms-title、ms-src。

-	ms-on

	事件绑定

	-   ms-click
	-   ms-dblclick
	-   ms-mouseout
	-   ms-mouseover
	-   ms-mousemove
	-   ms-mouseenter
	-   ms-mouseleave
	-   ms-mouseup
	-   ms-mousedown
	-   ms-keypress
	-   ms-keyup
	-   ms-keydown
	-   ms-focus
	-   ms-blur
	-   ms-change
	-   ms-scroll
	-   ms-animation
	-   ms-on-*

-	ms-visible

	显示隐藏控制

-	ms-data

	用法为ms-data-name="value", 用于为元素节点绑定HTML5 data-*属性。

-   ms-controller="expr"   //这个绑定属性没有参数
-   ms-if="expr"

	将元素移出DOM

-   ms-if-loop="expr"      //这个绑定属性有一个参数
-   ms-repeat-el="array"   //这个绑定属性有一个参数
-   ms-attr

	ms-attr-name="value"，这个允许我们在元素上绑定更多种类的属性，如className, tabIndex, name, colSpan什么的。

-   ms-attr-href="xxxx"    //这个绑定属性有一个参数
-   ms-attr-src="xxx/{{a}}/yyy/{{b}}"   //这个绑定属性的值包含插值表达式，注意只有少部分表示字符串类型的属性可以使用插值表达式
-   ms-class-1="xxx" ms-class-2="yyy" ms-class-3="xxx" //数字还表示绑定的次序
-   ms-css-background-color="xxx" //这个绑定属性有两个参数，但在css绑定里，相当于一个，会内部转换为backgroundColor 

	样式绑定，用法为ms-css-name="value"。属性值不能加入CSS hack与important!
	
-   ms-duplex-aaa-bbb-string="xxx"	//这个绑定属性有三个参数，表示三种不同的拦截操作

	双工绑定

-	ms-repeat

	循环绑定，用法为ms-repeat-xxx="array"，xxx不能出现大写

-	data-xxx-yyy="xxx"，辅助指令

-	$watch，$fire, $unwatch

	特殊的属性了——“$all”

avalon自带以下几个过滤器

-	html	没有传参，用于将文本绑定转换为HTML绑定
-	sanitize	去掉onclick, javascript:alert等可能引起注入攻击的代码。
-	uppercase	大写化
-	lowercase	小写化
-	truncate	对长字符串进行截短，truncate(number, truncation), number默认为30，-	truncation为“...”	
-	camelize	驼峰化处理
-	escape	对类似于HTML格式的字符串进行转义，把尖括号转换为&gt; &lt;
-	currency	对数字添加货币符号，以及千位符， currency(symbol)
-	number	对数字进行各种格式化，这与与PHP的number_format完全兼容， number(decimals, dec_point, thousands_sep),
              
		decimals	可选，规定多少个小数位。
        dec_point	可选，规定用作小数点的字符串（默认为 . ）。
        thousands_sep	可选，规定用作千位分隔符的字符串（默认为 , ），如果设置了该参数，那么所有其他参数都是必需的。
            
-	date	对日期进行格式化，date(formats)



