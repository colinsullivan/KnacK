/**
 *  @file       Score.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Base `Score` class.
 *
 *  Handles overall operations of a performance.  Meant
 *  to be subclassed once per piece.
 *  
 **/
public class Score {
    /**
     *  Overall duration of the piece
     **/
    0::second => dur _duration;

    float _bpm;
    dur quarterNote;
    dur eighthNote;
    dur halfNote;

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
        quarterNote*2 => halfNote;

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

        <<< "Score.play():", "\n\t", "Playing all movements in order by default" >>>;

        for(0 => int i; i < _numMovements; i++) {
            _movements[i].duration() => dur movementDuration;

            <<< "Score.play():", "\n\t", "Playing movement ", i, " for a duration of ", movementDuration >>>;
            _movements[i].play();
            movementDuration => now;
        }
        <<< "Score.play():", "\n\t", "Finished playing all movements" >>>;

        // this.duration() => now;
    }

    /**
     *  @class  Base class for a section of a piece.
     **/
    public class Movement {

        /**
         *  Pointer to the score.
         **/
        Score @ _score;

        fun Score score(Score aScore) {
            aScore @=> _score;
            return _score;
        }

        fun Score score() {
            if(this._score == null) {
                <<< "\n", "ERROR: `Movement` has no `Score`." >>>;
                me.exit();
            }
            return _score;
        }

        /**
         *  Ratio of this movements duration to the 
         *  overall (score's) duration.
         **/
        float _durationRatio;

        /**
         *  Actual duration (will depend on score)
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
         *  score's duration.
         **/
        fun dur duration(float aRatio) {
            aRatio => this._durationRatio;
            this.calculate_duration();

            return this._duration;
        }

        /**
         *  Set the duration of this section by a `dur` value.  This
         *  will modify the duration of the `Score`, and
         *  the ratios of the other sections currently in the piece.
         *
         *  @param  aDuration  The duration of this section.
         **/
        fun dur duration(dur aDuration) {
            aDuration => this._duration;
            this.score().calculate_duration();

            return this._duration;
        }

        /**
         *  Should be called whenever duration of score or
         *  length of movement has changed, as well as when
         *  initially added to score.
         **/
        fun void calculate_duration() {
            this.score().duration() => dur scoreDuration;

            if(scoreDuration == 0::second) {
                <<< "\n", "WARNING: Score duration is 0" >>>;
            }

            scoreDuration*this._durationRatio => this._duration;
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
            Helpers.abstract_error("Score.Movement", "play");
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
        aMovement.score(this);
        1 +=> _numMovements;
        return aMovement;
    }

    /**
     *  Append a new performer to the list of performers
     **/
    // fun Performer add_performer(Performer aPerformer) {
    //     aPerformer.score(this);
    //     return aPerformer;
    // }

}