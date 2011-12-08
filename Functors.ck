/**

My goal is the interface at the bottom of the file:
    
    MyWatcher c;
    HappyEvent a;
    spork ~ c.watch(a);
 
When this `watch` method is called, the `MyWatcher` instance `c` should handle the call to
 
    a.broadcast();
 
by calling its `callback` method which takes a `HappyEvent` object as a parameter.

Unfortunately this doesn't work because when the `HappyEvent` instance is being sent into the `watch` method, it is cast to an `Event` type, which is then used to determine which polymorphic callback method to use.  This is proven with the commented out second callback method in `EventCallbacks`, which yields the same result when un-commented.

To run:
    
    chuck Functors.ck

Output:

    MyWatcher._eventCallbacks.callback(HappyEvent) should be called in one second: 
        EventCallbacks._eventCallbacks.callback(Event)

 **/




/**
 *  @class      Base abstract functor class.
 *
 *  This should be used for creating callbacks for
 *  events.  Ideally, subclasses of this would 
 *  be able to override the `callback` method with 
 *  different `Event` types.
 **/
class EventCallbacks {
    fun void callback(Event a) {
        <<< "\t", "EventCallbacks._eventCallbacks.callback(Event)" >>>;
    }
    // fun void callback(HappyEvent a) {
    //     <<< "\t", "EventCallbacks._eventCallbacks.callback(HappyEvent)" >>>;
    // }

}

/**
 *  @class      Base class for an event handler.
 **/
public class EventWatcher {
    /**
     *  Pointer to new instance of `EventCallbacks`
     *  (or subclass).  Subclasses should instantiate proper
     *  type.
     **/
    new EventCallbacks @=> EventCallbacks @ _eventCallbacks;

    fun void watch(Event a) {
        a => now; // When a fires
        // Handle event
        spork ~ _eventCallbacks.callback(a); //react
        // Handle event again next time
        watch(a);
    }
}

/**
 *  @class      `Event` subclass for example.
 **/
class HappyEvent extends Event {

}

/**
 *  @class      Subclass for example.
 **/
class MyWatcher extends EventWatcher {

    /**
     *  @class  Our own event callbacks.
     *  Overloaded `callback` method is used for
     *  different types of events.
     **/
    class MyCallbacks extends EventCallbacks {
        fun void callback(HappyEvent a) {
            <<< "\t", "MyWatcher._eventCallbacks.callback(HappyEvent)" >>>;
        }
    }
    new MyCallbacks @=> _eventCallbacks;

    fun void watch(HappyEvent a) {
        a => now; // When a fires
        // Handle event
        spork ~ _eventCallbacks.callback(a); //react
        // Handle event again next time
        watch(a);
    }

}



MyWatcher c;
HappyEvent a;
spork ~ c.watch(a);

<<< "\n", "MyWatcher._eventCallbacks.callback(HappyEvent) should be called in one second:" >>>;
1::second => now;
a.broadcast();
1::second => now;
