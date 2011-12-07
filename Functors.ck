/**
 *  @class      
 **/
class AestheticCallbacks {
    fun void callback(int i) {
        <<< "AestheticCallbacks.callback(int)" >>>;
    }
    fun void callback(float j) {
        <<< "AestheticCallbacks.callback(float)" >>>;
    }
}

/**
 *  @class      
 **/
class APIClass {
    AestheticCallbacks @ _aestheticCallbacks;

    fun void register(AestheticCallbacks @ someCallbacks) {
        someCallbacks @=> _aestheticCallbacks;

        <<< "In one second, callback int should be fired" >>>;
        1::second => now;
        _aestheticCallbacks.callback(5);

        <<< "In one second, callback float should be fired" >>>;
        1::second => now;
        _aestheticCallbacks.callback(0.5);
    };
}

// -- implementation
/**
 *  @class      
 *  @extends    APIClassCallback
 **/
// public class MyCallback extends AestheticCallbacks {
//     fun void callback(int i) {
//         <<< i >>>;
//     }
// }
APIClass c;
AestheticCallbacks callbacks;
c.register(callbacks);
