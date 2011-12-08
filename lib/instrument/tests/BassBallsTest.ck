/**
 *  @file       BassBalls.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

BassBalls b;

b => dac;

b.play_note(0.5, 0.5::second, 0.5, 0.5::second);