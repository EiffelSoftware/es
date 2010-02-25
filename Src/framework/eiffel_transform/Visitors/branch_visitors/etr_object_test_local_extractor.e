note
	description: "Extracts object test-locals from an ast."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_OBJECT_TEST_LOCAL_EXTRACTOR
inherit
	ETR_BRANCH_VISITOR
		redefine
			process_object_test_as,
			process_if_as,
			process_elseif_as,
			process_feature_as,
			process_bin_and_then_as
		end
	ETR_SHARED_TOOLS
create
	make

feature {NONE} -- Creation

	make(a_context: like context)
			-- make with `a_feature_context'
		require
			set: a_context /= void
		do
			context := a_context
		end

feature -- Operation

	process_from_root(a_root: AST_EIFFEL)
			-- process from `a_root'
		require
			root_set: a_root /= void
		do
			create current_scope.make
			create current_path.make_as_root (a_root)
			a_root.process (Current)
		end

feature {NONE} -- Implementation

	context: ETR_FEATURE_CONTEXT
			-- The feature context we're currently in

	current_path: AST_PATH
			-- The path we're currently at

	current_scope: LINKED_LIST[AST_PATH]
			-- The current scope

	process_branch(a_parent: AST_EIFFEL; a_branches:ARRAY[detachable AST_EIFFEL])
			-- process an n-way branch with parent `a_parent' and `a_branches'
		local
			i: INTEGER
			old_path: like current_path
		do
			from
				i:=1
				old_path := current_path.twin
			until
				i>a_branches.count
			loop
				if attached a_branches[i] as item then
					create current_path.make_from_parent (current_path, i)
					item.process (Current)
					current_path := old_path
				end
				i:=i+1
			end
		end

feature {AST_EIFFEL} -- Roundtrip

	process_bin_and_then_as (l_as: BIN_AND_THEN_AS)
		do
			-- scope: l_as.right (+branch body)
			current_scope.extend (create {AST_PATH}.make_from_parent(current_path,2))
			Precursor(l_as)
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			-- only process the feature we're interested in
			if l_as.feature_name.name.is_equal (context.name) then
				Precursor(l_as)
			end
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			-- scope: l_as.expr
			current_scope.wipe_out
			current_scope.extend(create {AST_PATH}.make_from_parent(current_path,2))
			Precursor(l_as)
			current_scope.wipe_out
		end

	process_if_as (l_as: IF_AS)
		local
			old_path: like current_path
		do
			old_path := current_path.twin

			-- scope: l_as.compound
			current_scope.wipe_out
			current_scope.extend ( create {AST_PATH}.make_from_parent(current_path,2) )
			create current_path.make_from_parent (current_path, 1)
			l_as.condition.process (Current)
			current_path := old_path
			current_scope.wipe_out

			process_branch(l_as, << void, l_as.compound, l_as.elsif_list, l_as.else_part >>)
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		local
			l_written_type: TYPE_A
			l_type_checker: ETR_TYPE_CHECKER
			l_explicit_type: TYPE_A
		do
			if attached l_as.name and attached not current_scope.is_empty then
				if attached l_as.type then
					l_written_type := type_checker.written_type_from_type_as (l_as.type, context.class_context.written_class, context.written_feature)
				else
					create l_type_checker
					l_type_checker.check_ast_type_at (l_as.expression, context, current_path)
					l_written_type := l_type_checker.last_type
				end
				l_explicit_type := type_checker.explicit_type (l_written_type, context.class_context.written_class)

				context.object_test_locals.extend (create {ETR_OBJECT_TEST_LOCAL}.make_at (l_as.name.name, l_explicit_type, l_written_type, current_scope))
			end
			process_branch(l_as, << void, l_as.expression, void >>)
		end
note
	copyright: "Copyright (c) 1984-2010, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
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
end
