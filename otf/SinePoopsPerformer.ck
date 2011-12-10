/**
 *  @file       SinePoopsPerformer.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Basic sine poops player adapted from Ge's demos.
 *  @extends    Performer
 **/
public class SinePoopsPerformer extends Performer {
    SinePoop s;
    this.instrument(s);

    this.scale([ 0, 2, 4, 7, 9 ]);

    fun void play() {
        <<< "SinePoopsPerformer.play" >>>;

        // Play a random note from the scale on each 8th note.
        while(true) {
            dur poopDuration;
            if( Std.randf() > -.5 ) {
                0.5*this.conductor().quarterNote => poopDuration;
            }
            else {
                0.25*this.conductor().quarterNote => poopDuration;
            }
            

            // get note class
            this.scale()[ Math.rand2(0,4) ] => float freq;
            // get the final freq    
            Std.mtof( 21.0 + (Std.rand2(1,4)*12 + freq) ) => float poopPitch;

            0.5 => float poopVelocity;
            s.freq(poopPitch);
            spork ~ s.play_note(poopVelocity, poopDuration/2, poopVelocity, poopDuration/2);

            poopDuration => now;
        }
    }
}