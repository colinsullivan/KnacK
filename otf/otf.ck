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

    this.duration(20::second);
    this.bpm(60);

    BoringKickPerformer kickPerformer;
    kickPerformer.conductor(this);

    SinePoopsPerformer poopsPerformer;
    poopsPerformer.conductor(this);

    class BoringIntro extends Conductor.Movement {
        0.25 => _length;

        fun void play() {
            <<< "BoringIntro.play()" >>>;
            this.conductor() $ OtfDemo @=> OtfDemo @ c;
            spork ~ c.kickPerformer.play();
        }
    }
    BoringIntro intro;
    this.add_movement(intro);

    class BoringIntroWithSinePoops extends Conductor.Movement {
        0.75 => _length;

        fun void play() {
            <<< "BoringIntroWithSinePoops.play()" >>>;
            this.conductor() $ OtfDemo @=> OtfDemo @ c;

            spork ~ c.poopsPerformer.play();
        }
    }
    this.add_movement(new BoringIntroWithSinePoops);
}

OtfDemo demo;
demo.play();

// SndBuf clip;
// clip.read("/Users/colin/Documents/Stanford/Courses/220a/hwfinal/otf/DistortedKick.aif");
// 1::second => now;
// clip.pos(0);
// clip.length() => now;