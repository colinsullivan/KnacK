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
public class Aesthetic {
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
        return aName => this._name;
    }

    /**
     *  Value of this aesthetic dimension [0 - 1]
     **/
    float _value;

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
        return aValue => _value;
    }

    /**
     *  Change event for when data changes.
     **/
    Event _change;
}