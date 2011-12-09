/*

This attempt works better than if statements, but we're still
not taking advantage of polymorphism for different event
callbacks.  It would be nice to have a single function 
object with multiple polymorphic `call` methods to 
handle different types of events.

*/

/**
 *  Event callback functor class.
 **/
class BaseEventCallback {
    fun void call(BaseEvent e) {
        
    }
}

/**
 *  Base event class.
 **/
class BaseEvent extends Event {

    /**
     *  Bind a callback to this event.
     **/
    fun void bind(BaseEventCallback cb) {
        this => now; // When event happens

        cb.call(this); // Fire callback

        bind(cb); // Wait for next time
    }
}

/**
 *  @class      Base class for an event handler.
 **/
public class EventWatcher {

}


/**
 *  @class      `BaseEvent` subclass for example.
 **/
class HappyEvent extends BaseEvent {

}

/**
 *  @class      Subclass for example.
 **/
class MyWatcher extends EventWatcher {

    class MyCallback extends BaseEventCallback {
        fun void call(BaseEvent e) {
            /**
             *  This is my primary issue with this approach,
             *  it would be nice not to have to cast the 
             *  `Event` object.
             **/
            e $ HappyEvent @=> HappyEvent @ e;
            <<< "\t", "MyWatcher.happyCallback.call(BaseEvent)" >>>;
        }

        fun void call(HappyEvent e) {
            /**
             *  It would be nice if this was called, but it isn't
             *  because the bind method is in the more general
             *  `BaseEvent` class.
             **/
            <<< "\t", "MyWatcher.happyCallback.call(HappyEvent)" >>>;
        }
    }
    MyCallback happyCallback;
}



MyWatcher c;
HappyEvent a;
spork ~ a.bind(c.happyCallback);

<<< "\n", "MyWatcher.happyCallback.callback(HappyEvent) should be called in one second:" >>>;
1::second => now;
a.broadcast();
1::second => now;
