note
	description: "Summary description for {EPA_FEATURE_WITH_CONTEXT_CLASS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_FEATURE_WITH_CONTEXT_CLASS

inherit
	EPA_HASH_CALCULATOR
		redefine
			is_equal, out
		end

	INTERNAL_COMPILER_STRING_EXPORTER
		redefine
			is_equal, out
		end

	DEBUG_OUTPUT
		redefine
			is_equal, out
		end

	EPA_UTILITY
		redefine
			is_equal, out
		end

create
	make

feature{NONE} -- Initialization

	make (a_feature: FEATURE_I; a_context_class: CLASS_C)
			-- Initialization.
		require
			feature_attached: a_feature /= Void
			class_attached: a_context_class /= Void
		do
			feature_ := a_feature;
			context_class := a_context_class
		ensure
			feature_set: feature_ = a_feature
			context_class_set: context_class = a_context_class
		end

feature -- Access

	feature_: FEATURE_I
			-- Feature.

	context_class: CLASS_C
			-- Context class.

	written_feature: FEATURE_I
			-- Feature in written class.
		do
			Result := written_class.feature_of_rout_id_set (feature_.rout_id_set)
		end

	written_class: CLASS_C
			-- Written class.
		do
			Result := feature_.written_class
		end

	is_equal(other: like Current): BOOLEAN
			-- <Precursor>
		do
			Result := context_class.class_id = other.context_class.class_id and then feature_.rout_id_set ~ other.feature_.rout_id_set
		end

feature -- Status report

	is_public: BOOLEAN
			-- Is feature public?
		do
			Result := feature_.is_exported_for (system.any_class.compiled_representation)
		end

	is_creation_feature: BOOLEAN
			-- Is feature a creation feature?
		do
			Result := context_class.creators /= Void and then context_class.creators.has (feature_.feature_name_32)
		end

	is_query: BOOLEAN
			-- Is feature a query?
		do
			Result := feature_.is_function
		end

	is_command: BOOLEAN
			-- Is feature a command?
		do
			Result := feature_.is_routine and then not feature_.is_function
		end

	argument_count: INTEGER
			-- Number of arguments.
		do
			Result := feature_.argument_count
		end

	is_argumentless_public_command: BOOLEAN
			-- Is current an argumentless public command?
		do
			Result := is_public and then (argument_count = 0) and then is_command and then not is_creation_feature
		end

feature -- Output

	debug_output: STRING
			-- <Precursor>
		do
			Result := out
		end

	out: STRING
			-- <Precursor>
		do
			Result := context_class.name_in_upper + "." + feature_.feature_name
		end

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_list: DS_ARRAYED_LIST [INTEGER]
		do
			create l_list.make (2)
			l_list.force_last (feature_.feature_name_id)
			l_list.force_last (context_class.class_id)
			Result := l_list
		end

invariant
	feature_attached: feature_ /= Void
	class_attached: context_class /= Void

end
