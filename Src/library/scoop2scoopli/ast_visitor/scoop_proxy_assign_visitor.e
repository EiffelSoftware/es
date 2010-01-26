note
	description: "[
					Roundtrip visitor to vistit all parents rename clause, used while 
					SCOOP proxy class creation.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_PROXY_ASSIGN_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		export
			{NONE} all
		redefine
			process_class_as,
			process_parent_as,
			process_rename_clause_as,
			process_rename_as
		end

	SCOOP_WORKBENCH
		export
			{NONE} all
		end

feature -- Access

	get_renamings (an_original_name, an_original_alias_name: STRING; a_class_c: CLASS_C; return_old_feature_names: BOOLEAN): like parent_renamings is
			-- Returns a list of Tuples containing the class name and the old name or new name
			-- if the corresponding parent clause renames `an_original_feature_name'.
		require
			an_original_name_not_void: an_original_name /= Void
			an_original_alias_name_not_void: an_original_alias_name /= Void
			a_class_c_not_void: a_class_c /= Void
		do
			-- setup visitor
			setup (a_class_c.ast, match_list_server.item (a_class_c.class_id), false, false)

			-- set flag
			test_new_name := return_old_feature_names

			original_name := an_original_name
			original_alias_name := an_original_alias_name
			create parent_renamings.make

			-- process class
			safe_process (a_class_c.ast)

			Result := parent_renamings
		end

feature {NONE} -- Visitor implementation

	process_class_as (l_as: CLASS_AS) is
		do
			-- check renamings of parents
			safe_process (l_as.internal_conforming_parents)
			safe_process (l_as.internal_non_conforming_parents)
		end

	process_parent_as (l_as: PARENT_AS) is
		do
			-- save the current parent name
			current_parent_name := l_as.type.class_name.name

			safe_process (l_as.internal_renaming)
		end

	process_rename_clause_as (l_as: RENAME_CLAUSE_AS) is
			 -- Process `l_as'.
		do
			safe_process (l_as.content)
		end

	process_rename_as (l_as: RENAME_AS) is
		local
			l_name, l_alias_name, l_renamed_name: STRING
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
			l_tuple: TUPLE [parent_name: STRING; old_assigner_name, new_assigner_name: STRING]
		do
			-- get old and new name
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor_for_class (parsed_class, match_list)

			if test_new_name then
				-- test on new name
				l_feature_name_visitor.process_original_feature_name (l_as.new_name, false)
				l_name := l_feature_name_visitor.get_feature_name
				l_feature_name_visitor.process_original_feature_name (l_as.old_name, true)
				l_alias_name := l_feature_name_visitor.get_feature_name
			else
				-- test on old name
				l_feature_name_visitor.process_original_feature_name (l_as.old_name, false)
				l_name := l_feature_name_visitor.get_feature_name
				l_feature_name_visitor.process_original_feature_name (l_as.old_name, true)
				l_alias_name := l_feature_name_visitor.get_feature_name
			end


			-- test if the current processed assigner is renamed in this parent
			if l_name.as_lower.is_equal (original_name) or l_alias_name.as_lower.is_equal (original_alias_name) then

				-- insert tuple 'class name', 'old assigner name' in list
				create l_tuple
				l_tuple.parent_name := current_parent_name

				if test_new_name then
					-- test on new name - get old name
					l_feature_name_visitor.process_original_feature_name (l_as.old_name, true)
					l_renamed_name := l_feature_name_visitor.get_feature_name
					-- set names
					l_tuple.old_assigner_name := l_renamed_name
					l_tuple.new_assigner_name := l_name
				else
					-- test on old name - get new name
					l_feature_name_visitor.process_original_feature_name (l_as.new_name, true)
					l_renamed_name := l_feature_name_visitor.get_feature_name
					-- set names
					l_tuple.old_assigner_name := l_name
					l_tuple.new_assigner_name := l_renamed_name
				end
				parent_renamings.extend (l_tuple)
			end
		end

feature {NONE} -- Implementation

	test_new_name: BOOLEAN
			-- Indicates whether the old name should be compared or the new name.

	original_name, original_alias_name: STRING
			-- Name of the feature name we want to find

	current_parent_name: STRING
			-- Current processed parent (in `parent_as')

	parent_renamings: LINKED_LIST [TUPLE [parent_name: STRING; old_feature_name, new_feature_name: STRING]]
			-- List of parent names which renames `an_original_feature_name'
			-- with associated old assigner name

;note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software"
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
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end -- class SCOOP_PROXY_ASSIGN_VISITOR
