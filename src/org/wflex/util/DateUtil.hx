///////////////////////////////////////////////////////////////////////////////
//
// © Copyright wflex.org 2017-present.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
///////////////////////////////////////////////////////////////////////////////

package org.wflex.util;

import openfl.errors.Error;

/**
* 	Class that contains static utility methods for manipulating and working
*	with Dates.
*
*/
class DateUtil
{
    
    /**
    *	Returns a two digit representation of the year represented by the
    *	specified date.
    *
    * 	@param d The Date instance whose year will be used to generate a two
    *	digit string representation of the year.
    *
    * 	@return A string that contains a 2 digit representation of the year.
    *	Single digits will be padded with 0.
    *
    */
    public static function getShortYear(d : Date) : String
    {
        var dStr : String = Std.string(d.getFullYear());
        
        if (dStr.length < 3)
        {
            return dStr;
        }
        
        return (dStr.substr(dStr.length - 2));
    }
    
    /**
    *	Compares two dates and returns an integer depending on their relationship.
    *
    *	Returns -1 if d1 is greater than d2.
    *	Returns 1 if d2 is greater than d1.
    *	Returns 0 if both dates are equal.
    *
    * 	@param d1 The date that will be compared to the second date.
    *	@param d2 The date that will be compared to the first date.
    *
    * 	@return An int indicating how the two dates compare.
    *
    * 	@langversion ActionScript 3.0
    *	@playerversion Flash 9.0
    *	@tiptext
    */
    public static function compareDates(d1 : Date, d2 : Date) : Int
    {
        var d1ms : Float = d1.getTime();
        var d2ms : Float = d2.getTime();
        
        if (d1ms > d2ms)
        {
            return -1;
        }
        else
        {
            if (d1ms < d2ms)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }
    
    /**
    *	Returns a short hour (0 - 12) represented by the specified date.
    *
    *	If the hour is less than 12 (0 - 11 AM) then the hour will be returned.
    *
    *	If the hour is greater than 12 (12 - 23 PM) then the hour minus 12
    *	will be returned.
    *
    * 	@param d1 The Date from which to generate the short hour
    *
    * 	@return An int between 0 and 13 ( 1 - 12 ) representing the short hour.
    *
    * 	@langversion ActionScript 3.0
    *	@playerversion Flash 9.0
    *	@tiptext
    */
    public static function getShortHour(d : Date) : Int
    {
        var h : Int = d.getHours();
        
        if (h == 0 || h == 12)
        {
            return 12;
        }
        else
        {
            if (h > 12)
            {
                return h - 12;
            }
            else
            {
                return h;
            }
        }
    }
    
    /**
    *	Returns a string indicating whether the date represents a time in the
    *	ante meridiem (AM) or post meridiem (PM).
    *
    *	If the hour is less than 12 then "AM" will be returned.
    *
    *	If the hour is greater than 12 then "PM" will be returned.
    *
    * 	@param d1 The Date from which to generate the 12 hour clock indicator.
    *
    * 	@return A String ("AM" or "PM") indicating which half of the day the
    *	hour represents.
    *
    * 	@langversion ActionScript 3.0
    *	@playerversion Flash 9.0
    *	@tiptext
    */
    public static function getAMPM(d : Date) : String
    {
        return ((d.getHours() > 11)) ? "PM" : "AM";
    }

    /**
    * Parses dates that conform to the W3C Date-time Format into Date objects.
    *
    * This function is useful for parsing RSS 1.0 and Atom 1.0 dates.
    *
    * @param str
    *
    * @returns
    *
    *
    * @see http://www.w3.org/TR/NOTE-datetime
    */
    public static function parseW3CDTF(str : String) : Date
    {
        var finalDate : Date = null;
        try
        {
            var dateStr : String = str.substring(0, str.indexOf("T"));
            var timeStr : String = str.substring(str.indexOf("T") + 1, str.length);
            var dateArr : Array<String> = dateStr.split("-");
            var year : Int = Std.parseInt(dateArr.shift());
            var month : Int = Std.parseInt(dateArr.shift());
            var date : Int = Std.parseInt(dateArr.shift());
            
            var multiplier : Int;
            var offsetHours : Int;
            var offsetMinutes : Int;
            var offsetStr : String;
            
            if (timeStr.indexOf("Z") != -1)
            {
                multiplier = 1;
                offsetHours = 0;
                offsetMinutes = 0;
                timeStr = StringTools.replace(timeStr, "Z", "");
            }
            else
            {
                if (timeStr.indexOf("+") != -1)
                {
                    multiplier = 1;
                    offsetStr = timeStr.substring(timeStr.indexOf("+") + 1, timeStr.length);
                    offsetHours = Std.parseInt(offsetStr.substring(0, offsetStr.indexOf(":")));
                    offsetMinutes = Std.parseInt(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
                    timeStr = timeStr.substring(0, timeStr.indexOf("+"));
                }
                else
                {
                    // offset is -
                    {
                        multiplier = -1;
                        offsetStr = timeStr.substring(timeStr.indexOf("-") + 1, timeStr.length);
                        offsetHours = Std.parseInt(offsetStr.substring(0, offsetStr.indexOf(":")));
                        offsetMinutes = Std.parseInt(offsetStr.substring(offsetStr.indexOf(":") + 1, offsetStr.length));
                        timeStr = timeStr.substring(0, timeStr.indexOf("-"));
                    }
                }
            }
            var timeArr : Array<String> = timeStr.split(":");
            var hour : Int = Std.parseInt(timeArr.shift());
            var minutes : Int = Std.parseInt(timeArr.shift());
            var secondsArr : Array<String> = ((timeArr.length > 0)) ? Std.string(timeArr.shift()).split(".") : null;
            var seconds : Int = ((secondsArr != null && secondsArr.length > 0)) ? Std.parseInt(secondsArr.shift()) : 0;

            var milliseconds : Int = ((secondsArr != null && secondsArr.length > 0)) ? 1000 * Std.int(Std.parseFloat("0." + secondsArr.shift())) : 0;

            #if (js || flash || php || cpp || python)

            var utc : Float = makeUtc(year, month - 1, date, hour, minutes, seconds, milliseconds);
            var offset : Float = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
            finalDate = Date.fromTime(utc - offset);

            #end
        }
        catch (e : Error)
        {
            var eStr : String = "Unable to parse the string [" + str + "] into a date. ";
            eStr += "The internal error was: " + Std.string(e);
            throw new Error(eStr);
        }
        return finalDate;
    }

	/**
		Retrieve Unix timestamp value from Date components. Takes same argument sequence as the Date constructor.
	**/
	public static #if (js || flash || php) inline #end function makeUtc(year : Int, month : Int, day : Int,
                                                                        ?hour : Int=0, ?min : Int=0, ?sec : Int=0, ?millis : Int=0):Float {
	    #if (js || flash || python)
		   return untyped Date.UTC(year, month, day, hour, min, sec, millis);
		#elseif php
		   return untyped __call__("gmmktime", hour, min, sec, month + 1, day, year) * 1000;
		#elseif cpp
		  return untyped __global__.__hxcpp_utc_date(year,month,day,hour,min,sec)*1000.0 ;
		#else
			//TODO
		   return 0.;
		#end
	}

    /**
    * Returns a date string formatted according to W3CDTF.
    *
    * @param d
    * @param includeMilliseconds Determines whether to include the
    * milliseconds value (if any) in the formatted string.
    *
    * @returns
    *
    * @langversion ActionScript 3.0
    * @playerversion Flash 9.0
    * @tiptext
    *
    * @see http://www.w3.org/TR/NOTE-datetime
    */
    public static function toW3CDTF(d : Date, includeMilliseconds : Bool = false) : String
    {
        var date : Float = d.getUTCDate();
        var month : Float = d.getUTCMonth();
        var hours : Float = d.getUTCHours();
        var minutes : Float = d.getUTCMinutes();
        var seconds : Float = d.getUTCSeconds();
        var milliseconds : Float = d.getUTCMilliseconds();
        var sb : String = new String();
        
        sb += d.getUTCFullYear();
        sb += "-";
        
        //thanks to "dom" who sent in a fix for the line below
        if (month + 1 < 10)
        {
            sb += "0";
        }
        sb += month + 1;
        sb += "-";
        if (date < 10)
        {
            sb += "0";
        }
        sb += date;
        sb += "T";
        if (hours < 10)
        {
            sb += "0";
        }
        sb += hours;
        sb += ":";
        if (minutes < 10)
        {
            sb += "0";
        }
        sb += minutes;
        sb += ":";
        if (seconds < 10)
        {
            sb += "0";
        }
        sb += seconds;
        if (includeMilliseconds && milliseconds > 0)
        {
            sb += ".";
            sb += milliseconds;
        }
        sb += "-00:00";
        return sb;
    }
    
    /**
     * Converts a date into just after midnight.
     */
    public static function makeMorning(d : Date) : Date
    {
        var d : Date = new Date(d.time);
        d.hours = 0;
        d.minutes = 0;
        d.seconds = 0;
        d.milliseconds = 0;
        return d;
    }
    
    /**
     * Converts a date into just befor midnight.
     */
    public static function makeNight(d : Date) : Date
    {
        var d : Date = new Date(d.time);
        d.hours = 23;
        d.minutes = 59;
        d.seconds = 59;
        d.milliseconds = 999;
        return d;
    }
    
    /**
     * Sort of converts a date into UTC.
     */
    public static function getUTCDate(d : Date) : Date
    {
        var nd : Date = Date.now();
        var offset : Float = d.getTimezoneOffset() * 60 * 1000;
        nd.setTime(d.getTime() + offset);
        return nd;
    }
}

