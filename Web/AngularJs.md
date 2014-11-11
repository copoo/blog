# AngularJS

*   <http://www.ituring.com.cn/article/15762>
*   <http://www.ituring.com.cn/article/15767> 比较全面的一个示例：app rout ..
*   <http://angularjs.cn/A02B> api 列表
*   <http://www.yearofmoo.com/2012/11/angularjs-and-seo.html>
*   <http://phantomjs.org/>

##	表达式

*   `a=b`
*   `func(a)`
*   `a=b;func(a)`

##	MVC

*	当组建视图(UI)同时又要写软件逻辑时，声明式的代码会比命令式的代码好得多，
*	控制器允许我们建立模型和视图之间的数据绑定。
*	我们要把index.html模板转变成“布局模板”。这是我们应用所有视图的通用模板。其他的“局部布局模板”随后根据当前的“路由”被充填入，从而形成一个完整视图展示给用户。

## scope

*   [构建自己的AngularJS](http://angularjs.cn/A0lr) 非常棒!
*   [理解AngularJS的作用域Scope](http://angularjs.cn/A09C) 描述了特别的指令的内建Scope，比较重要。

子作用域一般都会通过JavaScript原型继承机制继承其父作用域的属性和方法。但是Isolate scope不会如此，它是独立的，常用于构造可复用的directive组件。ng-repeat、 ng-switch、ng-view和ng-include 都会创建子作用域。在子作用域中使用$parent.parentScopeProperty，这样可以直接修改父作用域的属性。

*   以下方式会创建新的子作用域，并且进行原型继承： ng-repeat、ng-include、ng-switch、ng-view、ng-controller, 用scope: true和transclude: true创建directive。
*   以下方式会创建新的独立作用域，不会进行原型继承：用scope: { ... }创建directive。这样创建的作用域被称为"Isolate"作用域。

ng-repeat对每一个迭代项Item都会创建子作用域, 子作用域也从父作用域进行原型继承。 但它还是会在子作用域中新建同名属性，把Item赋值给对应的子作用域的同名属性。

    function Scope() {
        this.$$watchers = [];
        this.$$asyncQueue = [];
        this.$$phase = null;
    }
    Scope.prototype.$watch = function(watchFn, listenerFn, valueEq) {
      var self = this;
      var watcher = {
        watchFn: watchFn,
        listenerFn: listenerFn,
        valueEq: !!valueEq
      };
      self.$$watchers.push(watcher);
      return function() {
        var index = self.$$watchers.indexOf(watcher);
        if (index >= 0) {
          self.$$watchers.splice(index, 1);
        }
      };
    };
    Scope.prototype.$$areEqual = function(newValue, oldValue, valueEq) {
      if (valueEq) {
        return _.isEqual(newValue, oldValue);
      } else {
        return newValue === oldValue ||
          (typeof newValue === 'number' && typeof oldValue === 'number' &&
          isNaN(newValue) && isNaN(oldValue));
      }
    };
    Scope.prototype.$$digestOnce = function() {
      var self  = this;
      var dirty;
      _.forEach(this.$$watchers, function(watch) {
        var newValue = watch.watchFn(self);
        var oldValue = watch.last;
        if (!self.$$areEqual(newValue, oldValue, watch.valueEq)) {
          watch.listenerFn(newValue, oldValue, self);
          dirty = true;
        }
        watch.last = (watch.valueEq ? _.cloneDeep(newValue) : newValue);
      });
      return dirty;
    };
    Scope.prototype.$digest = function() {
      var ttl = 10;
      var dirty;
      this.$beginPhase("$digest");
      do {
        while (this.$$asyncQueue.length) {
          var asyncTask = this.$$asyncQueue.shift();
          this.$eval(asyncTask.expression);
        }
        dirty = this.$$digestOnce();
        if (dirty && !(ttl--)) {
          this.$clearPhase();
          throw "10 digest iterations reached";
        }
      } while (dirty);
      this.$clearPhase();
    };
    Scope.prototype.$eval = function(expr, locals) {
      return expr(this, locals); ？
    };
    Scope.prototype.$apply = function(expr) {
      try {
        this.$beginPhase("$apply");
        return this.$eval(expr);
      } finally {
        this.$clearPhase();
        this.$digest();
      }
    };
    Scope.prototype.$evalAsync = function(expr) {
      var self = this;
      if (!self.$$phase && !self.$$asyncQueue.length) {
        setTimeout(function() {
          if (self.$$asyncQueue.length) {
            self.$digest();
          }
        }, 0);
      }
      self.$$asyncQueue.push({scope: self, expression: expr});
    };
    Scope.prototype.$beginPhase = function(phase) {
      if (this.$$phase) {
        throw this.$$phase + ' already in progress.';
      }
      this.$$phase = phase;
    };
    
    Scope.prototype.$clearPhase = function() {
      this.$$phase = null;
    };


### $watch和$digest

两者相辅相成，一起构成了Angular作用域的核心：数据变化的响应。
watch注册观察器和监听器，观察器确定观察值是否变化了，监听器在值发生变化时被调用。

### $eval

它使用一个函数作参数，所做的事情是立即执行这个传入的函数，并且把作用域自身当作参数传递给它，返回的是这个函数的返回值。$eval也可以有第二个参数，它所做的仅仅是把这个参数传递给这个函数。

### $apply

我们可以执行一些与Angular无关的代码，这些代码也还是可以改变作用域上的东西，$apply可以保证作用域上的监听器可以检测这些变更。


## directive 指令

在DOM编译期间，和HTML关联着的指令会被检测到，并且被执行。这使得指令可以为DOM指定行为，或者改变它。指令可以做为元素名，属性名，类名，或者注释。

<https://github.com/angular/angular.js/blob/v1.2.4/src/ng/directive/ngRepeat.js#L3>

指令本质上只是一个当编译器编译到相关DOM时需要执行的函数。

## Digest

下面是一条能让元素变得可拖拽的指令。

index.html

    <!doctype html>
    <html ng-app="drag">
      <head>
        <script src="http://code.angularjs.org/angular-1.1.0.min.js"></script>
        <script src="script.js"></script>
      </head>
      <body>
        <span draggable>Drag ME</span>
      </body>
    </html>

script.js

    angular.module('drag', []).
    directive('draggable', function($document) {
        var startX=0, startY=0, x = 0, y = 0;
        return function(scope, element, attr) {
          element.css({
           position: 'relative',
           border: '1px solid red',
           backgroundColor: 'lightgrey',
           cursor: 'pointer'
          });
          element.bind('mousedown', function(event) {
            startX = event.screenX - x;
            startY = event.screenY - y;
            $document.bind('mousemove', mousemove);
            $document.bind('mouseup', mouseup);
          });
    
          function mousemove(event) {
            y = event.screenY - startY;
            x = event.screenX - startX;
            element.css({
              top: y + 'px',
              left:  x + 'px'
            });
          }
    
          function mouseup() {
            $document.unbind('mousemove', mousemove);
            $document.unbind('mouseup', mouseup);
          }
        }
     });




## complier

## 注意事项

*   在Angular框架中，双美元符前缀$$表示这个变量被当作私有的来考虑，不应当在外部代码中调用。
*   Angular默认不使用基于值的脏检测的原因，用户需要显式设置这个标记去打开它。
*   

ng-controller
ng-model
ng-repeat
ng-src	因为浏览器载入页面时，同时也会请求载入图片，AngularJS在页面载入完毕时才开始编译，所以img中的src不能包含表达式。
ng-click
ng-bind

函数
filter
orderBy

内建服务
$scope
$http
$route

API
module.config
$routeProvider.when
$routeProvider.otherwise



