/**
 *  @file       import.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

string libDirectory;
if(me.args() == 0) {
    <<< "\n", "WARNING:\tNo lib directory specified, assuming `./lib`." >>>;
    "./lib" => libDirectory;
}
else if(me.args() == 1) {
    me.arg(0) => libDirectory;
}
else {
    <<< "\n", "ERROR:\tInvalid amount of arguments." >>>;
    me.exit();
}

[
    "Helpers.ck",
    "aesthetic/Aesthetic.ck",
    "aesthetic/Happy.ck",
    "score/Score.ck",
    "instrument/Instrument.ck",
    // "instrument/BassBalls.ck",
    // "instrument/Bubbly.ck",
    "performer/Performer.ck"
    // "performer/Arpeggiator.ck"
] @=> string toLoad[];

for(0 => int i; i < toLoad.size(); i++) {
    Machine.add(libDirectory+"/"+toLoad[i]);
}
