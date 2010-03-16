indexing
	description: "Summary description for {JS_STOP_WATCH}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_STOP_WATCH

inherit
	ANY
	redefine default_create end

create
	default_create

feature

	default_create
		do
			create stopwatch.make
		end

	start
		do
			stopwatch.start
		end

	stop
		do
			stopwatch.stop
		end

	total_time_in_seconds: STRING
		local
			decimal_spaces: INTEGER
			padding: STRING
			splitpoint: INTEGER
		do
			decimal_spaces := 3
			Result := stopwatch.elapsed_time.millisecond_count.out
			if Result.count < decimal_spaces then
    			padding := "0"
    			padding.multiply (decimal_spaces - Result.count)
    			Result := "0." + padding + Result
    		elseif Result.count = decimal_spaces then
    			Result := "0." + Result
    		else
    			splitpoint := Result.count - decimal_spaces
    			Result := Result.substring (1, splitpoint) + "." + Result.substring (splitpoint+1, Result.count)
    		end
		end


feature {NONE}

	stopwatch: DT_STOPWATCH

end
