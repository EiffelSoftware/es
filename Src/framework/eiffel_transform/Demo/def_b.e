deferred class
	DEF_B
inherit
	DEF_A
		rename
			test as test_a
		redefine
			test_a
		end
	

feature

	test_a
		require else
			in_def_b: true
		deferred
		ensure then
			in_def_b: true
		end
	
	test_b
		require
			in_def_b: true
		deferred
		ensure
			in_def_b: true
		end
end
