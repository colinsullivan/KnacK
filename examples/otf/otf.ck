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
 *  @extends    Score
 **/
class OtfDemo extends Score {

    // this.duration(20::second);
    this.bpm(60);

    BoringKickPerformer kickPerformer;
    kickPerformer.score(this);

    SinePoopsPerformer poopsPerformer;
    poopsPerformer.score(this);

    class BoringIntro extends Score.Movement {
        fun void play() {
            this.pre_play();
            this.score() $ OtfDemo @=> OtfDemo @ score;
            
            score.kickPerformer.noteDuration(score.quarterNote);
            spork ~ score.kickPerformer.play();
        }
    }
    BoringIntro intro;
    this.add_movement(intro);
    intro.duration(this.quarterNote*4*2); // 2 bars

    class BoringIntroWithSinePoops extends Score.Movement {
        fun void play() {
            this.pre_play();

            <<< "\n", "BoringIntroWithSinePoops.play()" >>>;
            this.score() $ OtfDemo @=> OtfDemo @ c;

            c.kickPerformer.noteDuration(c.eighthNote);
            spork ~ c.poopsPerformer.play();
        }
    }
    BoringIntroWithSinePoops boring;
    this.add_movement(boring);
    boring.duration(this.quarterNote*4*4); // 4 bars
}

OtfDemo demo;
demo.play();