/**
 *  @file       Arpeggiator.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


/**
 *  @class      Performs an arpeggiation over a given
 *  set of mPitches using the given instrument.
 *  @extends    Performer
 **/
public class Arpeggiator extends Performer {


    /**
     *  Start playing.  Will begin looping arpeggiation
     **/
    fun void play() {
        while(true) {
            if(mPitches != null) {
                for(0 => int i; i < mPitches.size(); i++) {
                    mPitches[i]*pitchMultiplier => float freq;

                    instr.freq(freq);
                    instr.playNote(
                        0.5,
                        noteOnDuration,
                        0.5,
                        noteOffDuration
                    );
                }
            }
        }
    }
}