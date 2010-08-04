note
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	Y
feature {NONE} -- Access

	test_create_creation_expr_with_separate_arguments(w: separate X) is

		local
			y: separate X
			xh: separate <x.handler> X

	    do
	    	create x.make(True)
	    	create y.make(True)
			create xh.make(True)

			if test_separate_assertion(create {X}.make(True)) then
			end
			if test_separate_assertion(create {separate X}.make(True)) then
			end
			if test_separate_assertion(create {separate <x.handler> X}.make(True)) then
			end
--			if test_separate_assertion(create {separate <p> X}.make(True)) then
--			end

	   	ensure
     		yup: test_separate_assertion(x)
     		yup: test_separate_assertion(create {X}.make(True))
			yup: test_separate_assertion(create {separate X}.make(True))
			yup: test_separate_assertion(create {separate <x.handler> X}.make(True))
			--yup: test_separate_assertion(create {separate <p> X}.make(True))
	    end

	test_precondititon_create_creation_expr_with_separate_arguments(w: separate X) is

	   	require
	   		yup: test_separate_assertion(x)
	   		yup: test_separate_assertion(create {X}.make(True))
			yup: test_separate_assertion(create {separate X}.make(True))
			yup: test_separate_assertion(create {separate <x.handler> X}.make(True))
		--	yup: test_separate_assertion(create {separate <p> X}.make(True))
		do

		end

	    x: separate X

	    --p: PROCESSOR

	test_separate_assertion(w: separate X): BOOLEAN is
			-- do some assertions calculation
		do

		end
invariant
		yup: test_separate_assertion(x)
     	yup: test_separate_assertion(create {X}.make(True))
		yup: test_separate_assertion(create {separate X}.make(True))
		yup: test_separate_assertion(create {separate <x.handler> X}.make(True))
	--	yup: test_separate_assertion(create {separate <p> X}.make(True))
end
