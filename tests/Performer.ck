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
    <<< "\n", "Running test: ", testName, "\n\n\t", desiredResult >>>;
}

/**
 *  A `Performer` should be able to watch an `Aesthetic` object for broadcasts.
 **/

starting_test("Performer watch aesthetic", "TestPerformer.callback(Aesthetic) should be called in 1::second.");
class TestPerformer extends Performer {
    class TestPerformerAestheticCallbacks extends Performer.PerformerAestheticCallbacks {
        fun void callback(Aesthetic a) {
            <<< "\t", "TestPerformer.callback(Aesthetic)" >>>;
        }
    }
    new TestPerformerAestheticCallbacks @=> _aestheticCallbacks;
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
starting_test("Performer react to happy value changing", "TestReactPerformer should announce happy value in 1::second");

class DissonantAesthetic extends Aesthetic {
    "dissonant" => _name;
}

class TestReactPerformer extends TestPerformer {
    // When an aesthetic changes, use these callbacks
    class TestReactPerformerAestheticCallbacks extends Performer.PerformerAestheticCallbacks {
        fun void callback(DissonantAesthetic a) {
            a => now;
            <<< "\t", "TestReactPerformer.callback(DissonantAesthetic)" >>>;
            <<< "\t", "a.value(): ", a.value() >>>;
            callback(a);
        }
    }
    null @=> _aestheticCallbacks;
    TestReactPerformerAestheticCallbacks @ _aestheticCallbacks;
}

DissonantAesthetic dissonance;
TestReactPerformer reactPerformer;
// reactPerformer.watch(dissonance);
reactPerformer._aestheticCallbacks.callback(dissonance);
me.yield();

1::second => now;
dissonance.value(0.5);
1::second => now;

