/**
 *  @file       BassBalls.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      An envelope followed FM synth.
 *  @extends    Instrument
 **/
public class BassBalls extends Instrument {
    Rhodey mRhodey => LPF mLpf => this;
    Envelope mEnv => blackhole;

    mEnv.target(1);
    mEnv.duration(0.25::second);

    880 => float mLpfBaseFreq;
    mLpf.freq(mLpfBaseFreq);
    mLpf.Q(9);


    /**
     *  This is where the amplitude following takes
     *  place.  It is constantly manipulating the
     *  frequency of `mLpf`, so when `mEnv.keyOn`
     *  is called, the envelope will effect this
     *  filter.
     **/
    function void modulate_rhodey() {
        while(true) {
            mEnv.value()*mLpfBaseFreq => mLpf.freq;

            1::samp => now;
        }
    }

    spork ~ modulate_rhodey();


    fun float lpf_freq(float newFreq) {
        newFreq => mLpfBaseFreq;
    }

    fun float freq(float aFrequency) {
        return mRhodey.freq(aFrequency);
    }

    fun void play_note(float onVelocity, dur onDuration, float offVelocity, dur offDuration) {
        mEnv.keyOn();
        mRhodey.noteOn(onVelocity);
        onDuration => now;

        mEnv.keyOff();
        offDuration => now;
        mRhodey.noteOff(offVelocity);

    }
}