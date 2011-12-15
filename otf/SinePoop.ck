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

    /**
     *  Play note with default duration.
     **/
    fun void playNote(float onVelocity) {
        return this.playNote(onVelocity, 0.5::second, onVelocity, 0.5::second);
    }

    /**
     *  Play note with given velocity and duration.
     **/
    fun void playNote(float onVelocity, dur onDuration, float offVelocity, dur offDuration) {

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

SinePoop s;
s.playTest();
