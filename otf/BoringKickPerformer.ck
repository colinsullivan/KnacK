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
            60 => float TEMPO;
            (1/TEMPO)*1::minute => dur QUARTER_NOTE;

            spork ~ kick.play_note(0.0, 0::second, 0.0, 0::second);
            1*QUARTER_NOTE => now;
        }
    }
}