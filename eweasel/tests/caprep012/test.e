class
	TEST

inherit
	IDENTIFIED
		redefine
			dispose
		end

creation
	default_create, make
feature

	make
		local
			l_obj: TEST
			l_init: STRING
		do
			l_init := dispose_text

			create l_obj
			{RT_CAPTURE_REPLAY}.print_string ("object id: " + l_obj.object_id.out + "%N")

			(create {MEMORY}).full_collect
			l_obj := Void
			(create {MEMORY}).full_collect

			external_routine

			{RT_CAPTURE_REPLAY}.print_string("done%N")
		end

feature {NONE}

	dispose
		do
			{RT_CAPTURE_REPLAY}.print_string(dispose_text)
			Precursor
		end

	dispose_text: STRING
		once
			Result := "dispose%N"
		end

	external_routine
		external
			"C inline use %"eif_macros.h%""
		alias
			"[
				
			]"
		end


end

