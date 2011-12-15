/**
 *  @file       Bell.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  @class      Bell instrument
 *  @extends    Instrument
 **/
public class Bell extends Instrument {

    // Partials
    SinOsc partials[8];
    // Max gain values for each partial
    [
        1.0,
        0.8,
        0.5,
        1/3,
        0.25,
        0.2,
        2/3,
        0.142
    ] @=> float partialGain[];
    // Current base frequency values for each partial
    float partialFreqs[8];

    // Frequency modulator
    SinOsc frequencyModulator => blackhole;
    frequencyModulator.freq(10);

    // Delay
    // DelayA delay => outputsAll;
    // delay.max(10::second);
    // delay.delay(1::second);

    // Gain delayFeedback;
    // delayFeedback.gain(0.33);
    // delay => delayFeedback => delay;

    // Amplitude modulation for each partial
    // Gain partialTremolo[8];

    for(0 => int i; i < partials.size(); i++) {
    //     // partials[i] => partialTremolo[i] => outputsAll;
        partials[i] => outputsAll;
    //     // partials[i] => delay;
        
    //     ((partials.size()$float/i$float)/partials.size()$float)*(1/partials.size()) => partialGain[i];
    //     // 1.0 => partialGain[i];

    //     <<< "partialGain["+i+"]:" >>>;
    //     <<< partialGain[i] >>>;
    }
    // 1.0 => partialGain[0];

    outputsAll.gain(0.125);

    // Amplitude modulation
    // SinOsc tremolo => blackhole;

    // tremolo.freq(10);
    // tremolo.gain(1);

    // Modulate amplitudes of all sine waves.
    // fun void modulate() {
    //     while(true) {
    //         0.8*(tremolo.last()+1) => float tremoloGain;

    //         sTremolo.gain(tremoloGain);

    //         for(0 => int i; i < partials.size(); i++) {
    //             partialTremolo[i].gain(tremoloGain);
    //         }
    //         1::samp => now;            
    //     }
    // }
    // spork ~ modulate();

    // Frequency modulation
    fun void modulate_partials() {
        while(true) {
            // Amount to modulate frequency
            0.0025*frequencyModulator.last()+1 => float modulationAmt;
            // for each partial
            for(0 => int i; i < partials.size(); i++) {
                partials[i].freq(modulationAmt*partialFreqs[i]);
            }
            1::samp => now;
        }
    }

    spork ~ modulate_partials();


    fun void playNote(float onVelocity) {

        // tremolo.phase(0);
        frequencyModulator.phase(0);
        
        for(0 => float i; i < 1; 0.002 +=> i) {
            Math.pow(i, 3.0) => float v;
            // s.gain(v);

            for(0 => int j; j < partials.size(); j++) {
                partials[j].gain(partialGain[j]*v);
            }

            // tremolo.gain(Math.pow(i, 4));

            1::samp => now;
        }
        // onDuration => now;

        for(1 => float i; i > 0; 0.000009 -=> i) {
            float v;
            // if (1.0 - i < 0.001)
            // {
            //     1.0 => v;
            // }
            // else {
                -1.0 * (Math.sqrt(1.0 - Math.pow(i, 4.0)) - 1.0) => v;
            // }
            // Math.sqrt(1.0 - Math.pow(i - 1.0, 6.0)) => float v;
            // Math.pow(i - 1, 3.0) + 1 => float v;
            // s.gain(v);

            for(0 => int j; j < partials.size(); j++) {
                partials[j].gain(partialGain[j]*v);
            }

            // tremolo.gain(Math.pow(i, 4));

            1::samp => now;
        }
        // <<< "off" >>>;
        // offDuration => now;
    }

    fun float freq(float aFrequency) {
        // s.freq(aFrequency);

        for(0 => int i; i < partials.size(); i++) {
            aFrequency * Math.pow(2, i) => partialFreqs[i];
        }


    }

}

Bell n;
n.playTest();