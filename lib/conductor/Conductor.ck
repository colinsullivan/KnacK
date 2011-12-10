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

    float _bpm;
    dur quarterNote;

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

    fun float bpm() {
        return _bpm;
    }
    fun float bpm(float aBpm) {
        aBpm => _bpm;

        (1/_bpm)*1::minute => quarterNote;

        return _bpm;
    }

    /**
     *  Determine if the movement durations are properly entered.
     **/
    fun void pre_play() {
        0 => float allLengths;
        for(0 => int i; i < _numMovements; i++) {
            _movements[i]._length +=> allLengths;
        }

        if(allLengths > 1) {
            <<< "\n", "ERROR: Lengths of movements do not add up to 1" >>>;
            me.exit();
        }
    }


    /**
     *  Begin playing the piece.
     **/
    // fun void _play() {        
    // }
    fun void play() {
        this.pre_play();

        <<< "Conductor.play():", "\n\t", "Playing all movements in order by default" >>>;

        for(0 => int i; i < _numMovements; i++) {
            _movements[i].duration() => dur movementDuration;

            <<< "Conductor.play():", "\n\t", "Playing movement ", i, " for a duration of ", movementDuration >>>;
            _movements[i].play();
            movementDuration => now;
        }
        <<< "Conductor.play():", "\n\t", "Finished playing all movements" >>>;

        // this.duration() => now;
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

        fun dur duration() {
            return _duration;
        }

        /**
         *  Should be called whenever duration of conductor or
         *  length of movement has changed, as well as when
         *  initially added to conductor.
         **/
        fun void calculate_duration() {
            this._conductor._duration*this._length => this._duration;
        }

        // fun void _play() {
            
        // }

        fun void play() {
            Helpers.abstract_error("Conductor.Movement", "play");
            // spork ~ this._play();
            // this.duration() => now;
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

    /**
     *  Append a new performer to the list of performers
     **/
    // fun Performer add_performer(Performer aPerformer) {
    //     aPerformer.conductor(this);
    //     return aPerformer;
    // }

}