indexing
	description: "Test class"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	TEST

create
	make

feature -- db4o database control

	init is
			-- Set global database configuration.
		local
			eiffel_configuration: EIFFEL_CONFIGURATION
		do
			create eiffel_configuration.configure
		end

feature -- Run

	make is
			-- Run application.
		do
			init
			test
		end

	test is
			-- Test.
		local
			et: EXPANDED_TEST
			it: INHERITANCE_TEST
			gt: GENERICITY_TEST
			tt: TUPLE_TEST
			ct: CONFIGURATION_TEST
		do
			create et
			et.run
			io.put_string ("Press return to continue ...")
			io.read_line

			create it
			it.run
			io.put_string ("Press return to continue ...")
			io.read_line

			create gt
			gt.run
			io.put_string ("Press return to continue ...")
			io.read_line

			create tt
			tt.run
			io.put_string ("Press return to continue ...")
			io.read_line

			create ct
			ct.run
			io.put_string ("Press return to finish")
			io.read_line
		end


end
