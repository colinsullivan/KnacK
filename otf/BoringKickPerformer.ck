/**
 *  @file       BoringKickPerformer.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      
 *  @extends    Performer
 **/
public class BoringKickPerformer extends Performer {

    DistortedKick kick;
    this.instrument(kick);

    /**
     *  Play kick on each quarter note.
     **/
    fun void play() {
        <<< "BoringKickPerformer.play" >>>;
        while(true) {
            spork ~ kick.play_note(0.0, 0::second, 0.0, 0::second);

            1*this.conductor().quarterNote => now;
        }
    }
}