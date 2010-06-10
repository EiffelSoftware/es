class
	TEST

inherit
	IDENTIFIED

creation
	make

feature


	make
		do
			test_object_id
			test_protect
		end

	test_object_id
		local
			obj: detachable IDENTIFIED
			id: INTEGER
		do
			create obj
			id := obj.object_id
			if retrieve (id) = obj then
				{RT_CAPTURE_REPLAY}.print_string ("retrieve OK%N")
			end

			obj := Void
			(create {MEMORY}).full_collect

			if retrieve (id) = Void then
				{RT_CAPTURE_REPLAY}.print_string ("object free OK%N")
			end
		end

	test_protect
		local
			obj: ANY
			p: POINTER
		do
			create obj
			p := protect (obj)
			if wean_and_return(p) = obj then
				{RT_CAPTURE_REPLAY}.print_string ("protect and wean OK%N")
			end
		end

feature {NONE}

	protect (obj: ANY): POINTER
		external
			"C inline use %"eif_hector.h%""
		alias
			"[
				return eif_protect(eif_access(arg1));
			]"
		end

	wean_and_return (p: POINTER): ANY
		external
			"C inline use %"eif_hector.h%""
		alias
			"[
				EIF_REFERENCE r =  eif_access(arg1);
				eif_wean(arg1);
				return r;
			]"
		end

	retrieve (id: INTEGER): detachable ANY
		external
			"C inline use %"eif_object_id.h%""
		alias
			"[
				return eif_id_object (arg1);
			]"
		end

end

