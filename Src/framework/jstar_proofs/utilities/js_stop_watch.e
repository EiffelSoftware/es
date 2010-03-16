indexing
    description    : "A class to time your code."
    usage: "Place the code you want to benchmark between Current.start and Current.stop"
    author: "Gloria N. Mueller"
    date: "$Date$"
    revision: "$Revision$"

class
    JS_STOP_WATCH

create
    default_create

feature -- Storage.

    seconds_start, seconds_end: NATURAL_32
            -- Number of seconds starting at January 1, 1970
            -- before and after running your code.

    microseconds_start, microseconds_end: NATURAL_16
            -- Number of microseconds starting at January 1, 1970
            -- before and after running your code.

feature -- Timing.

    start is
            -- Start counting the time.
        local
            tmp_sec: INTEGER
        do
            current_seconds_and_microseconds($tmp_sec, $microseconds_start)
            seconds_start := tmp_sec.as_natural_32
        end

    current_seconds_and_microseconds(sec: TYPED_POINTER[INTEGER]; msec:
TYPED_POINTER[NATURAL_16]) is
            -- Get the current time, starting at January 1, 1970.
        external
            "C inline use <sys/time.h>"
        alias
            "[
                {
                    // C local variable
                    struct timeval tp;
                    gettimeofday(&tp, 0);
                       *$sec = tp.tv_sec;
                       *$msec = tp.tv_usec;    
                }
            ]"
        end

    stop_and_print is
            -- Stop counting the time and print the measured time interval.
        local
            tmp_sec: INTEGER
        do
            current_seconds_and_microseconds($tmp_sec, $microseconds_end)
            seconds_end := tmp_sec.as_natural_32
            io.put_natural_32(seconds_end - seconds_start)
io.put_string(" s ")
            io.put_natural_16(microseconds_end - microseconds_start)
io.put_string(" us ")
        end

    stop is
            -- Stop counting the time.
        local
            tmp_sec: INTEGER
        do
            current_seconds_and_microseconds($tmp_sec, $microseconds_end)
            seconds_end := tmp_sec.as_natural_32
        end

feature -- Access.

    seconds: NATURAL_32 is
            -- Return the number of seconds of the measurement.
        do
            Result := seconds_end - seconds_start
        end

    microseconds: NATURAL_16 is
            -- Return the number of microseconds of the measurement.
        do
            Result := microseconds_end - microseconds_start
        end

    total_time_in_microseconds: NATURAL_64 is
            -- Return the total time of the measurement in microseconds.
        do
            Result := seconds.as_natural_64 * 1000000 + microseconds
        end

    total_time_in_seconds: STRING is
    		-- Return the total time of the measurement in seconds.
    	local
    		padding: STRING
    		splitpoint: INTEGER
    	do
    		Result := total_time_in_microseconds.out
    		if Result.count < 6 then
    			padding := "0"
    			padding.multiply (6 - Result.count)
    			Result := "0." + padding + Result
    		elseif Result.count = 6 then
    			Result := "0." + Result
    		else
    			splitpoint := Result.count - 6
    			Result := Result.substring (1, splitpoint) + "." + Result.substring (splitpoint+1, Result.count)
    		end
    	end


end -- class.
