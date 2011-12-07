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
     *  Amount to multiply pitch by
     **/
    1 => float pitchMultiplier;

    /**
     *  Array of pitches to be used by performer.
     **/
    float mPitches[];

    /**
     *  `Aesthetic` objects we are currently watching.
     **/
    10 => int _nullWatchingPointers;
    Aesthetic @ _watching[10];

    /**
     *  @class      Function obj. with callbacks
     *  for various `Aesthetic` types.
     **/
    public class PerformerAestheticCallbacks {
        fun void callback(Aesthetic a) {
            <<< "PerformerAestheticCallbacks.callback(Aesthetic)" >>>;
        }
    };

    /**
     *  Pointer to instance of `PerformerAestheticCallbacks`
     *  (or subclass).  Subclasses should instantiate proper
     *  type.
     **/
    new PerformerAestheticCallbacks @=> PerformerAestheticCallbacks @ _aestheticCallbacks;



    /**
     *  Transpose all pitches by the given octave.
     **/
    fun void octave(int aOctaveValue) {
        Math.pow(2, aOctaveValue) => pitchMultiplier;
    }

    /**
     *  Set the instrument for this `Performer`
     **/
    fun void instrument(Instrument anInstrument) {
        anInstrument @=> instr;
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
     *  Begin performing.  Should likely be sporked.
     **/
    fun void play() {
        Helpers.abstract_error("Performer", "play");
    }

    /**
     *  Set the pitches for this performer via an array
     *  of MIDI note values.
     *
     *  @param  midiPitches  The MIDI note values to
     *  arpeggiate over.
     **/
    fun void pitches_midi(int midiPitches[]) {
        midiPitches.size() => int numPitches;

        // If amount of pitches is different from what is currently
        // allocated
        if(mPitches == null || numPitches != mPitches.size()) {
            // Allocate a new array
            new float [numPitches] @=> mPitches;
            // newPitches @=> mPitches;
        }

        for(0 => int i; i < mPitches.size(); i++) {
            Std.mtof(midiPitches[i]) => mPitches[i];
        }
    }

    /**
     *  Set the pitches for this performer via an array
     *  of pitches in Hz.
     *
     *  @param  newPitches  The pitches to use (in Hz).
     **/
    fun void pitches(float newPitches[]) {
        newPitches @=> mPitches;
    }

    fun void _watch(Aesthetic a) {
        a => now; // When a does something
        spork ~ _aestheticCallbacks.callback(a); //react
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
}