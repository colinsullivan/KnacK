/**
 *  @file       MajorToMinor.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


/**
 *  Our Bubbly Synth
 **/
Bubbly b;

/**
 *  Our MajorToMinorArpeggiator
 **/
MajorToMinorArpeggiator a;
a.instrument(b);
a.speed(0.1::second);
a.octave(4);

// [47, 44, 41, 38, 35, 32, 29, 26] @=> int descendingMinorThirds[];
// a.pitches_midi(descendingMinorThirds);

Aesthetic happy;
happy.name("happy");

a.watch(happy);
me.yield();

spork ~ a.play();

<<< "setting happy value to 1.0" >>>;
happy.value(1.0);
3::second => now;

<<< "setting happy value to 0.1" >>>;
happy.value(0.1);
3::second => now;