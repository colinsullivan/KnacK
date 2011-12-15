/**
 *  @file       run.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/

string otfExampleDirectory;
if(me.args() == 0) {
    <<< "\n", "WARNING:\tNo otf example directory specified, assuming `./examples/otf/`." >>>;
    "./examples/otf/" => otfExampleDirectory;
}
else if(me.args() == 1) {
    me.arg(0) => otfExampleDirectory;
}
else {
    <<< "\n", "ERROR:\tInvalid amount of arguments." >>>;
    me.exit();
}

[
    "DistortedKick.ck",
    "BoringKickPerformer.ck",
    "SinePoop.ck",
    "SinePoopsPerformer.ck",
    "otf.ck"
] @=> string toLoad[];

for(0 => int i; i < toLoad.size(); i++) {
    Machine.add(otfExampleDirectory+"/"+toLoad[i]+":"+otfExampleDirectory);
}