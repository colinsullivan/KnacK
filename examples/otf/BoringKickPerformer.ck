/**
 *  @file       BoringKickPerformer.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Basic performer that plays a kick drum
 *  on each beat at a given speed.
 *  @extends    Performer
 **/
public class BoringKickPerformer extends Performer {

    DistortedKick kick;
    this.instrument(kick);

    /**
     *  Play kick after each `noteDuration` amount
     *  of time.
     **/
    fun void play() {
        this.pre_play(); // super

        while(true) {
            spork ~ kick.playNote(1.0);

            this._noteDuration => now;
        }
    }
}

// BoringKickPerformer x;
// x.playTest();