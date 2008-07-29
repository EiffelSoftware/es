indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENT_FEATURE_CONFIG

inherit
	SAT_INSTRUMENT_CONFIG

create
	make

feature{NONE} -- Initialization

	make (a_class_name: like class_name; a_feature_name: like feature_name) is
			-- Initialize.
		do
			set_class_name (a_class_name)
			set_feature_name (a_feature_name)
		end

feature -- Status report

	is_instrument_enabled (a_context: BYTE_CONTEXT): BOOLEAN is
			-- Should instrument code be generated for the piece of code which is being process in `a_context'?
		do
			Result :=
				a_context.associated_class.name_in_upper.is_equal (class_name) and then
				a_context.current_feature.feature_name.is_equal (feature_name)
		ensure then
			good_result:
				Result = a_context.associated_class.name_in_upper.is_equal (class_name) and then
						 a_context.current_feature.feature_name.is_equal (feature_name)
		end

feature -- Access

	feature_name: STRING
			-- Name of the feature to be instrumented
			-- Assumed in lower case.

feature -- Setting

	set_feature_name (a_name: like feature_name) is
			-- Set `feature_name' with `a_name'.
			-- Note: reference setting, don't copy object.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			feature_name := a_name
		ensure
			feature_name_set: feature_name = a_name
		end

invariant
	feature_name_valid: feature_name /= Void and then not feature_name.is_empty

end
