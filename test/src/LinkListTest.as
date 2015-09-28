/**
 * Created by zhujiahe on 2015/8/22.
 */
package {
    import flash.display.Sprite;
    import flash.system.System;
    import flash.utils.getTimer;

    public class LinkListTest extends Sprite {
        public function LinkListTest() {
            super();

            var arr:Array = new Array();
            for (var i:int = 0; i < 100000; i++) {
                arr.push(i);
            }

            var time:uint = getTimer();
            var len:int = arr.length;
            while(arr.length) {
                arr.splice(0,1);
                len--;
            }
            trace(getTimer()-time);

            var head:LinkList = new LinkList();
            var p:LinkList = head,q:LinkList;
            for (var j:int = 0; j < 100000; j++) {
                q = new LinkList();
                q.value = j;
                p.next = q;
                p = q;
            }

//            System.gc();
            time = getTimer();
            p = head;
            while(p.next) {
                q = p.next;
//                trace(q.value);
                p.next = q.next;
            }
            System.gc();
            trace(getTimer()-time);
        }
    }
}

class LinkList {
    public var next:LinkList;
    public var value:Object;
}
