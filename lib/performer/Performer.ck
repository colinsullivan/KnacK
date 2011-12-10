/**
 *  @file       Performer.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Base class for all performers.
 **/
public class Performer {
    /**
     *  Empty pointer to `Instrument` to play
     **/
    Instrument @ instr;

    /**
     *  Speed of notes
     **/
    dur noteOnDuration;
    dur noteOffDuration;

    /**
     *  Fastest note durations possible
     **/
    10::ms => dur minNoteDuration;

    /**
     *  Velocity of notes
     **/
    float noteOnVelocity;
    float noteOffVelocity;

    /**
     *  Array of pitch classes to be used by the 
     *  performer.
     **/
    int _scale[];

    /**
     *  Getter for pitch classes.
     **/
    fun int[] scale() {
        return _scale;
    }

    /**
     *  Set pitch classes.
     *
     *  @param  aScale  Set of pitches as integer semitones.
     **/
    fun int[] scale(int aScale[]) {
        aScale @=> _scale;

        return aScale;
    }

    /**
     *  Transpose all pitch class values by this integer times 12.
     **/
    0 => int _octave;

    /**
     *  Set the octave to perform at.
     **/
    fun int octave(int anOctaveValue) {
        anOctaveValue => _octave;

        return _octave;
    }

    /**
     *  Getter for octave value.
     **/
    fun int octave() {
        return _octave;
    }


    10 => int _nullWatchingPointers;
    Aesthetic @ _watching[10];

    /**
     *  Set the instrument for this `Performer`
     **/
    fun void instrument(Instrument anInstrument) {
        anInstrument @=> instr;
    }

    /**
     *  Reference to `Conductor` instance that is
     *  controlling this `Performer`.
     **/
    Conductor @ _conductor;

    /**
     *  Set the `Conductor` instance that controls
     *  this `Performer`.
     **/
    fun Conductor conductor(Conductor aConductor) {
        aConductor @=> this._conductor;
        return aConductor;
    }

    fun Conductor conductor() {
        return _conductor;
    }

    /**
     *  Set the duration of the playing notes.
     *
     *  @param  aDuration  Duration to use for `noteOnDuration`
     *  and `noteOffDuration`.
     **/
    fun void speed(dur aDuration) {
        // Check for minimum duration.  You probably don't want a
        // note duration of zero.
        if(aDuration < minNoteDuration) {
            minNoteDuration => aDuration;
        }
        aDuration => noteOnDuration => noteOffDuration;
    }

    /**
     *  Must be called before `play`.  HACK: Used instead of `super`.
     **/
    fun void pre_play() {
        // Synchronize to conductor's quarter note
        this.conductor().quarterNote => dur syncDuration;

        // Time remaining until next quarter note
        (now % syncDuration) => dur remainingTime;

        // If we're not directly on the quarter note
        // boundary, we'll have to wait until the next one.
        if(remainingTime != 0::second) {
            syncDuration - remainingTime => now;
        }
    }

    /**
     *  Begin performing.  Should likely be sporked.
     **/
    fun void play() {
        Helpers.abstract_error("Performer", "play");
    }

    fun void _watch(Aesthetic a) {
        a => now; // When a does something
        spork ~ aesthetic_reaction(a); //react
        // Handle event next time
        _watch(a);
    }

    fun void watch(Aesthetic a) {

        /**
         *  Add a to the list of aesthetics we are watching.
         **/
        a @=> _watching[a.name()];

        1 -=> _nullWatchingPointers;

        if(_nullWatchingPointers == 0) {
            _watching.size() => _nullWatchingPointers;
            _watching.size(_watching.size()*2);
        }

        // aesthetic_reaction(a);

        /**
         *  Handle event when it comes in
         **/
        spork ~ _watch(a);
    }

    fun void unwatch(Aesthetic a) {
        
    }

    /**
     *  Override this in subclasses and analyze `a.name()`
     *  to determine what actions to take.  TODO: This can
     *  probably be done in a cleaner way with functors
     *  but I'm not sure how.
     **/
    fun void aesthetic_reaction(Aesthetic a) {
        <<< "\n", "Performer.aestheticReaction:" >>>;
        <<< "\ta.name(): ", a.name() >>>;

        return;
    }

}