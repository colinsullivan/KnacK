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

    // this.duration(20::second);
    this.bpm(60);

    BoringKickPerformer kickPerformer;
    kickPerformer.conductor(this);

    SinePoopsPerformer poopsPerformer;
    poopsPerformer.conductor(this);

    class BoringIntro extends Conductor.Movement {
        fun void play() {
            this.pre_play();

            <<< "\n", "BoringIntro.play()" >>>;
            this.conductor() $ OtfDemo @=> OtfDemo @ c;
            
            c.kickPerformer.speed(c.quarterNote);
            spork ~ c.kickPerformer.play();
        }
    }
    BoringIntro intro;
    this.add_movement(intro);
    intro.duration(this.quarterNote*4*2); // 2 bars

    class BoringIntroWithSinePoops extends Conductor.Movement {
        fun void play() {
            this.pre_play();

            <<< "\n", "BoringIntroWithSinePoops.play()" >>>;
            this.conductor() $ OtfDemo @=> OtfDemo @ c;

            c.kickPerformer.speed(c.eighthNote);
            spork ~ c.poopsPerformer.play();
        }
    }
    BoringIntroWithSinePoops boring;
    this.add_movement(boring);
    boring.duration(this.quarterNote*4*4);
}

OtfDemo demo;
demo.play();