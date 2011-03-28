note
	javascript: "NativeStub"
class
	JS_DATE

create
	make_current

feature {NONE} -- Initialization

	make_current
		external "C" alias "new Date()" end

feature -- Basic Operation

	value_of: INTEGER
			-- Number of milliseconds between January 1, 1970 (GMT) to the date and time specified by the object
		external "C" alias "valueOf()" end

end
