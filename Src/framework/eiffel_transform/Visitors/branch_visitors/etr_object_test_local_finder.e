note
	description: "Finds object test local that have to be transformed in a context transformation."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_OBJECT_TEST_LOCAL_FINDER
inherit
	AST_ITERATOR
		export
			{AST_EIFFEL} all
		redefine
			process_object_test_as
		end
	ETR_SHARED_TOOLS
	ETR_SHARED_LOGGER
create
	make

feature {NONE} -- Creation

	make(a_context: like context; a_object_test_locals: like object_test_locals)
			-- Make with `a_feature_context'
		require
			set: a_context /= void
		do
			context := a_context
			object_test_locals := a_object_test_locals
		end

feature -- Operation

	process_from_root (a_root: AST_EIFFEL)
			-- Process from `a_root'
		require
			root_set: a_root /= void
		do
			a_root.process (Current)
		end

feature {NONE} -- Implementation

	context: ETR_CONTEXT
			-- The context we're currently in

	object_test_locals: LIST[ETR_OBJECT_TEST_LOCAL]
			-- Object-test locals in the feature

feature {AST_EIFFEL} -- Roundtrip

	process_object_test_as (l_as: OBJECT_TEST_AS)
		local
			l_written_type: TYPE_A
			l_explicit_type: TYPE_A
			l_feat_context: ETR_FEATURE_CONTEXT
			l_found: BOOLEAN
		do
			if attached context.feature_context as ctx then
				l_feat_context := ctx
			end

			if attached l_as.name then
				if attached l_as.type then
					l_written_type := type_checker.written_type_from_type_as (l_as.type, context.class_context.written_class, l_feat_context.written_feature)
				else
					type_checker.check_ast_type_at (l_as.expression, context, l_as.path)
					l_written_type := type_checker.last_type
				end

				if l_written_type/=void and then l_written_type.is_valid then
					l_explicit_type := type_checker.explicit_type (l_written_type, context.class_context.written_class, l_feat_context.written_feature)

					-- check if name already exists
					from
						object_test_locals.start
					until
						object_test_locals.after
					loop
						if object_test_locals.item.name.is_equal (l_as.name.name) then
							l_found := true
							logger.log_warning ("More than one object-test local with name "+l_as.name.name+". Only the first one is being considered for context transformation")
						end

						object_test_locals.forth
					end

					if not l_found then
						object_test_locals.extend (create {ETR_OBJECT_TEST_LOCAL}.make_at (l_as.name.name, l_explicit_type, l_written_type, create {LINKED_LIST[AST_PATH]}.make))
					end
				end
			end

			Precursor(l_as)
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
