/**
 *  @file       ows.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/



/**
 *  Define the overall structure of the piece as follows:
 *
 *  |---------------------------------------------------|
 *  t=0                                          t=totalDuration
 *
 *  |---------------------------|
 *
 *          Intro (51.8%)
 *
 *                              |------|------|
 *                          
 *                               Climax center:
 *                                  (61.8%)
 *                               Climax width:
 *                                   (20%)
 *
 *                                            |---------|
 *
 *                                           Ending (28.2%)
 **/
class OWSCollage extends Conductor {

    60::second => _duration;

    class Intro extends Conductor.Movement {

        0.518 => _length;

        fun void play() {
            
        }
    }
    this.add_movement(new Intro);
}
OWSCollage piece;
piece.play();