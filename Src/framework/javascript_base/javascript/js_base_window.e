note
	javascript: "NativeStub"

class
	JS_BASE_WINDOW

feature -- Basic Operation

	clear_interval (a_id_of_setinterval: INTEGER)
			-- Clears a timer set with setInterval()
		external
			"C"
		alias "clearInterval($a_id_of_setinterval)"
		end

	clear_timeout (a_id_of_settimeout: INTEGER)
			-- Clears a timer set with setTimeout()
		external
			"C"
		alias "clearTimeout($a_id_of_settimeout)"
		end

	set_interval (a_executable: attached PROCEDURE [ANY, attached TUPLE]; a_millisec: INTEGER): INTEGER
			-- Calls a function or evaluates an expression at specified intervals (in milliseconds)
		external
			"C"
		alias "setInterval($a_executable, $a_millisec)"
		end

	set_timeout (a_executable: attached PROCEDURE [ANY, attached TUPLE]; a_millisec: INTEGER): INTEGER
			-- Calls a function or evaluates an expression after a specified number of milliseconds
		external
			"C"
		alias "setTimeout($a_executable, $a_millisec)"
		end


end
