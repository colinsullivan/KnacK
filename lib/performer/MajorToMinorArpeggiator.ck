/**
 *  @file       MajorToMinorArpeggiator.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      An arpeggiator that plays major notes when 
 *  happy <= 0.5.
 *  @extends    Arpeggiator
 **/
public class MajorToMinorArpeggiator extends Arpeggiator {
    
    /**
     *  @class      Inline functor for reacting to "happy"
     *  @extends    Aesthetic.AestheticCallback
     **/
    class HappyCallback extends Aesthetic.AestheticCallback {
        fun void call(Aesthetic a) {
            if(a.value() <= 0.5) {
                <<< "minor pitches" >>>;
                // minor
                this.pitches_midi([9, 11, 12, 14, 16, 17, 21, 23]);
            }
            else {
                <<< "major pitches" >>>;
                // major
                this.pitches_midi([12, 14, 16, 17, 19, 21, 23, 24]);
            }            
        }
    }
    HappyCallback happyCallback;
}