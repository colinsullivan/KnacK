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

    0 => float _bpm;
    dur noteDurations[8];
    dur quarterNote;

    /**
     *  One `Event` instance for each note duration, will be broadcasted
     *  on each metronome "tick".
     **/
    Event @ metroEvents[8];

    fun void broadcastMetroEvents(int index) {
        while(true) {
            metroEvents[index].broadcast();
            noteDurations[index] => now;
        }
    }


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

        this._calculate_note_durations();

        return _bpm;
    }
    // Default bpm
    // this.bpm(120);

    /**
     *  Should be called whenever bpm changes.
     **/
    fun void _calculate_note_durations() {
        (1/_bpm)*1::minute => quarterNote;

        // Calculate note durations and store in array indexed by string and
        // log base 2
        quarterNote*4   => noteDurations["1"]       => noteDurations[0];
        quarterNote*2   => noteDurations["1/2"]     => noteDurations[1];
        quarterNote     => noteDurations["1/4"]     => noteDurations[2];
        quarterNote/2   => noteDurations["1/8"]     => noteDurations[3];
        quarterNote/4   => noteDurations["1/16"]    => noteDurations[4];
        quarterNote/8   => noteDurations["1/32"]    => noteDurations[5];
        quarterNote/16  => noteDurations["1/64"]    => noteDurations[6];
        quarterNote/32  => noteDurations["1/128"]   => noteDurations[7];

        // Instantiate event object for each note duration so we can 
        // broadcast metronome events
        Event e   @=> metroEvents["1"]    @=> metroEvents[0];
        Event f   @=> metroEvents["1/2"]  @=> metroEvents[1];
        Event g   @=> metroEvents["1/4"]  @=> metroEvents[2];
        Event h   @=> metroEvents["1/8"]  @=> metroEvents[3];
        Event i   @=> metroEvents["1/16"] @=> metroEvents[4];
        Event j   @=> metroEvents["1/32"] @=> metroEvents[5];
        Event k   @=> metroEvents["1/64"] @=> metroEvents[6];
        Event l   @=> metroEvents["1/128"]@=> metroEvents[7];

    }

    /**
     *  Determine if the movement durations are properly entered.
     **/
    fun void pre_play() {
        // if(_bpm != 0 && _duration == 0::second) {
        //     return;
        // }

        0::samp => dur allDurations;
        for(0 => int i; i < _numMovements; i++) {
            _movements[i].duration() +=> allDurations;
        }

        if(allDurations != this.duration()) {
            Helpers.error_message("Durations of movements do not add up to score duration.");
        }

        if(_bpm == 0) {
            Helpers.warning_message("Score bpm has not been set, metronome events will not be triggered.");
        }

        // For each note duration, begin broadcasting events on metronome ticks.
        for(0 => int i; i < noteDurations.size(); i++) {
            spork ~ broadcastMetroEvents(i);
        }

    }


    /**
     *  Begin playing the piece.
     **/
    fun void play() {
        this.pre_play();

        <<< "Score.play():", "\n\t", "Playing all", _numMovements, "movements in order" >>>;

        for(0 => int i; i < _numMovements; i++) {
            _movements[i].duration() => dur movementDuration;

            <<< "Score.play():", "\n\t", "Playing movement", i, "for a duration of", movementDuration, "\n\t", "now:", now >>>;
            spork ~ _movements[i].play();
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
                Helpers.error_message("`Movement` has no `Score`.  Call `add_movement` on the score first.");
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
         *  Time this movement's `play` method was last called
         **/
        time _startTime;
        
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
                Helpers.warning_message("Score duration is 0");
            }

            scoreDuration*this._durationRatio => this._duration;
        }

        /**
         *  HACK: Used instead of `super`.  Should be called before
         *  `play`.
         **/
        fun void pre_play() {
            if(this.duration() == 0::second) {
                Helpers.error_message("Duration of section is 0");
                return;
            }

            now => _startTime;
        }

        /**
         *  Time remaining in this movement.
         **/
        fun dur remaining_duration() {
            _startTime+this.duration() => time endTime;

            return endTime-now;
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