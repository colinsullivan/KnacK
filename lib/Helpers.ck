/**
 *  @file       Helpers.ck
 *
 *  @author     Colin Sullivan <colinsul [at] gmail.com>
 *
 *              Copyright (c) 2011 Colin Sullivan
 *              Licensed under the MIT license.
 **/


/**
 *  @class      Static helper functions.
 **/
public class Helpers {
    fun static void abstract_error(string className, string methodName) {
        Helpers.warning_message("Abstract method `"+className+"."+methodName+"` called.");
    }

    fun static void error_message(string msg) {
        <<< "[KnacK]: ERROR: ", msg >>>;
        Machine.crash();
    }
    fun static void warning_message(string msg) {
        <<< "[KnacK]: WARNING: ", msg >>>;
    }
}