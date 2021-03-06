/**
 *  @file       DistortedKick.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      A distorted kick sampler.
 *  @extends    Instrument
 **/
public class DistortedKick extends Instrument {
    
    SndBuf clip;

    string sampleDirectory;

    if(me.args() == 0) {
        "./" => sampleDirectory;
    }
    else {
        me.arg(0) => sampleDirectory;
    }

    clip.read(sampleDirectory+"/DistortedKick.aif");
    clip.pos(clip.samples());
    clip => outputsAll;

    fun void playNote(float onVelocity) {
        clip.pos(0);
        clip.length() => now;
    }
}

// DistortedKick x;
// x.playTest();