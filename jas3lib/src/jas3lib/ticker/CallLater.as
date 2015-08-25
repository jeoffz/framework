/**
 * Created by zhujiahe on 2015/8/22.
 */
package jas3lib.ticker {
    import flash.display.Stage;
    import flash.events.Event;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    public class CallLater {

        private static var _stage:Stage;
        private static var _curFrame:uint;
        private static var _uniqueCall:Dictionary;
        private static var _callsHead:LaterCallVar;
        private static var _callsTail:LaterCallVar;

        public static function init(stage:Stage):void {
            _stage = stage;
            _stage.addEventListener(Event.ENTER_FRAME,onEnterFrame);

            _curFrame = 0;
            _uniqueCall = new Dictionary(true);
            _callsHead = new LaterCallVar();
            _callsTail = _callsHead;
        }

        private static function checkInit():void {
            if(_stage == null) {
                throw new Error("CallLater.init must call first.");
            }
        }

        private static function onEnterFrame(event:Event):void {
            _curFrame++;
            var timestamp:uint = getTimer();

            var q:LaterCallVar, p:LaterCallVar, elapsed:uint;
            p = _callsHead;
            while(p.next) {
                q = p.next;
                elapsed = q.frameTag ? _curFrame : timestamp;
                if(q.delay <= elapsed) {
                    p.next = q.next;
                    if(q.unique) {
                        delete _uniqueCall[q.func];
                    }
                    if(q == _callsTail) { _callsTail = p; }
                    q.func.apply(null,q.funcParams);
                    disposeLaterCallVar(q);
                } else  {
                    p = p.next;
                }
            }
        }

        public static function delayCall(func:Function, funcParams:Array = null, delay:int = 50, unique:Boolean = false, frameTag:Boolean = false):void {
            checkInit();

            if(frameTag) {
                delay += _curFrame;
            } else {
                delay += getTimer();
            }

            var callVar:LaterCallVar;
            if(unique) {
                callVar = _uniqueCall[func];
                if(!callVar) {
                    callVar = createLaterCallVar();
                    _uniqueCall[func] = callVar;
                    _callsTail.next = callVar;
                    _callsTail = callVar;
                }
            } else {
                callVar = createLaterCallVar();
                _callsTail.next = callVar;
                _callsTail = callVar;
            }
            callVar.func = func;
            callVar.funcParams = funcParams;
            callVar.frameTag = frameTag;
            callVar.delay = delay;
            callVar.unique = unique;
        }

        public static function delayframeCall(func:Function, funcParams:Array = null, delayframe:int = 1, unique:Boolean = false):void {
            delayCall(func, funcParams, delayframe, unique, true);
        }

        public static function nextframeCall(func:Function, funcParams:Array = null):void {
            delayframeCall(func,funcParams,1,true);
        }

        private static var _pool:Array = new Array();
        private static const poolSize:int = 80;

        private static function createLaterCallVar():LaterCallVar {
            if(_pool.length > 0) {
                return _pool.pop() as LaterCallVar;
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
    public var frameTag:Boolean;
    public var unique:Boolean;

    public var next:LaterCallVar;

    public function dispose():void {
        func = null;
        funcParams = null;
        delay = 0;
        frameTag = false;
        unique = false;
        next = null;
    }
}
