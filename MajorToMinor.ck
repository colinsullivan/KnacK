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
a.octave(1);

Aesthetic happy;
happy.name("happy");
happy.value(1.0);

a.watch(happy);

// Arpeggiate in major for 3 seconds
spork ~ a.play();
3::second => now;
