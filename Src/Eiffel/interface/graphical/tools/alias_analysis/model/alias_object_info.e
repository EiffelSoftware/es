class
	ALIAS_OBJECT_INFO

create
	make_variable,
	make_object,
	make_void

feature {NONE}

	make_variable (
			a_context_routine: PROCEDURE_I;
			a_variable_map: HASH_TABLE [ALIAS_OBJECT, STRING_8];
			a_variable_name: STRING_8
		)
		require
			a_context_routine /= Void
			a_variable_map /= Void
			a_variable_name /= Void
		do
			context_routine := a_context_routine
			variable_map := a_variable_map
			variable_name := a_variable_name
			alias_object := a_variable_map[a_variable_name]
		ensure
			context_routine = a_context_routine
			variable_map = a_variable_map
			variable_name = a_variable_name
			alias_object = a_variable_map[a_variable_name]
		end

	make_object (a_alias_object: ALIAS_OBJECT)
		require
			a_alias_object /= Void
		do
			alias_object := a_alias_object
		ensure
			alias_object = a_alias_object
		end

	make_void
		do
		end

feature {NONE}

	context_routine: PROCEDURE_I

	variable_map: HASH_TABLE [ALIAS_OBJECT, STRING_8]

	variable_name: STRING_8

feature {ANY}

	alias_object: ALIAS_OBJECT assign set_alias_object

	is_variable: BOOLEAN
		do
			Result := variable_map /= Void
		end

	set_alias_object (a_alias_object: ALIAS_OBJECT)
		require
			is_variable
		do
			if a_alias_object = Void then
				alias_object := Void
				variable_map.remove (variable_name)
			elseif a_alias_object.type.is_expanded then
				alias_object := create {ALIAS_OBJECT}.make (a_alias_object.type)
				variable_map[variable_name] := alias_object
				across a_alias_object.attributes as c loop
					(create {ALIAS_OBJECT_INFO}.make_variable (
							context_routine, -- wrong; unused dummy
							alias_object.attributes,
							c.key
						)).alias_object := c.item
				end
			else
				alias_object := a_alias_object
				variable_map[variable_name] := a_alias_object
			end
		end

	type: CL_TYPE_A
		require
			is_variable
		local
			l_context: AST_CONTEXT
			l_type_checker: AST_FEATURE_CHECKER_GENERATOR
			l_type: TYPE_A
		do
			if variable_name.is_equal ("Result") then
				-- Result
				l_type := context_routine.type
			elseif attached context_routine.written_class.feature_named_32 (variable_name) as attr then
				-- attribute
				l_type := attr.type
			else
				-- local variable
				l_context := (create {SHARED_AST_CONTEXT}).context
				l_context.clear_all

				l_context.initialize (
						context_routine.written_class,
						context_routine.written_class.actual_type
					)
				l_context.set_written_class (context_routine.written_class)
				l_context.set_current_feature (context_routine)

				create l_type_checker
				l_type_checker.init (l_context)
				l_type_checker.type_check_only (
						context_routine,
						True,
						False,
						context_routine.is_replicated
					)

				l_type := l_context.locals.item ((create {SHARED_NAMES_HEAP}).names_heap.id_of (variable_name)).type
				l_context.clear_all
			end

			if attached {CL_TYPE_A} l_type as l_correct_type then
				Result := l_correct_type
			else
				Io.put_string ("Unkown type: " + l_type.generator + "%N")
			end
		end

invariant
	(context_routine = Void) = (variable_map = Void) = (variable_name = Void)

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software"
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
