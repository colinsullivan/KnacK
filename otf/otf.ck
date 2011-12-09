/**
 *  @file       otf.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/



/**
 *  @class      
 *  @extends    Conductor
 **/
class OtfDemo extends Conductor {
    10::second => duration;

    BoringKickPerformer kickPerformer;

    class BoringIntro extends Conductor.Movement {
        1 => _length;

        fun void play() {
            <<< "BoringIntro.play()" >>>;
            this.conductor() $ OtfDemo @=> OtfDemo @ c;
            c.kickPerformer.play();
        }
    }
    BoringIntro intro;
    this.add_movement(intro);

    intro.play();
}

OtfDemo demo;

// SndBuf clip;
// clip.read("/Users/colin/Documents/Stanford/Courses/220a/hwfinal/otf/DistortedKick.aif");
// 1::second => now;
// clip.pos(0);
// clip.length() => now;