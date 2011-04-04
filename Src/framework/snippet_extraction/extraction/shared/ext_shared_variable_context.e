note
	description: "Maintaining variable information necessary in the context of snippet extraction."
	date: "$Date$"
	revision: "$Revision$"

class
	EXT_SHARED_VARIABLE_CONTEXT

feature {NONE} -- Implementation

	target_variables: HASH_TABLE [TYPE_A, STRING]
			-- Set of target variables at which we are looking at.
		once
			create Result.make (0)
			Result.compare_objects
		end

	interface_variables: HASH_TABLE [TYPE_A, STRING]
			-- Set of interface variables.
		once
			create Result.make (0)
			Result.compare_objects
		end

feature -- Configuration

	set_target_variable (a_target_variable_type: like target_variables.item_for_iteration; a_target_variable_name: like target_variables.key_for_iteration)
			-- Configures this class with a single target variable.
		require
			attached a_target_variable_type
			attached a_target_variable_name
		do
			target_variables.wipe_out
			target_variables.force (a_target_variable_type, a_target_variable_name)
		ensure
			one_element_in_target_variables: target_variables.count = 1
		end

	set_target_variables (a_target_variables: like target_variables)
			-- Configures this class with a set of target variables.
		require
			a_target_variables_not_void: a_target_variables /= Void
		do
			target_variables.wipe_out
			target_variables.merge (a_target_variables)
		ensure
--			target_variables_filled_with_input: target_variables ~ a_target_variables
		end

	set_interface_variables (a_interface_variables: like interface_variables)
			-- Configures this class with a set of interface variables.
		require
			a_interface_variables_not_void: a_interface_variables /= Void
		do
			interface_variables.wipe_out
			interface_variables.merge (a_interface_variables)
		ensure
--			interface_variables_filled_with_input: interface_variables ~ a_interface_variables
		end

feature -- Utility

	is_target_variable (a_variable_name: like target_variables.key_for_iteration): BOOLEAN
			-- Query if `variable_name' is equal to the target variable.
		require
			a_variable_name_attached: a_variable_name /= Void
		do
			if attached target_variables then
				Result := target_variables.has (a_variable_name)
			else
				Result := False
			end

		end

	is_interface_variable (a_variable_name: like interface_variables.key_for_iteration): BOOLEAN
			-- Query if `variable_name' is one of the interface variables.
		require
			a_variable_name_attached: a_variable_name /= Void
		do
			if attached interface_variables then
				Result := interface_variables.has (a_variable_name)
			else
				Result := False
			end
		end

	is_variable_of_interest (a_variable_name: STRING): BOOLEAN
			-- Query if `variable_name' is either the target or one of the interface variables.
		require
			a_variable_name_attached: a_variable_name /= Void
		do
			Result := is_target_variable (a_variable_name) or is_interface_variable (a_variable_name)
		end

feature {NONE} -- Invariant Support

	disjoint: BOOLEAN
			-- Are interface variables and target variables disjoint?
		local
			l_interface_set, l_target_set: ARRAYED_SET [STRING]
		do
			create l_interface_set.make (interface_variables.count)
			l_interface_set.fill (interface_variables.current_keys)

			create l_target_set.make (target_variables.count)
			l_target_set.fill (target_variables.current_keys)

			Result := l_interface_set.disjoint (l_target_set)
		end

invariant
	variable_sets_disjoint: disjoint

end
