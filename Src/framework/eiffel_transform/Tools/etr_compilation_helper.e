note
	description: "DEBUG. Some features to help use custom asts in compilation"
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_COMPILATION_HELPER
inherit
	SHARED_SERVER
	SHARED_DEGREES
	ETR_SHARED_TOOLS

feature -- Operations
	reparse_class_by_name(a_class: STRING)
			-- reparse class with name `a_class'
		require
			non_void: a_class /= void
		local
			target_class: CLASS_I
			cid: INTEGER
		do
			target_class := universe.compiled_classes_with_name(a_class).first
			cid := target_class.compiled_class.class_id
			restore_ast (ast_server.item (cid))
		end

	replace_class_with(an_original_class,a_class: CLASS_AS)
			-- replace `an_original_class' by `a_class'
		require
			non_void: a_class /= void and an_original_class /= void
		local
			l_class_str: STRING
			l_parser: EIFFEL_PARSER
		do
			-- Ugly hack: have to reparse class because the wrong ast factory might have been used
			l_class_str := ast_tools.ast_to_string (a_class)

			create l_parser.make_with_factory (create {AST_ROUNDTRIP_COMPILER_LIGHT_FACTORY})
			l_parser.parse_from_string (l_class_str, system.class_of_id (an_original_class.class_id))

			ast_server.remove (an_original_class.class_id)
			l_parser.root_node.set_class_id (an_original_class.class_id)
			ast_server.put (l_parser.root_node)
		end

	mark_for_reparse(a_class: CLASS_AS)
			-- mark a `a_class' for reparsing
		require
			non_void: a_class /= void
		do
			if attached system.class_of_id (a_class.class_id) as compiled_class then
				compiled_class.set_changed (true)
				degree_5.insert_new_class (compiled_class)
				degree_4.insert_class (compiled_class)
				degree_3.insert_class (compiled_class)
				degree_2.insert_class (compiled_class)
				degree_1.insert_class (compiled_class)
			end
		end

	mark_class_changed(a_class: CLASS_AS)
			-- marks `a_class' as changed
		require
			non_void: a_class /= void
		do
			if attached system.class_of_id (a_class.class_id) as compiled_class then
				compiled_class.set_changed (true)
				degree_4.insert_class (compiled_class)
				degree_3.insert_class (compiled_class)
				degree_2.insert_class (compiled_class)
				degree_1.insert_class (compiled_class)
			end
		end

	restore_ast(a_class: CLASS_AS)
			-- recreate `a_class' from source code
		require
			non_void: a_class /= void
		do
			-- todo: make this not require the whole melting process
			mark_for_reparse(a_class)
			system.eiffel_project.quick_melt
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
