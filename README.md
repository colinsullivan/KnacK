# Knack

KnacK is a music composition framework for the [ChucK](http://chuck.cs.princeton.edu/) programming language.  It encourages organization of components in a standard way, enabling easier re-use in later projects.

It was originally developed by Colin Sullivan during the Music 220A course at Stanford's CCRMA.

[github.com/colinsullivan/KnacK](https://github.com/colinsullivan/KnacK)

## Overview

KnacK is divided into 3 main components:

* Instruments
* Performers
* Score
* Aesthetics (high level data input)

### Instruments

An "Instrument" in KnacK is meant to encapsulate all unit generator functionality, and hide away anything that has to do with raw signal processing.  The obvious exception here is if control over a ugen parameter is to be given to the "Performer" of the instrument.

### Performers

A "Performer" in KnacK is the place where performance code is written, which can be anything from a general Arpeggiator which can play any `Instrument` subclass, to a performer of a specific instrument which manipulates specific parameters.

### Score

A "Score" in KnacK is a way to handle the high level transitions and events in a piece.  A `Score` subclass is meant to be instantiated once, and is the entry point for the program.

### Aesthetics

I have spent some time thinking about event handling, and how this can be used to allow `Performer` and `Instrument` instances to react to high-level "aesthetic" data.  The idea here is that the composer can have high-level metrics such as "darkness" or "density", which can be modified in the score directly, and all `Instrument` and `Performer` classes can react accordingly.  I am still in the process of determining the best way to accomplish this using function objects (I am used to functions as first class values), but some code can be found in `lib/aesthetic/` and `examples/MajorToMinor/`.

[https://ccrma.stanford.edu/~colinsul/projects/knack/Architecture_Overview.png](Overview of the entities in KnacK)

## Basic Example

Consider the following simple example (can be found in `examples/otf/`.  We have a `DistortedKick` which simply plays the `DistortedKick.aif` file when the `playNote` method is called:

```java
/**
 *  @class      A distorted kick sampler.
 *  @extends    Instrument
 **/
public class DistortedKick extends Instrument {
    
    SndBuf clip;

    string sampleDirectory;

    if(me.args() == 0) {
        "./" => sampleDirectory;
    }
    else {
        me.arg(0) => sampleDirectory;
    }

    clip.read(sampleDirectory+"/DistortedKick.aif");
    clip.pos(clip.samples());
    clip => this;

    fun void playNote(float onVelocity) {
        clip.pos(0);
        clip.length() => now;
    }
}
```

Then there is a `BoringKickPerformer` which instantiates a `DistortedKick`, and plays it on each beat.

```java
/**
 *  @class      Basic performer that plays a kick drum
 *  on each beat at a given speed.
 *  @extends    Performer
 **/
public class BoringKickPerformer extends Performer {

    DistortedKick kick;
    this.instrument(kick);

    /**
     *  Play kick after each `noteDuration` amount
     *  of time.
     **/
    fun void play() {
        this.pre_play(); // super

        while(true) {
            spork ~ kick.playNote(1.0);

            this._noteDuration => now;
        }
    }
}
```

To combine in a `Movement` of a score, we can instantiate this player, and tell it how frequently to play.

```java
class OtfDemo extends Score {

    ...

    BoringKickPerformer kickPerformer;
    kickPerformer.score(this);

    ...

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
    intro.duration(this.quarterNote*4*2); // Play for 2 bars
}
```

Then when an `OtfDemo` object is instantiated, and `play` is called on it, we will hear our beat play for the duration specified.