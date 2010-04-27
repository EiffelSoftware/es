note
	description: "Representation of a client feature object."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CLIENT_FEATURE_OBJECT
inherit
	SCOOP_DERIVED_CLASS_INFORMATION
	redefine
		make
	end

create
	make

feature -- Feature access
	make is
			-- Create Feature Object
		do
			Precursor
			create internal_arguments_to_substitute.make (0)
		ensure then
			not_void: internal_arguments_to_substitute /= void
		end


	feature_name: STRING
			-- Feature name.

	set_feature_name (a_feature_name: STRING)
			-- Set the feature name.
		do
			feature_name := a_feature_name
		end

	feature_alias_name: STRING

	set_feature_alias_name (a_feature_alias_name: STRING)
			-- Set the feature alias name.
		do
			feature_alias_name := a_feature_alias_name
		end

	feature_declaration_name: STRING

	set_feature_declaration_name (a_feature_declaration_name: STRING)
			-- Set the feature declaration name.
		do
			feature_declaration_name := a_feature_declaration_name
		end

	preconditions: SCOOP_CLIENT_PRECONDITIONS

	set_preconditions (a_preconditions: SCOOP_CLIENT_PRECONDITIONS)
			-- Set the preconditions.
		do
			preconditions := a_preconditions
		end

	postconditions: SCOOP_CLIENT_POSTCONDITIONS

	set_postconditions (a_postconditions: SCOOP_CLIENT_POSTCONDITIONS)
			-- Set the postconditions.
		do
			postconditions := a_postconditions
		end

	arguments: SCOOP_CLIENT_ARGUMENT_OBJECT

	set_arguments (a_arguments: SCOOP_CLIENT_ARGUMENT_OBJECT)
			-- Set the arguments.
		do
			arguments := a_arguments
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

	is_create_creation_wrappers_defined: BOOLEAN is
			-- Is `internal_arguments_to_substitute' not empty?
			do
				Result := not internal_arguments_to_substitute.is_empty
			end

	locals_index: LINKED_LIST_CURSOR[STRING]
		-- Position of the `local' declaration of the current feature
		-- Used to inser local declerations

	last_instr_call_index: LINKED_LIST_CURSOR[STRING]
		-- Position of the last instruction call of the current feature

	set_locals_index(crs:LINKED_LIST_CURSOR[STRING]) is
			-- set locals position
			do
				locals_index := crs
			end

	set_last_instr_call_index(crs:LINKED_LIST_CURSOR[STRING]) is
			-- set start position
			do
				last_instr_call_index := crs
			end

	need_local_section: BOOLEAN
		-- Do we need to add a local section at the end
		-- Is needed when we insert local decleration while processing the feature

	set_need_local_section (need: BOOLEAN) is
		-- Feature `need's a local keyword
		do
			need_local_section := need
		end

	local_keyword_index: LINKED_LIST_CURSOR[STRING]
		-- Position of where the `local' keyword is to be inserted if it has to be added

	set_local_keyword_index(crs:LINKED_LIST_CURSOR[STRING]) is
			-- set locals position
			do
				local_keyword_index := crs
			end

note
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
