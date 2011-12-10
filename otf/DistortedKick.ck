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

    for(0 => int i; i < mChannels; i++) {
        clip => this.outputs[i];
    }

    clip.read("/Users/colin/Documents/Stanford/Courses/220a/hwfinal/otf/DistortedKick.aif");

    fun void play_note(float onVelocity, dur onDuration, float offVelocity, dur offDuration) {
        clip.pos(0);
        clip.length() => now;
    }
}