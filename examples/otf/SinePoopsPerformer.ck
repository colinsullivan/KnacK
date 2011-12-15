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
        <<< "\n", "SinePoopsPerformer.play()" >>>;
        this.pre_play();


        // Play a random note from the scale on each 8th note.
        while(true) {
            dur poopDuration;
            if( Std.randf() > -.5 ) {
                this.score().quarterNote/4 => poopDuration;
            }
            else {
                this.score().quarterNote/8 => poopDuration;
            }
            

            // get note class
            this.scale()[ Math.rand2(0,4) ] => float freq;
            // Play at a random octave
            this.octave(Std.rand2(2,5));

            // get the final freq    
            Std.mtof( 21.0 + (this.octave()*12 + freq) ) => float poopPitch;

            0.5 => float poopVelocity;
            s.freq(poopPitch);
            spork ~ s.playNote(poopVelocity, poopDuration/2, poopVelocity, poopDuration/2);

            poopDuration => now;
        }
    }
}