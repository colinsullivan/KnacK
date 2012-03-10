/**
 *  @file       Instrument.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class  A base class for my own instruments.
 *
 *  Since it is not trivial to subclass `UGen` or
 *  `StkInstrument` in ChucK at the moment, and
 *  I need a common interface that I can subclass.
 **/
public class Instrument extends UGen {

    /**
     *  Current frequency of this instrument.  Presumably
     *  for the next note.
     **/
    float _freq;

    /**
     *  Getter and setter for frequency value.
     *
     *  @param  aFrequency  Frequency value to use.
     **/
    fun float freq(float aFrequency) {
        aFrequency => this._freq;
        return this.freq();
    }
    fun float freq() {
        return this._freq;
    }

    /**
     *  Begin playing note.
     **/
    fun void noteOn() {
        Helpers.abstract_error("Instrument", "noteOn()");
        return;
    }
    fun void noteOn(float aVelocity) {
        Helpers.abstract_error("Instrument", "noteOn(float)");
        return;
    }
    fun void noteOn(float aVelocity, dur onDuration) {
        Helpers.abstract_error("Instrument", "noteOn(float, dur)");
        return;
    }

    /**
     *  Stop playing note.
     **/
    fun void noteOff() {
        Helpers.abstract_error("Instrument", "noteOff()");
        return;
    }
    fun void noteOff(float aVelocity) {
        Helpers.abstract_error("Instrument", "noteOff(float)");
        return;
    }
    fun void noteOff(dur aDuration) {
        Helpers.abstract_error("Instrument", "noteOff(dur)");
        return;
    }

    /**
     *  TODO: Should these be in player?  If they have to do with time?
     **/

    dur _duration;
    fun float duration(dur aDuration) {
        aDuration => _duration;
    }

    /**
     *  Play a single note just given a velocity.
     *
     *  @param  noteVelocity  The velocity to use.
     **/
    fun void playNote(float onVelocity) {
        Helpers.abstract_error("Instrument", "playNote(float)");
        return;
    }

    /**
     *  Play a single note given a velocity and duration.
     *
     *  @param  noteVelocity  The velocity to use.
     *  @param  noteDuration  The duration to use.
     **/
    fun void playNote(float noteVelocity, dur noteDuration) {
        Helpers.abstract_error("Instrument", "playNote(float, dur)");
        return;
    }

    /**
     *  Play a single note with the given parameters.
     *
     *  @param  onVelocity      The attack of the note [0.0 - 1.0]
     *  @param  onDuration      The duration of the attack, if needed.
     *  @param  offVelocity     The velocity of the decay [0.0 - 1.0], if needed.
     *  @param  offDuration     The duration of decay, if needed.
     **/
    fun void playNote(float onVelocity, dur onDuration, float offVelocity, dur offDuration) {
        Helpers.abstract_error("Instrument", "playNote(float, dur, float, dur)");
        return;
    }

    /**
     *  Play a descending scale for testing purposes.
     **/
    fun void playTest() {
        return this.playTest(96, 1.0, 1::second);
    }

    fun void playTest(float noteVelocity, dur noteDuration) {
        return this.playTest(96, noteVelocity, noteDuration);
    }

    /**
     *  Play test scale given starting MIDI note and 
     *  velocity to use for notes. 
     *
     *  TODO: handle testing of playNote(float, dur, float, dur)
     *
     *  @param  startingNote    Starting MIDI value.
     *  @param  noteVelocity    Velocity of note to use.
     *  @param  noteDuration    Duration for notes.
     **/
    
    fun void playTest(int startingNote, float noteVelocity, dur noteDuration) {
        0 => int i;
        while(i < 8) {
            Std.mtof(startingNote - 3*i++) => float freq;
            this.freq(freq);
            spork ~ this.playNote(noteVelocity, noteDuration);
            noteDuration => now;
        }
    }
}