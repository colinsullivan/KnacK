/**
 *  @file       Aesthetic.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Base class for all aesthetic objects.
 *  
 **/
public class Aesthetic extends Event {
    /**
     *  Name of this aesthetic
     **/
    string _name;

    /**
     *  get name
     **/
    fun string name() {
        return _name;
    }

    /**
     *  set name
     **/
    fun string name(string aName) {
        aName => this._name;
        this.broadcast();
        return aName;
    }

    /**
     *  Value of this aesthetic dimension [0 - 1]
     **/
    0.0 => float _value;

    /**
     *  Get value
     **/
    fun float value() {
        return _value;
    }

    /**
     *  Set value
     **/
    fun float value(float aValue) {
        aValue => _value;
        this.broadcast();
        return aValue;
    }

    /**
     *  @class      Base callback for handling an Aesthetic event broadcast.
     **/
    public class AestheticCallback {
        fun void call(Aesthetic a) {
            
        }
    }


    /**
     *  Bind method used by the outside world to bind a callback
     *  function object to this Aesthetic.
     **/
    fun void bind(AestheticCallback cb) {
        spork ~ _bind(cb);
    }

    /**
     *  Internal bind method which is sporked by above.
     **/
    fun void _bind(AestheticCallback cb) {
        this => now;

        cb.call(this);

        _bind(cb);
    }

}
