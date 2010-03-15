note
	description: "Representation of a client feature object."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_OBJECT
create
	make

feature -- Feature access

	make is
			-- Create Feature Object
		do
			create internal_arguments_to_substitute.make (0)
		ensure
			not_void: internal_arguments_to_substitute /= void
		end


	feature_name: STRING is
			-- Feature name.
		do
			Result := feature_name_impl
		end
--	feature_name_object: FEATURE_NAME
--		do
--			Result := feature_name_object_impl
--		end

	set_feature_name (l_feature_name: STRING) is
			-- Set `l_feature_name'.
		do
			feature_name_impl := l_feature_name
		end

	feature_alias_name: STRING is
			-- Feature alias name.
		do
			Result := feature_alias_name_impl
		end

	set_feature_alias_name (l_feature_alias_name: STRING) is
			-- Set `l_feature_alias_name'.
		do
			feature_alias_name_impl := l_feature_alias_name
		end

	feature_declaration_name: STRING is
			-- Feature declaration name.
		do
			Result := feature_declaration_name_impl
		end

	set_feature_declaration_name (l_feature_declaration_name: STRING) is
			-- Set `l_feature_declaration_name'.
		do
			feature_declaration_name_impl := l_feature_declaration_name
		end

	preconditions: SCOOP_CLIENT_PRECONDITIONS is
			-- Client precondition object.
		do
			Result := preconditions_impl
		end

	set_preconditions (l_preconditions: SCOOP_CLIENT_PRECONDITIONS) is
			-- Set `l_preconditions'.
		do
			preconditions_impl := l_preconditions
		end

	postconditions: SCOOP_CLIENT_POSTCONDITIONS is
			-- Client postcondition object.
		do
			Result := postconditions_impl
		end

	set_postconditions (l_postconditions: SCOOP_CLIENT_POSTCONDITIONS) is
			-- Set `l_postconditions'.
		do
			postconditions_impl := l_postconditions
		end

	arguments: SCOOP_CLIENT_ARGUMENT_OBJECT is
			-- Feature arguments.
		do
			Result := arguments_impl
		end

	set_arguments (l_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT) is
			-- Set `l_arguments'.
		do
			arguments_impl := l_arguments
		end

	is_feature_frozen: BOOLEAN
			-- Is the feature frozen?


	is_internal_arguments_to_substitute_defined: BOOLEAN is
			-- Is `internal_arguments_to_substitute' not empty?
			do
				Result := not internal_arguments_to_substitute.is_empty
			end

	internal_arguments_to_substitute: IDENTIFIER_LIST
			-- List of arguments to substitute:
			-- Separate Arguments, which feature has a parent redeclaration with non separate argument.

feature {NONE} -- Implementation

	feature_name_object_impl: FEATURE_NAME
			-- Feature name object

	feature_name_impl: STRING
			-- Name of current feature.

	feature_alias_name_impl: STRING
			-- Alias name of current feature.

	feature_declaration_name_impl: STRING
			-- Name of current feature with alias
			-- or list of infix and noninfix name as string.

	feature_as_impl: FEATURE_AS
			-- Reference to current feature_as.

	preconditions_impl: SCOOP_CLIENT_PRECONDITIONS
			-- Actual container of precondition clauses, processed in 'process_routine_as'.

	postconditions_impl: SCOOP_CLIENT_POSTCONDITIONS
			-- Actual container of postcondition clauses, processed in 'process_routine_as'.

	arguments_impl: SCOOP_CLIENT_ARGUMENT_OBJECT
			-- Object collects processed arguments of processed feature.

;note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_CLIENT_FEATURE_OBJECT
