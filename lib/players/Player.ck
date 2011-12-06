/**
 *  @file       Player.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Base class for handling playing of instruments.
 **/
public class Player {

    fun void _watch(Aesthetic a) {
        a => now; // When a does something
        aestheticReaction(a); //react
    }

    fun void watch(Aesthetic a) {

        /**
         *  Add a to the list of aesthetics we are watching.
         **/
        // a => _watching[];

        /**
         *  Handle event when it comes in
         **/
        spork ~ _watch(a);
        
    }

    /**
     *  Override this in subclasses using polymorphic
     *  arguments as handlers for different subclasses
     *  of `Aesthetic`.
     **/
    fun void aestheticReaction(Aesthetic a) {
        <<< a.name() >>>;
    }

    10 => int _watchingSize;
    0 => int _watchingLast;
    Aesthetic @ _watching[_watchingSize];
}