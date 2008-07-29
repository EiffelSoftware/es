indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SAT_INSTRUMENT_CONFIG

feature -- Status report

	is_instrument_enabled (a_context: BYTE_CONTEXT): BOOLEAN is
			-- Should instrument code be generated for the piece of code which is being process in `a_context'?
		require
			a_context_attached: a_context /= Void
		deferred
		end

feature -- Access

	class_name: STRING
			-- Base name of the class to be instrumented
			-- Name is assumed to be in upper case and is case sensitive.

feature -- Setting

	set_class_name (a_name: like class_name) is
			-- Set `class_name' with `a_name'.
			-- Note: reference setting, don't copy object.
		require
			a_name_valid: a_name /= Void and then not a_name.is_empty
		do
			class_name := a_name
		ensure
			class_name_set: class_name = a_name
		end


invariant
	class_name_valid: class_name /= Void and then not class_name.is_empty
end
