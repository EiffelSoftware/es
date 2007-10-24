indexing
	description: "Objects that support CDD_INTERPRETER"

class
	CDD_INTERPRETER_SUPPORT

inherit
	EXECUTION_ENVIRONMENT

	EXCEPTIONS

feature

	run_test (a_test_case: CDD_SHARED_TESTING) is
			-- Run `a_test' and print results to console
		require
			a_test_case_not_void: a_test_case /= Void
		local
			l_initialized, l_inv_checked: BOOLEAN
		do
			io.put_string ("%N%NTesting ")
			io.put_string ("Testing " + a_test_case.generator + "%N")

			io.put_string ("Setting up object...")
			a_test_case.set_up
			l_initialized := True
			io.put_string ("%T%TOK%N")

			io.put_string ("Checking class invariants...")
			a_test_case.object_under_test.do_nothing
			l_inv_checked := True
			io.put_string ("%TOK%N")

			io.put_string ("Running feature...%N")
			a_test_case.run_feature_under_test

			io.put_string ("%N[PASSED]")
		rescue
			io.put_string ("%N[FAILED]%N")
			if original_class_name /= Void then
				io.put_string (original_class_name)
			else
				io.put_string ("no_original_class_name")
			end
			io.put_character ('.')
			if original_recipient_name /= Void then
				io.put_string (original_recipient_name)
			else
				io.put_string ("no_original_recipient_name")
			end
			io.put_character ('.')
			if tag_name = Void then
				io.put_string ("no_tag_name")
			else
				io.put_string (tag_name)
			end
			if not l_inv_checked then
				die (30)
			elseif exception = precondition and
				a_test_case.class_under_test.is_equal (original_class_name) and
				a_test_case.feature_under_test.is_equal (original_recipient_name) then
				die (30)
			else
				die (200)
			end
		end

end -- Class CDD_INTERPRETER_SUPPORT
