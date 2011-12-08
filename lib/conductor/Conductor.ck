/**
 *  @file       Conductor.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Base `Conductor` class.
 *
 *  Handles overall operations of a performance.  Meant
 *  to be subclassed once per piece.
 *  
 **/
public class Conductor {
    /**
     *  Overall duration of the piece
     **/
    dur _duration;

    /**
     *  List of movements in this piece.
     **/
    Movement @ _movements[10];
    0 => int _numMovements;

    fun dur duration() {
        return _duration;
    }
    fun dur duration(dur aDuration) {
        aDuration => _duration;

        /**
         *  Calculate duration for movements.
         **/
        for(0 => int i; i < _numMovements; i++) {
            _movements[i].calculate_duration();
        }

        return _duration;
    }

    /**
     *  Begin playing the piece.
     **/
    fun void play() {
        Helpers.abstract_error("Conductor", "play");
    }

    /**
     *  @class  Base class for a section of a piece.
     **/
    public class Movement {

        /**
         *  Pointer to the conductor.
         **/
        Conductor @ _conductor;

        fun Conductor conductor(Conductor aConductor) {
            aConductor @=> _conductor;

            this.calculate_duration();

            return _conductor;
        }

        fun Conductor conductor() {
            return _conductor;
        }

        /**
         *  Length of this movement
         *  (fraction of the conductor's duration)
         **/
        float _length;

        /**
         *  Actual duration (will depend on conductor)
         **/
        dur _duration;

        /**
         *  Should be called whenever duration of conductor or
         *  length of movement has changed, as well as when
         *  initially added to conductor.
         **/
        fun void calculate_duration() {
            this._conductor._duration*this._length => this._duration;
        }

        fun void play() {
            Helpers.abstract_error("Conductor.Movement", "play");
        }
    }

    /**
     *  Append a new movement to this piece.
     **/
    fun Movement add_movement(Movement aMovement) {
        aMovement @=> _movements[_numMovements];
        aMovement.conductor(this);
        1 +=> _numMovements;
        return aMovement;
    }

}