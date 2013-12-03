note
	description: "Messages used in AutoProof."
	date: "$Date$"
	revision: "$Revision$"

frozen class
	E2B_MESSAGES

inherit

	SHARED_LOCALE

feature -- Messages

	functional_feature_not_function: STRING_32
		do Result := "Functional feature has to be a function" end

	functional_feature_not_single_assignment: STRING_32
		do Result := "A functional feature has to consist of exactly one assignment to the Result" end


	modify_field_first_argument_only_manifeststrings: STRING_32
		do Result := "The tuple in the first argument of 'modify_field' needs to consist only of manifest strings." end

	modify_field_first_argument_string_or_tuple: STRING_32
		do Result := "First argument of 'modify_field' has to be a manifest string or a tuple of manifest strings." end

	modify_field_field_does_not_exist (a_fname, a_cname: STRING): STRING_32
		do Result := locale.formatted_string ("Feature '$1' mentioned in 'modify_field' does not exist in class '$2'", a_fname, a_cname) end

	modify_field_field_not_attribute (a_fname: STRING): STRING_32
		do Result := locale.formatted_string ("Feature '$1' mentioned in 'modify_field' is not an attribute", a_fname) end

end
