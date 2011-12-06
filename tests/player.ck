/**
 *  @file       player.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  Tests for and aesthetic stuffs.
 **/
Player p;

Aesthetic a;
a.name("happy");
// a.value(1.0);

// Player p is now watching the "happy" aesthetic
p.watch(a);

// Composition
1::second => now;
a.broadcast();
5::second => now;