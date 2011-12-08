/**
 *  @file       Performer.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

/**
 *  Tests for and aesthetic stuffs.
 **/

fun void starting_test(string testName, string desiredResult) {
    <<< "\n", "Running test: ", testName, "\n\t", desiredResult, "\n" >>>;
}

/**
 *  A `Performer` should be able to watch an `Aesthetic` object for broadcasts.
 **/

starting_test("Performer watch aesthetic", "TestPerformer.aesthetic_reaction should be called in 1::second.");
class TestPerformer extends Performer {
    fun void aesthetic_reaction(Aesthetic a) {
        <<< "\t", "TestPerformer.aesthetic_reaction called" >>>;
        return;
    }
}
TestPerformer p;

Aesthetic a;
a.name("happy");

// Performer p is now watching the "happy" aesthetic
p.watch(a);
me.yield();

// Composition
1::second => now;
a.broadcast();
1::second => now;

/**
 *  A `Performer` should be informed whenever an `Aesthetic` it is 
 *  subscribed to changes.
 **/
starting_test("Performer react to happy value changing", "Performer should announce happy value in 1::second");
class TestReactPerformer extends TestPerformer {
    // When an aesthetic changes
    fun void aesthetic_reaction(Aesthetic a) {
        if(a.name() == "happy") {
            <<< "\t", "`happy` value changed to: ", a.value(), "\n" >>>;
        }
    }
}
TestReactPerformer reactPerformer;
reactPerformer.watch(a);
me.yield();

1::second => now;
a.value(0.5);
1::second => now;

