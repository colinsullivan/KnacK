/**
 *  @file       test-Arpeggiator.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


/**
 *  This file contains tests for the `Arpeggiator` class.
 **/

Arpeggiator a;
a.instrument(Bubbly b);
[47, 44, 41, 38, 35, 32, 29, 26] @=> int descendingMinorThirds[];

a.speed(0.1::second);
a.octave(2);
a.pitches_midi(descendingMinorThirds);
spork ~ a.play();

3::second => now;