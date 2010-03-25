indexing
	description : "project application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
		-- Application to teste create creation expressions
		-- See also class Y where tests are done in a feature with separate arguments.
		-- Class INV is testing invariants with no predefined features
		-- To test processor tag: Create a class PROCESSOR and uncomment the commented code (does not compile at the moment)
		local

			xh: separate <x.handler> X
     	--	xp: separate <p> X
     		y: Y
        	inv: INV
		do
			create x.make(False)
      	--	create xp.make(True)
			create xh.make(True)


			if test_creation_without_call(create {INV}) then
			end

			inv := create {INV}
			xh := create {separate <x.handler> X}.make(True)
			x := create {separate X}.make(True)

			create_separate_creation_with_call(create {X}.make(True))
	     	create_separate_creation_with_call(create {separate X}.make(True))
	     	create_separate_creation_with_call(create {separate <x.handler> X}.make(True))
       	--	create_separate_creation_with_call(create {separate <p> X}.make(True))


        	-- Check normal

        	test_creation_with_call(create {X}.make(True))
		ensure
			yup: test_creation_without_call(create {INV})
			yup: test_separate_assertion(create {X}.make(True))
			yup: test_separate_assertion(create {separate X}.make(True))
			yup: test_separate_assertion(create {separate <x.handler> X}.make(True))
			--yup: test_separate_assertion(create {separate <p> X}.make(True))
		end

	create_separate_creation_with_call(w: separate X) is
	    -- Does some...
	    do
	    end

	test_creation_with_call(w: X) is
			-- does some more
		do

		end
	test_creation_without_call(in: INV): BOOLEAN is
			--
			do

			end

	test_separate_assertion(w: separate X): BOOLEAN is
			-- do some assertions calculation
		do

		end

	x :separate X
--	p: PROCESSOR


end
