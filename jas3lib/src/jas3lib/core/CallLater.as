/**
 * Created by zhujiahe on 2015/8/22.
 */
package jas3lib.core {
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    public class CallLater {

        private static var _stage:Stage;
        private static var _timestamp:uint;

        private static var _uniqueFrameCall:Dictionary;
        private static var _uniqueMillisecondCall:Dictionary;

        private static var _frameCallsHead:LaterCallVar;
        private static var _frameCallsTail:LaterCallVar;
        private static var _millisecondCallsHead:LaterCallVar;
        private static var _millisecondCallsTail:LaterCallVar;

        public static function init(stage:Stage):void {
            _stage = stage;
            _timestamp = getTimer();
            _stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);

            _uniqueFrameCall = new Dictionary(true);
            _uniqueMillisecondCall = new Dictionary(true);
            _frameCallsHead = new LaterCallVar();
            _frameCallsTail = _frameCallsHead;
            _millisecondCallsHead = new LaterCallVar();
            _millisecondCallsTail = _millisecondCallsHead;
        }

        private static function onEnterFrame(event:Event):void {
            var timestamp:uint = getTimer();
            var elapsedTime:uint = timestamp-_timestamp;
            _timestamp = timestamp;
            timeElapsed(elapsedTime);
        }

        private static function timeElapsed(elapsedTime:uint):void {
            var q:LaterCallVar, p:LaterCallVar;

            p = _frameCallsHead;
            while(p.next) {
                q = p.next;
                q.delay -= 1;
                if(q.delay <= 0) {
                    p.next = q.next;
                    if(q.unique) {
                        delete _uniqueFrameCall[q.func];
                    }
                    if(q == _frameCallsTail) {
                        _frameCallsTail = p;
                    }
                    q.func.apply(null,q.funcParams);
                    disposeLaterCallVar(q);
                } else  {
                    p = p.next;
                }
            }

            p = _millisecondCallsHead;
            while(p.next) {
                q = p.next;
                q.delay -= elapsedTime;
                if(q.delay <= 0) {
                    p.next = q.next;
                    if(q.unique) {
                        delete _uniqueMillisecondCall[q.func];
                    }
                    if(q == _millisecondCallsTail) {
                        _millisecondCallsTail = p;
                    }
                    q.func.apply(null,q.funcParams);
                    disposeLaterCallVar(q);
                } else  {
                    p = p.next;
                }
            }
        }

        public static function delayCall(func:Function, funcParams:Array = null, millisecond:int = 50, unique:Boolean = false):void {
            var callVar:LaterCallVar;
            if(unique) {
                callVar = _uniqueMillisecondCall[func];
                if(!callVar) {
                    callVar = createLaterCallVar();
                    _uniqueMillisecondCall[func] = callVar;
                    _millisecondCallsTail.next = callVar;
                    _millisecondCallsTail = callVar;
                }
            } else {
                callVar = createLaterCallVar();
                _millisecondCallsTail.next = callVar;
                _millisecondCallsTail = callVar;
            }
            callVar.func = func;
            callVar.funcParams = funcParams;
            callVar.delay = millisecond;
            callVar.unique = unique;
        }

        public static function delayframeCall(func:Function, funcParams:Array = null, frameCount:int = 1, unique:Boolean = false):void {
            var callVar:LaterCallVar;
            if(unique) {
                callVar = _uniqueFrameCall[func];
                if(!callVar) {
                    callVar = createLaterCallVar();
                    _uniqueFrameCall[func] = callVar;
                    _frameCallsTail.next = callVar;
                    _frameCallsTail = callVar;
                }
            } else {
                callVar = createLaterCallVar();
                _frameCallsTail.next = callVar;
                _frameCallsTail = callVar;
            }
            callVar.func = func;
            callVar.funcParams = funcParams;
            callVar.delay = frameCount;
            callVar.unique = unique;
        }

        public static function nextframeCall(func:Function, funcParams:Array = null):void {
            delayframeCall(func,funcParams,1,true);
        }

        private static var _pool:Array = new Array();
        private static const poolSize:int = 50;

        private static function createLaterCallVar():LaterCallVar {
            if(_pool.length > 0) {
                return _pool[_pool.length-1];
            } else {
                return new LaterCallVar();
            }
        }

        private static function disposeLaterCallVar(inst:LaterCallVar):void {
            if(_pool.length < poolSize) {
                inst.dispose();
                _pool.push(inst);
            }
            inst = null;
        }
    }
}

internal class LaterCallVar {
    public var func:Function;
    public var funcParams:Array;
    public var delay:int;
    public var unique:Boolean;

    public var next:LaterCallVar;

    public function dispose():void {
        func = null;
        funcParams = null;
        delay = 0;
        unique = false;
        next = null;
    }
}
