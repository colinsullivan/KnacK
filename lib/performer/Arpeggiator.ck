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
        this.pre_play();
        
        while(true) {
            if(_scale != null) {
                for(0 => int i; i < _scale.size(); i++) {
                    _scale[i] + this.octave()*12 => float freq;

                    instr.freq(freq);
                    instr.play_note(
                        0.5,
                        noteOnDuration,
                        0.5,
                        noteOffDuration
                    );
                }
            }
            else {
                me.yield();
            }
        }
    }
}