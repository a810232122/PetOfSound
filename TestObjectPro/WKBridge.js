window.czcbApp || (function() {
                         
    var callbackPoll = {};
    var callableMethods = (window.callableMethods) || [];

    var JSAPI = {

        /**
         * 前端通知客户端的消息传递方法，
         * @param {String} func 消息方法
         * @param {Array} params 消息数据字段列表
         */
        call: function(func, params = []) {
            var callbackId = func + '_' + new Date().getTime() + (Math.random())
            var callback = params[params.length - 1]
            var message = {
                methodName: func,
                params: params,
                callbackId: callbackId
            }, retMessage = ''
                         
            //回调函数存储在回调函数池
            if ('function' === typeof callback) {
                callbackPoll[callbackId] = callback;
                //弹出函数
                params.pop()
            }

            try{
                retMessage = window.prompt.apply(window, [JSON.stringify(message)])
            }catch(e){
                window.console && console.error && console.error(e)
            }

            return retMessage
        },

        /**
         * 调用JS，客户端注入代码调用
         * @param {String} resp JSON字符串
         */
        _invokeJS: function (resp) {
            resp = JSON.parse(resp);
            
            if (resp.callbackId) {
                //对应客户端回调处理，根据回调ID获取回调函数
                var func = callbackPoll[resp.callbackId];
                
                //根据回调参数，决定回调函数是否销毁，默认销毁
                if (!(typeof resp.keepCallback == 'boolean' && resp.keepCallback)) {
                    delete callbackPoll[resp.callbackId];
                }
                
                //调用回调函数
                if ('function' === typeof func) {
                    setTimeout(function () {
                        func(resp.data);
                    }, 1);
                }
            }else if (resp.methodName) {
                //客户端触发前端消息，前端通过 document.addEventListener 监听处理。数据存放在事件对象的event.data中
                JSAPI._trigger(resp.methodName,  resp.data)
            }
        },

        /**
         * 客户端触发前端事件
         * @param {String} name 事件名称
         * @param {Object} data 事件数据
         */
        _trigger: function (name, data) {
            if (name) {
                var triggerEvent = function (name, data) {
                    //创建事件，触发事件
                    var evt = document.createEvent("Events");
                    evt.initEvent(name, false, true);
                    evt.data = data;
                    document.dispatchEvent(evt);
                };

                setTimeout(function () {
                    triggerEvent(name, data);
                }, 1);
            }
        }
    }

    /**
     * JSAPI消息机制初始化，标识前端与客户端消息机制已建立，并触发JSBridgeReady通知前端
     */
    JSAPI.init = function () {
        JSAPI.init = null;

        //注册客户端方法到全局变量上
        var methods = callableMethods || []
        var methodsLen = methods.length
        for(var i = 0; i < methodsLen; i++){
            JSAPI[methods[i]] = (function(i){
                return function(){
                    var args = [].slice.apply(arguments)
                    return JSAPI.call(methods[i], args)
                }
            })(i)
        }

        //建立JSBridgeReady事件对象
        var readyEvent = document.createEvent('Events');
        readyEvent.initEvent('JSBridgeReady', false, false);

        //在JSBridgeReady事件触发后，如果还有监听JSBridgeReady事件的处理（监听时立即回调）
        var docAddEventListener = document.addEventListener;
        document.addEventListener = function (name, func) {
            if (name === readyEvent.type) {
                setTimeout(function () {
                    func(readyEvent);
                }, 1);
            } else {
                docAddEventListener.apply(document, arguments);
            }
        };

        //触发ready事件
        document.dispatchEvent(readyEvent);
    }

    /**
    * DOM ready 事件
    * @param {Function} callback 回调函数
    */
    function onDOMReady(callback) {
        var readyRE = /complete|loaded|interactive/;

        if (readyRE.test(document.readyState)) {
            setTimeout(function() {
                callback();
            }, 1);
        } else {
            document.defaultView.addEventListener('DOMContentLoaded', function () {
                callback();
            }, false);
        }
    }

    //对外绑定暴露全局对象
    window.czcbApp = JSAPI;

    //初始化触发JSBridgeReady事件
    onDOMReady(JSAPI.init);

})();
