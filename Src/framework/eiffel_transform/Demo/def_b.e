deferred class
	DEF_B
inherit
	DEF_A
		rename
			test as test_a
		end
	

feature
	test_b
		deferred
		end
end
