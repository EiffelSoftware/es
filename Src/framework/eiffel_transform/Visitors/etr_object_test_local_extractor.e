note
	description: "Prints an ast while replacing assigment attempts with object tests"
	author: "$Author$"
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
	ETR_SHARED_TYPE_CHECKER
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
			create current_path.make_as_root (a_root)
			a_root.process (Current)
		end

feature {NONE} -- Implementation

	context: ETR_FEATURE_CONTEXT

	current_path: AST_PATH

	current_branch_scope: like current_path

	process_n_way_branch(a_parent: AST_EIFFEL; br:TUPLE[AST_EIFFEL])
			-- process an n-way branch with parent `a_parent' and branches `br'
		local
			i: INTEGER
			old_path: like current_path
		do
			from
				i:=1
				old_path := current_path.twin
			until
				i>br.count
			loop
				if attached {AST_EIFFEL}br.item (i) as item then
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
			-- scope: l_as.right
			current_branch_scope := create {AST_PATH}.make_from_parent(current_path,2)
			Precursor(l_as)
			current_branch_scope := void
		end

	process_feature_as (l_as: FEATURE_AS)
		do
			-- only process the feature we're interested in
			if l_as.feature_name.name.is_equal (context.name) then
				process_n_way_branch(l_as,[l_as.feature_names, l_as.body, l_as.indexes])
			end
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
			-- process an EIFFEL_LIST
		local
			l_cursor: INTEGER
			i: INTEGER
			old_path: like current_path
		do
			from
				l_cursor := l_as.index
				i:=1
				l_as.start
				old_path := current_path.twin
			until
				l_as.after
			loop
				create current_path.make_from_parent (current_path, i)
				l_as.item.process (Current)
				current_path := old_path
				l_as.forth
				i:=i+1
			end
			l_as.go_i_th (l_cursor)
		end

	process_elseif_as (l_as: ELSIF_AS)
		do
			-- scope: l_as.expr
			current_branch_scope := create {AST_PATH}.make_from_parent(current_path,2)
			Precursor(l_as)
			current_branch_scope := void
		end

	process_if_as (l_as: IF_AS)
		local
			old_path: like current_path
		do
			old_path := current_path.twin

			-- scope: l_as.compound
			current_branch_scope := create {AST_PATH}.make_from_parent(current_path,2)
			create current_path.make_from_parent (current_path, 1)
			l_as.condition.process (Current)
			current_path := old_path
			current_branch_scope := void

			process_n_way_branch(l_as,[void, l_as.compound, l_as.elsif_list, l_as.else_part])
		end

	process_object_test_as (l_as: OBJECT_TEST_AS)
		local
			l_type: TYPE_A
			l_type_checker: ETR_TYPE_CHECKER
		do
			if attached l_as.name and attached current_branch_scope then
				if attached l_as.type then
					l_type := type_checker.explicit_type_from_type_as (l_as.type, context.class_context.written_class, context.original_written_feature)
				else
					create l_type_checker
					l_type_checker.check_ast_type_at (l_as.expression, context, current_path)
					l_type := l_type_checker.last_type
				end

				context.object_test_locals.extend (create {ETR_OBJECT_TEST_LOCAL}.make (l_as.name.name, l_type, current_branch_scope))
			end
			process_n_way_branch(l_as,[void, l_as.expression, void])
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
