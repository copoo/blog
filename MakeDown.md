# MarkDown

开源的"编辑器"和"解析器"：<https://code.google.com/p/pagedown/wiki/PageDown>

* [语法说明](http://wowubuntu.com/markdown/index.html)
* 兼容 HTML
* 特殊字符自动转换
* 反斜杠用于转义\
* 强制换行，两个结尾空格

## 区块元素

### 段落
	连续的文本行组成，它的前后要有一个以上的空行

### 标题
	# 标题1
	## 标题2
	###### 标题6

### 区块引用
>区块引用  
>多行  
  
* 用>符号开始区块引用
* 可以嵌套
* 引用的区块内也可以使用其他的 Markdown 语法，包括标题、列表、代码区块等

### 列表
* 无序列表
	
	>*无序列表[注意这个后面有2个空格，用于强制换行]  
	>1.有序列表，数字序号不影响实际输出

### 代码区块
	这就是代码区块，缩进就可以了
	也可以换行
	在代码区块里面， & 、 < 和 > 会自动转成 HTML 实体 感受一下&amp;
 > &amp;

### 分隔线
---
	--- 这个是分割线，可以更长 ---

## 区段元素
	
### 链接
* 链接文字用 [方括号] 来标记
* 行内式的链接 \[示例]\(http://example.com/ "Title")[示例](http://example.com/ "Title")  
  如果你是要链接到同样主机的资源，你可以使用相对路径 [About](/about/)
* 参考式的链接\[示例]\[id][示例][id]，在其它地方，把这个id进行解释[id]: http://example.com/  "Optional Title Here"
* 隐式链接标记\[示例]\[][示例][]，链接标记会视为等同于链接文字

### 强调
	**粗体**
>	斜体*粗体*  
>	粗体**粗体**  
>	\*非斜体*

### 代码
	``
`	this is code，换行无效	`

### 图片
>	行内式图片\!\[Alt text]\(/path/to/img.jpg "Optional title")  
>	引用式图片\!\[Alt text]\[id]

## 其它

### 自动链接
	<http://example.com/>
	<address@example.com>

---

以下是简单示例

---


> 引用

`代码`
[连接](http://www.163.com "网易")

- 无序列表
- 无序列表


*	无序列表
*	无序列表

+ 无序列表
+ 无序列表

----------

1. 有序列表
2. 有序列表

abc
	
	12346
		fka
	adfadfad

abc

<table>
	<tr>
	    <td>Foo</td><td>Foo</td>
	</tr>
	<tr>
	    <td>Foo</td><td>Foo</td>
	</tr>
	<tr>
	    <td>Foo</td><td>Foo</td>
	</tr>
</table>

&copy;

	\   反斜线
	`   反引号
	*   星号
	_   底线
	{}  花括号
	[]  方括号
	()  括弧
	#   井字号
	+   加号
	-   减号
	.   英文句点
	!   惊叹号

![凤凰传奇](http://b.hiphotos.baidu.com/ting/pic/item/71cf3bc79f3df8dc2a947ce2cc11728b4710281c.jpg)




[id]: http://example.com/  "Optional Title Here"
[示例]: http://example.com/  "Optional Title Here"