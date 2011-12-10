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
    0::second => dur _duration;

    float _bpm;
    dur quarterNote;
    dur eighthNote;

    /**
     *  List of movements in this piece.
     **/
    Movement @ _movements[10];
    0 => int _numMovements;

    /**
     *  Getter for duration of piece.
     **/
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
     *  This should be called when the duration of any sections
     *  are changed.
     **/
    fun void calculate_duration() {
        0::second => dur totalDuration;

        // Get total duration
        for(0 => int i; i < _numMovements; i++) {
            _movements[i].duration() +=> totalDuration;
        }

        totalDuration => this._duration;

        // Update ratios
        for(0 => int i; i < _numMovements; i++) {
            _movements[i].duration()/totalDuration => _movements[i]._durationRatio;
        }
    }

    fun float bpm() {
        return _bpm;
    }
    fun float bpm(float aBpm) {
        aBpm => _bpm;

        (1/_bpm)*1::minute => quarterNote;
        quarterNote/2 => eighthNote;

        return _bpm;
    }

    /**
     *  Determine if the movement durations are properly entered.
     **/
    fun void pre_play() {
        0 => float allLengths;
        for(0 => int i; i < _numMovements; i++) {
            _movements[i]._durationRatio +=> allLengths;
        }

        if(allLengths > 1) {
            <<< "\n", "ERROR: Lengths of movements do not add up to 1" >>>;
            me.exit();
        }
    }


    /**
     *  Begin playing the piece.
     **/
    fun void play() {
        this.pre_play();

        <<< "Conductor.play():", "\n\t", "Playing all movements in order by default" >>>;

        for(0 => int i; i < _numMovements; i++) {
            _movements[i].duration() => dur movementDuration;

            <<< "Conductor.play():", "\n\t", "Playing movement ", i, " for a duration of ", movementDuration >>>;
            _movements[i].play();
            movementDuration + (now % this.quarterNote) => now;
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
            return _conductor;
        }

        fun Conductor conductor() {
            if(this._conductor == null) {
                <<< "\n", "ERROR: `Movement` has no `Conductor`." >>>;
                me.exit();
            }
            return _conductor;
        }

        /**
         *  Ratio of this movements duration to the 
         *  overall (conductor's) duration.
         **/
        float _durationRatio;

        /**
         *  Actual duration (will depend on conductor)
         **/
        dur _duration;
        
        /**
         *  Getter for duration of this segment.
         **/
        fun dur duration() {
            return _duration;
        }
    
        /**
         *  Set the duration of this section by a ratio of the total
         *  duration.
         *
         *  @param  aRatio  Ratio of this sections duration / total
         *  conductor's duration.
         **/
        fun dur duration(float aRatio) {
            aRatio => this._durationRatio;
            this.calculate_duration();

            return this._duration;
        }

        /**
         *  Set the duration of this section by a `dur` value.  This
         *  will modify the duration of the `Conductor`, and
         *  the ratios of the other sections currently in the piece.
         *
         *  @param  aDuration  The duration of this section.
         **/
        fun dur duration(dur aDuration) {
            aDuration => this._duration;
            this.conductor().calculate_duration();

            return this._duration;
        }

        /**
         *  Should be called whenever duration of conductor or
         *  length of movement has changed, as well as when
         *  initially added to conductor.
         **/
        fun void calculate_duration() {
            this.conductor().duration() => dur conductorDuration;

            if(conductorDuration == 0::second) {
                <<< "\n", "WARNING: Conductor duration is 0" >>>;
            }

            conductorDuration*this._durationRatio => this._duration;
        }

        /**
         *  HACK: Used instead of `super`.  Should be called before
         *  `play`.
         **/
        fun void pre_play() {
            if(this.duration() == 0::second) {
                <<< "\n", "WARNING: Duration of section is 0" >>>;
            }
        }

        fun void play() {
            Helpers.abstract_error("Conductor.Movement", "play");
            // spork ~ this._play();
            // this.duration() => now;
        }
    }

    /**
     *  Append a new movement to this piece.
     *
     *  @param  aMovement  `Movement` instance to add.
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