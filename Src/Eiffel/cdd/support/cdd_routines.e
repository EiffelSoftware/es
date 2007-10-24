indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_ROUTINES

feature {NONE} -- Implementation

	is_creation_feature (a_feature: E_FEATURE): BOOLEAN is
			--
		require
			a_feature_not_void: a_feature /= Void
		local
			l_class: CLASS_C
		do
			l_class := a_feature.associated_class
			Result := l_class.creation_feature = a_feature.associated_feature_i
			if not Result then
				Result := l_class.creators /= Void and then l_class.creators.has (a_feature.name)
			end
		end

	is_valid_status (an_application_status: APPLICATION_STATUS): BOOLEAN is
			-- Is 'an_application_status' valid for creating a test case?
		do
			Result := an_application_status.is_stopped and
					an_application_status.exception_occurred and
					(an_application_status.exception_code = {EXCEP_CONST}.void_call_target or
					an_application_status.exception_code = {EXCEP_CONST}.postcondition or
					an_application_status.exception_code = {EXCEP_CONST}.class_invariant or
					an_application_status.exception_code = {EXCEP_CONST}.precondition or
					an_application_status.exception_code = {EXCEP_CONST}.check_instruction)
		end


feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
