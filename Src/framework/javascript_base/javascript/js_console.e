note
	javascript: "NativeStub"

class
	JS_CONSOLE

feature -- Basic Operation

	info (an_obj: ANY)
		external
			"C"
		alias "info($an_obj)"
		end

end
