note
	description: "[
		Base class for routine translators.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_ROUTINE_TRANSLATOR_BASE

inherit

	E2B_FEATURE_TRANSLATOR

feature -- Access

	current_feature: FEATURE_I
			-- Currently translated feature.

	current_type: TYPE_A
			-- Type of currently translated feature.

	current_boogie_procedure: detachable IV_PROCEDURE
			-- Currently generated Boogie procedure (if any).

feature -- Element change

	set_context (a_feature: FEATURE_I; a_type: TYPE_A)
			-- Set context of current translation.
		do
			current_feature := a_feature
			if a_type.is_attached then
				current_type := a_type
			else
				current_type := a_type.as_attached_type
			end
		ensure
			current_feature_set: current_feature = a_feature
			current_type_set: current_type.same_as (a_type.as_attached_type)
		end

	set_up_boogie_procedure (a_boogie_name: STRING)
			-- Set up `current_boogie_procedure'.
		do
			current_boogie_procedure := boogie_universe.procedure_named (a_boogie_name)
			if not attached current_boogie_procedure then
				create current_boogie_procedure.make (a_boogie_name)
				boogie_universe.add_declaration (current_boogie_procedure)
			end
		ensure
			current_boogie_procedure_set: attached current_boogie_procedure
			current_boogie_procedure_named: current_boogie_procedure.name ~ a_boogie_name
			current_boogie_procedure_added: boogie_universe.procedure_named (a_boogie_name) = current_boogie_procedure
		end

feature -- Helper functions

	arguments_of (a_feature: FEATURE_I; a_context: TYPE_A): ARRAYED_LIST [TUPLE [name: STRING; type: TYPE_A; boogie_type: IV_TYPE]]
			-- List of feature arguments of `a_feature'.
		require
			a_feature_attached: attached a_feature
			a_context_attached: attached a_context
		local
			i: INTEGER
			l_type: TYPE_A
		do
			create Result.make (a_feature.argument_count)
			from i := 1 until i > a_feature.argument_count loop
				l_type := a_feature.arguments.i_th (i).deep_actual_type.instantiated_in (a_context)
				Result.extend([
					a_feature.arguments.item_name (i),
					l_type,
					types.for_type_a (l_type)
				])
				i := i + 1
			end
		end

	arguments_of_current_feature: like arguments_of
			-- List of arguments of `current_feature'.
		require
			current_feature_set: attached current_feature
			current_type_set: attached current_type
		do
			Result := arguments_of (current_feature, current_type)
		end

	add_argument_with_property (a_name: STRING; a_type: TYPE_A; a_boogie_type: IV_TYPE)
		require
			current_procedure_set: attached current_boogie_procedure
		do
			current_boogie_procedure.add_argument (a_name, a_boogie_type)
			
		end

end
