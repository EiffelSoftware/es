indexing
	description: "Summary description for {SCOOP_CLIENT_FEATURE_OBJECT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_OBJECT

feature -- Feature access

	feature_name: STRING is
			-- getter for 'feature_name_impl'
		do
			Result := feature_name_impl
		end

	set_feature_name (l_feature_name: STRING) is
			-- setter for 'feature_name_impl'
		do
			feature_name_impl := l_feature_name
		end

	feature_alias_name: STRING is
			-- getter for 'feature_alias_name_impl'
		do
			Result := feature_alias_name_impl
		end

	set_feature_alias_name (l_feature_alias_name: STRING) is
			-- setter for 'feature_alias_name_impl'
		do
			feature_alias_name_impl := l_feature_alias_name
		end

	feature_declaration_name: STRING is
			-- getter for 'feature_declaration_name_impl'
		do
			Result := feature_declaration_name_impl
		end

	set_feature_declaration_name (l_feature_declaration_name: STRING) is
			-- setter for 'feature_declaration_name_impl'
		do
			feature_declaration_name_impl := l_feature_declaration_name
		end

	preconditions: SCOOP_CLIENT_PRECONDITIONS is
			-- getter for 'preconditions_impl'
		do
			Result := preconditions_impl
		end

	set_preconditions (l_preconditions: SCOOP_CLIENT_PRECONDITIONS) is
			-- setter for 'preconditions_impl'
		do
			preconditions_impl := l_preconditions
		end

	postconditions: SCOOP_CLIENT_POSTCONDITIONS is
			-- getter for 'postconditions_impl'
		do
			Result := postconditions_impl
		end

	set_postconditions (l_postconditions: SCOOP_CLIENT_POSTCONDITIONS) is
			-- setter for 'postconditions_impl'
		do
			postconditions_impl := l_postconditions
		end

	arguments: SCOOP_CLIENT_ARGUMENT_OBJECT is
			-- getter for 'arguments_impl'
		do
			Result := arguments_impl
		end

	set_arguments (l_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT) is
			-- setter for 'arguments_impl'
		do
			arguments_impl := l_arguments
		end

	is_feature_frozen: BOOLEAN
		-- flag for frozen keyword

feature {NONE} -- Implementation

	feature_name_impl: STRING
		-- name of current feature

	feature_alias_name_impl: STRING
		-- alias name of current feature

	feature_declaration_name_impl: STRING
		-- name of current feature with alias
		-- or list of infix and noninfix name as string

	feature_as_impl: FEATURE_AS
		-- reference to current feature_as

	preconditions_impl: SCOOP_CLIENT_PRECONDITIONS
		-- actual container of precondition clauses, processed in 'process_routine_as'

	postconditions_impl: SCOOP_CLIENT_POSTCONDITIONS
		-- actual container of postcondition clauses, processed in 'process_routine_as'

	arguments_impl: SCOOP_CLIENT_ARGUMENT_OBJECT
		-- object collects processed arguments of processed feature


end
