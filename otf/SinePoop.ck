/**
 *  @file       SinePoop.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


/**
 *  @class      Basic sine poops from Ge's demos.
 *  @extends    Instrument
 **/
public class SinePoop extends Instrument {

    SinOsc s => Envelope e => outputs[0];
    e => outputs[1];


    .5 => float sGain;
    e.duration(0.01::second);


    fun void play_note(float onVelocity, dur onDuration, float offVelocity, dur offDuration) {

        s.gain(this.sGain*onVelocity);
        s.phase(0);
        e.keyOn();
        onDuration => now;

        e.keyOff();
        offDuration => now;
    }

    fun float freq(float aFreq) {
        return s.freq(aFreq);
    }
}

// SinePoop s;
// s.freq(440);
// spork ~ s.play_note(1, 0.25::second, 1, 0.25::second);
// 3::second => now;
