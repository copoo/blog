# JS

*   函数也是对象

    函数和对象没有本质的区分

*   LinkedHashMap

    函数和对象的一些特性很容易让我想到Java的LinkedHashMap。

## 语法

    从Java转换而来，增加了较多动态脚本语言特性。

*   变量：var
*   特殊：NaN，undefined
*   JS实际上只有1中数据类型，内部使用64位浮点数表示
*   for

        for (var i=0;i<cars.length;i++)
        for (x in person) person[x];
        break;
        continue;

特别的

1.  6+'5'='65' 注意类型隐式转换
2.  === 代表恒等于，不仅判断数值，而且判断类型  

## prototype

## 字符串

    var str="abcde"
    str[1] = 'b'

*   indexOf(searchvalue,fromindex)：返回序号，没有找到-1
*   match(searchvalue)，match(regexp)：返回存放匹配结果的数组
*   replace(regexp/substr,replacement)
*   search(regexp)：返回第一个与 regexp 相匹配的子串的起始位置，或者-1，不支持g参数
*   slice(start,end)：提取指定部分为新字符串。参数可以为负值
*   split(separator,howmany)：返回数组，其中分隔字符串可以是正则
*   substr(start,length)
*   substring(start,stop)

## [数组](http://www.w3school.com.cn/jsref/jsref_obj_array.asp)

    var arr = [];

*   shift：删除原数组第一项，并返回删除元素的值；如果数组为空则返回undefined
*   unshift：将参数添加到原数组开头，并返回数组的长度 
*   pop：删除原数组最后一项，并返回删除元素的值；如果数组为空则返回undefined 
*   push：将参数添加到原数组末尾，并返回数组的长度 
*   concat：返回一个新数组，是将参数添加到原数组中构成的 
*   splice(start,deleteCount,val1,val2,...)：从start位置开始删除deleteCount项，并从该位置起插入val1,val2,... 
    splice(0, a.length)
*   reverse：将数组反序 
*   slice(start,end)：返回从原数组中指定开始下标到结束下标之间的项组成的新数组
*   join(separator)：将数组的元素组起一个字符串，以separator为分隔符，省略的话则用默认用逗号为分隔符
*   sort()	对数组的元素进行排序
*   length	设置或返回数组中元素的数目。 属性

## Regex

    /pattern/attributes

    i	执行对大小写不敏感的匹配。
    g	执行全局匹配（查找所有匹配而非在找到第一个匹配后停止）。
    m	执行多行匹配。


*   exec(string)：返回一个数组，其中存放匹配的结果。如果未找到匹配，则返回值为 null
*   test(string)：检索字符串中指定的值。返回 true 或 false

对字符串，支持如下操作：search，match，replace，split

## 对象

    {}
    
    //定义对象语法
    var object={};

    //对象内的属性语法(属性名(property)与属性值(value)是成对出现的)
    object.property=value;

    //对象内的函数语法(函数名(func)与函数内容是成对出现的)
    object.func=function(){...;};

*   JavaScript 中的**所有事物**都是对象。
*   对象是拥有属性和方法的数据。

## string

substr(start,length)

## time

[JS将时间戳转换成日期格式](http://www.xiaoboy.com/detail/1341545047.html)

## 函数

    function functionname(argument1,argument2...){
        var x=5;
        return x;
    }

*   在函数内部使用var声明的变量是局部变量，只能在函数内部访问它
*   在函数外声明的变量是全局变量，网页上的所有脚本和函数都能访问它
*   把值赋给尚未声明的变量，该变量将被自动作为全局变量声明


## 错误

    try
    {
      //在这里运行代码
    }
    catch(err)
    {
      //在这里处理错误
    }
        
    throw 语句创建自定义错误。

## 全局函数

*   decodeURI：解码encodeURI函数编码的字符串
*   decodeURIComponent：解码encodeURIComponent函数编码的字符串
*   encodeURI   转义某些字符串对URI编码
*   encodeURIComponent -- 转义某些字符串对URI的组件编码
*   escape -- 使用转义序列编码字符串
*   eval -- 执行字符串形式的JavaScript表达式或语句，并返回结果(如果有)
*   isFinite -- 检测值是否为有限的
*   isNaN -- 检测值是否为非数字
*   parseFloat -- 将字符串解析为数字
*   parseInt -- 将字符串解析为整数
*   unescape -- 解码escape函数编码的字符串

