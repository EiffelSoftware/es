indexing
	description: "Objects that represent test cases"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_CASE

inherit

	COMPARABLE

create {CDD_TEST_CASE_FACTORY, CDD_MANAGER}
	make

feature -- Initialization

	make (a_test_class: like tester_class; a_feature: like feature_under_test) is
			-- Initialize test case for testing `a_feature' of class `a_target_class' where
			-- `a_test_class' is the classed used for testing.
		require
			feature_not_empty: a_feature /= Void
			valid_test_class: a_test_class /= Void
		do
			create update_status_actions
			status := not_tested_code
			is_verified := True
			set_class_and_feature (a_test_class, a_feature)
		ensure
			verified: is_verified
			e_feature_set: feature_under_test = a_feature
			test_class_set: tester_class = a_test_class
		end

	set_unverified is
			-- Set `is_verified' to False.
		require
			not_testes_yet: status = not_tested_code
		do
			is_verified := False
		ensure
			not_verified: not is_verified
		end

feature -- Access

	cluster_under_test: CLUSTER_I is
			-- Cluster of `class_under_test'
		do
			Result := class_under_test.cluster
		ensure
			correct_result: Result = class_under_test.cluster
		end

	class_under_test: EIFFEL_CLASS_C is
			-- Class under tested
		do
			Result := feature_under_test.associated_class.eiffel_class_c
		end

	feature_under_test: E_FEATURE
			-- Name of feature under tested

	tester_class: EIFFEL_CLASS_I
			-- Class used for testing

	last_exception_tag: STRING
			-- Name of the last violation thrown by the test case

	last_exception_class_name, last_exception_feature_name: STRING

	status: INTEGER
			-- Status of `Current'

	pass_code,
	fail_code,
	invalid_code,
	not_tested_code: INTEGER is unique
			-- Test case status codes

	correct_status (a_status: INTEGER): BOOLEAN is
			-- Is `a_status' a correct status
		do
			Result := a_status = fail_code or a_status = pass_code or a_status = invalid_code or a_status = not_tested_code
		end

	is_verified: BOOLEAN
			-- Was `Current' verified to be a valid test case?

feature -- Status setting

	is_tested: BOOLEAN is
			-- Has `Current' been tested yet?
		do
			Result := status /= not_tested_code
		end

	passes: BOOLEAN is
			-- Did `Current' pass last test execution?
		do
			Result := status = pass_code
		end

	set_status (a_status: like status; a_class_name: like last_exception_class_name;
		a_feature_name: like last_exception_feature_name; an_exception_tag: like last_exception_tag) is
			-- Set `status' to `a_status' and `last_exception_tag' to `an_exception' and notify agents.
		require
			correct_status: correct_status (a_status)
		do
			last_exception_tag := an_exception_tag
			last_exception_feature_name := a_feature_name
			last_exception_class_name := a_class_name
			status := a_status
			if not is_verified and (a_status = fail_code or a_status = pass_code) then
				is_verified := True
			end
			update_status_actions.call ([])
		ensure
			last_exception_tag_set: last_exception_tag = an_exception_tag
			last_exception_feature_name_set: last_exception_feature_name = a_feature_name
			last_exception_class_name_set: last_exception_class_name = a_class_name
			status_set: status = a_status
		end

	set_class_and_feature (a_test_class: like tester_class; a_feature: like feature_under_test) is
			-- Initialize test case for testing `a_feature' of class `a_target_class' where
			-- `a_test_class' is the classed used for testing.
		require
			feature_not_void: a_feature /= Void
			valid_test_class: a_test_class /= Void
		do
			tester_class := a_test_class
			feature_under_test := a_feature
		ensure
			e_feature_set: feature_under_test = a_feature
			test_class_set: tester_class = a_test_class
		end

feature -- Element change

	set_tester_class (a_class: like tester_class) is
			-- Set `tester_class' to `a_class'.
		require
			a_class_not_void: a_class /= Void
		do
			tester_class := a_class
		ensure
			tester_class_set: tester_class = a_class
		end

	set_feature_under_test (a_feature: like feature_under_test) is
			-- Set `feature_under_test' to `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_under_test := a_feature
		ensure
			feature_under_test_set: feature_under_test = a_feature
		end

feature -- Verification setting

	set_verified is
			-- Set `is_verified' to False and call update agents.
		require
			not_tested_yet: status = not_tested_code
		do
			is_verified := True
			update_status_actions.call ([])
		ensure
			verified: is_verified
		end

feature -- Actions

	update_status_actions: ACTION_SEQUENCE [TUPLE]
			-- Agents called when execution of test case is over

feature -- Compare

	infix "<" (other: like Current): BOOLEAN is
			-- is 'Current' less than 'other'?
		require else
			other_not_void: other /= Void
		do
			if cluster_under_test < other.cluster_under_test then
				Result := True
			elseif cluster_under_test = other.cluster_under_test then
				if class_under_test < other.class_under_test then
					Result := True
				elseif class_under_test = other.class_under_test then
					if feature_under_test < other.feature_under_test then
						Result := True
					elseif feature_under_test.is_equal (other.feature_under_test) then
						if tester_class < other.tester_class then
							Result := True
						end
					end
				end
			end
		end

invariant
	feature_under_test_not_void: feature_under_test /= Void
	tester_class_not_void: tester_class /= Void
	update_status_actions_not_void: update_status_actions /= Void
	valid_status: correct_status (status)
	correct_verification_status: not is_verified implies (status = not_tested_code or status = invalid_code)

end
