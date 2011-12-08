/**
 *  @file       Bubbly.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      A bubbly sounding synth
 *  @extends    Instrument
 **/
public class Bubbly extends Instrument {
    // ModalBar imp => g;
    // imp.freq(150);
    // imp.controlChange(16, 2);

    DelayA d/* => output*/;

    // Attack with tone
    Impulse imp => LPF f => Gain clean;

    imp => BPF attack => blackhole;

    attack.Q(8);

    Envelope attackLife => blackhole;

    attackLife.target(1);
    // attackLife.duration(0.05::second);
    fun void attack_life_modulate() {
        while(true) {
            attackLife.value() => float attackLifeValue;

            f.Q(15 + (attackLifeValue*50));
            // f.freq(attackLifeValue*880);
            1::samp => now;
            
        }
    }
    // spork ~ attack_life_modulate();

    f.Q(40);

    // BlowHole tone => clean;
    // tone.noiseGain(0.0);

    // tone.gain(0);

    // clean => d;


    // clean => outputs[0];
    // clean => outputs[1];

    d => Gain feedback => d;
    feedback.gain(0.5);
    

    // tone.gain(0.75);
    // f.gain(0.80);
    // tone.controlChange(16, 1);

    d.gain(0.5);
    d.max(2::second);
    d.delay(.33::second);

    fun void play_note(float onVelocity, dur onDuration, float offVelocity, dur offDuration) {
        imp.next(1.0);

        attackLife.keyOn();
        // tone.noteOn(onVelocity);

        // Play note in a random channel
        Std.rand2f(0.0, dac.channels()) $ int => int chan;
        clean => dac.chan(chan);

        onDuration => now;

        attackLife.keyOff();
        // tone.noteOff(offVelocity);
        offDuration => now;
        clean =< dac.chan(chan);
    }

    fun float freq(float aFrequency) {
        return f.freq(aFrequency);
        // attack.freq(aFrequency*2);
        // return tone.freq(aFrequency);
    }

    // HACK: Calling super methods does not work so this only works
    // because the parent "constructor" is guaranteed to be called first.
    // fun void _initialize_audio() {
        // super();
    // }

}