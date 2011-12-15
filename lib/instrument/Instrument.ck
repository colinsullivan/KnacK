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
     *  Amount of channels to use for this instrument
     **/
    dac.channels() => int mChannels;

    /**
     *  Master outputs for each channel will be Dyno's.
     **/
    Dyno @ outputs[];

    /**
     *  This gain goes to all outputs as a shortcut
     **/
    Gain outputsAll;

    /**
     *  Gain for each output will be the same.
     *  (outputsAll.gain should always be 1 TODO: Make this happen)
     **/
    float _gain;

    _initialize_audio();

    /**
     *  Change the overall gain of this instrument.
     *
     *  @param  aGain  The gain value [0.0 - 1.0]
     **/
    fun float gain(float aGain) {
        aGain => _gain;
        for(0 => int i; i < outputs.size(); i++) {
            outputs[i].gain(_gain);
        }
        return _gain;
    }

    fun float gain() {
        return _gain;
    }

    /**
     *  Abstract method for setting frequency value.
     *
     *  @param  aFrequency  Frequency value to use.
     **/
    fun float freq(float aFrequency) {
        Helpers.abstract_error("Instrument", "freq(float)");
        return -1.0;
    }

    /**
     *  Play a single note just given a velocity.
     *
     *  @param  onVelocity  The velocity to use.
     **/
    fun void playNote(float onVelocity) {
        Helpers.abstract_error("Instrument", "playNote(float)");
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
     *  Create a `Dyno` object for each output channel.
     **/
    fun void _initialize_audio() {
        // Create `Dyno` objects for each output channel
        Dyno outputs[mChannels] @=> this.outputs;

        // For each output channel
        for(0 => int i; i < mChannels; i++) {
            // Turn limiter on
            outputs[i].limit();

            // Connect to proper dac channel
            outputs[i] => dac.chan(i);

            outputsAll => outputs[i];
        }

        this.gain(1.0);
    }

    /**
     *  Play a descending scale for testing purposes.
     **/
    fun void playTest() {
        return this.playTest(96, 1.0);
    }

    /**
     *  Play test scale given starting MIDI note and 
     *  velocity to use for notes. 
     *
     *  TODO: handle testing of playNote(float, dur, float, dur)
     *
     *  @param  startingNote  Starting MIDI value.
     *  @param  noteVelocity  Velocity of note to use.
     **/
    
    fun void playTest(int startingNote, float noteVelocity) {
        0 => int i;
        while(i < 8) {
            Std.mtof(startingNote - 3*i++) => float freq;
            this.freq(freq);
            spork ~ this.playNote(noteVelocity);
            1::second => now;
        }
    }
}