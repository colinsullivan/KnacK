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
     *  Master outputs will be Dyno's.
     **/
    Dyno @ outputs[];

    _initialize_audio();

    /**
     *  Change the overall gain of this instrument.
     *
     *  @param  aGain  The gain value [0.0 - 1.0]
     **/
    fun float gain(float aGain) {
        for(0 => int i; i < outputs.size(); i++) {
            outputs[i].gain(aGain);
        }
        return aGain;
    }

    // /**
    //  *  Get the overall gain of the instrument.
    //  **/
    // fun float gain() {
    //     return g.gain();
    // }


    fun float freq(float aFrequency) {
        Helpers.abstract_error("Instrument", "freq");
        return -1.0;
    }

    fun void play_note(float onVelocity, dur onDuration, float offVelocity, dur offDuration) {
        Helpers.abstract_error("Instrument", "play_note");
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
        }
    }

}