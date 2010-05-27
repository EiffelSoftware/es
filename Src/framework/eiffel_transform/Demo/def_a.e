deferred class
	DEF_A

feature
	test
		require
			in_def_a: true
		deferred
		ensure
			in_def_a: true
		end
end
