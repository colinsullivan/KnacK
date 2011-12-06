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
        <<< "\n", "WARNING: Abstract method `"+className+"."+methodName+"` called.", "\n" >>>;
    }
}