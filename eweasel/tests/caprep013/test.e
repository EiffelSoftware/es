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
		do
			create l_obj
			{RT_CAPTURE_REPLAY}.print_string ("object id: " + l_obj.object_id.out + "%N")

			l_obj := Void
			(create {MEMORY}).full_collect

			{RT_CAPTURE_REPLAY}.print_string("done%N")
		end

feature {NONE}

	dispose
		do
			external_routine
			Precursor
		end

	external_routine
		external
			"C inline use %"eif_macros.h%""
		alias
			"[
				printf("C disposal\n");
			]"
		end


end

