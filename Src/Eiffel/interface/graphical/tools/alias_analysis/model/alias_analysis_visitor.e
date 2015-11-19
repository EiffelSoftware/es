note
	description: "The visitor that computes the alias state."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYSIS_VISITOR

inherit
	AST_ITERATOR
		redefine
			process_eiffel_list,
			process_assign_as,
			process_assigner_call_as,
			process_create_creation_as,
			process_instr_call_as,
			process_if_as,
			process_object_test_as
		end
	SHARED_SERVER

create
	make

feature {NONE}

	make (a_routine: PROCEDURE_I; a_statement_observer: like statement_observer)
		require
			a_routine /= Void
		do
			create alias_graph.make (a_routine)
			statement_observer := a_statement_observer
		ensure
			statement_observer = a_statement_observer
		end

feature {ANY}

	alias_graph: ALIAS_GRAPH

	statement_observer: PROCEDURE [ANY, TUPLE [AST_EIFFEL, ALIAS_GRAPH]]

feature {NONE}

	process_eiffel_list (a_node: EIFFEL_LIST [AST_EIFFEL])
		local
			l_cursor: INTEGER
		do
			from
				l_cursor := a_node.index
				a_node.start
			until
				a_node.after
			loop
				if attached a_node.item as l_item then
					if statement_observer /= Void then
						statement_observer.call (l_item, alias_graph)
					end
					l_item.process (Current)
				else
					check False end
				end
				a_node.forth
			end
			a_node.go_i_th (l_cursor)
		end

	process_assign_as (a_node: ASSIGN_AS)
		do
			if
				attached get_alias_info (Void, a_node.target) as l_target and then
				l_target.is_variable and then
				attached get_alias_info (Void, a_node.source) as l_source
			then
				l_target.alias_object := l_source.alias_object
			else
				Io.put_string ("Not yet supported (1): " + code(a_node) + "%N")
			end
		end

	process_assigner_call_as (a_node: ASSIGNER_CALL_AS)
		do
			-- foo.bar := baz  ->  handle as: foo.set_bar(baz)
			if
				attached {EXPR_CALL_AS} a_node.target as l_target1 and then                               -- foo.bar
				attached {NESTED_AS} l_target1.call as l_target2 and then                                 -- foo.bar
				attached get_alias_info (Void, l_target2.target) as l_foo and then                        -- foo
				attached {ACCESS_FEAT_AS} l_target2.message as l_bar and then                             -- bar
				attached l_foo.alias_object.type.base_class as l_c and then                               -- class of bar
				attached l_c.feature_named_32 (l_bar.access_name_32).assigner_name as l_set_bar1 and then -- set_bar
				attached {PROCEDURE_I} l_c.feature_named_32 (l_set_bar1) as l_set_bar2 and then           -- set_bar
				l_set_bar2.argument_count = 1
			then
				call_routine_with_arg (l_foo.alias_object, l_set_bar2, a_node.source).do_nothing
			else
				Io.put_string ("Not yet supported (2): " + code(a_node) + "%N")
			end
		end

	process_create_creation_as (a_node: CREATE_CREATION_AS)
		do
			if
				attached get_alias_info (Void, a_node.target) as l_target and then
				l_target.is_variable
			then
				l_target.alias_object := create {ALIAS_OBJECT}.make (l_target.type)
			else
				Io.put_string ("Not yet supported (3): " + code(a_node) + "%N")
			end
		end

	process_instr_call_as (a_node: INSTR_CALL_AS)
		do
			get_alias_info (Void, a_node.call).do_nothing
		end

	process_if_as (a_node: IF_AS)
		local
--			l_branches: TWO_WAY_LIST [AST_EIFFEL]
--			l_before_state, l_merged_state: ALIAS_STATE
		do
			Precursor (a_node)
--			create l_branches.make
--			if a_node.compound /= Void then
--				l_branches.extend (a_node.compound)
--			end
--			if a_node.elsif_list /= Void then
--				across a_node.elsif_list as c loop
--					l_branches.extend (c.item)
--				end
--			end
--			if a_node.else_part /= Void then
--				l_branches.extend (a_node.else_part)
--			end

--			inspect l_branches.count
--			when 0 then
--				-- nothing to do
--			when 1 then
--				-- no merging needed
--				l_branches.first.process (Current)
--			else
--				l_before_state := alias_state
--				across l_branches as c loop
--					alias_state := copy_state (l_before_state)
--					c.item.process (Current)
--					if l_merged_state = Void then
--						l_merged_state := alias_state
--					else
--						merge_state (alias_state, l_merged_state)
--					end
--				end
--				alias_state := l_merged_state
--			end
		end

	process_object_test_as (a_node: OBJECT_TEST_AS)
		do
			-- TODO only keep it in its scope
			if a_node.name /= Void then
				if attached get_alias_info (Void, a_node.expression) as l_expression then
					(create {ALIAS_OBJECT_INFO}.make_variable (
							alias_graph.stack_top.routine,
							alias_graph.stack_top.locals,
							a_node.name.name_8
						)).alias_object := l_expression.alias_object
				else
					Io.put_string ("Not yet supported (4): " + code(a_node) + "%N")
				end
			end
		end

feature {NONE} -- utilities

	get_alias_info (a_target: ALIAS_OBJECT; a_node: AST_EIFFEL): ALIAS_OBJECT_INFO
		require
			a_node /= Void
		do
			if attached {VOID_AS} a_node as l_node then
				create Result.make_void
			elseif attached {INTEGER_AS} a_node as l_node then
				create Result.make_object (
						create {ALIAS_OBJECT}.make (create {CL_TYPE_A}.make (System.integer_32_class.compiled_class.class_id))
					)
			elseif attached {STRING_AS} a_node as l_node then
				create Result.make_object (
						create {ALIAS_OBJECT}.make (create {CL_TYPE_A}.make (System.string_8_class.compiled_class.class_id))
					)
			elseif attached {CURRENT_AS} a_node as l_node then
				create Result.make_object (alias_graph.stack_top.current_object)
			elseif attached {CREATE_CREATION_EXPR_AS} a_node as l_node then
				if
					attached {CLASS_TYPE_AS} l_node.type as l_type and then
					attached System.eiffel_universe.classes_with_name (l_type.class_name.name_8) as l_classes and then
					l_classes.count = 1
				then
					create Result.make_object (
							create {ALIAS_OBJECT}.make (create {CL_TYPE_A}.make (l_classes.first.compiled_class.class_id))
						)
				end
			elseif attached {RESULT_AS} a_node as l_node then
				create Result.make_variable (
						alias_graph.stack_top.routine,
						alias_graph.stack_top.locals,
						"Result"
					)
			elseif attached {ACCESS_FEAT_AS} a_node as l_node then
				if
					l_node.is_local or
					l_node.is_argument or
					l_node.is_object_test_local
				then
					create Result.make_variable (
							alias_graph.stack_top.routine,
							alias_graph.stack_top.locals,
							l_node.access_name_8
						)
				elseif l_node.is_tuple_access then
					-- TODO
				elseif attached find_routine (l_node) as l_routine then
					-- routine
					if l_routine.argument_count = l_node.parameter_count then
						Result := call_routine (a_target, l_routine, l_node.parameters)
					end
				else
					-- attribute
					create Result.make_variable (
							alias_graph.stack_top.routine,
							(if a_target /= Void then a_target else alias_graph.stack_top.current_object end).attributes,
							l_node.access_name_8
						)
				end
			elseif attached {NESTED_AS} a_node as l_node then
				if
					attached get_alias_info (a_target, l_node.target) as l_target and then
					l_target.is_variable
				then
					if l_target.alias_object = Void then
						-- target doesn't exist yet (e.g. expanded type) -> create
						l_target.alias_object := create {ALIAS_OBJECT}.make (l_target.type)
					end
					Result := get_alias_info (l_target.alias_object, l_node.message)
				end
			elseif attached {BIN_FREE_AS} a_node as l_node then
				if
					attached get_alias_info (a_target, l_node.left) as l_target and then
					attached find_routine (l_node) as l_routine
				then
					Result := call_routine_with_arg (l_target.alias_object, l_routine, l_node.right)
				end
			elseif attached {EXPR_CALL_AS} a_node as l_node then
				Result := get_alias_info (a_target, l_node.call)
			elseif attached {PARAN_AS} a_node as l_node then
				Result := get_alias_info (a_target, l_node.expr)
			end

			if Result = Void then
				Io.put_string ("-> " + code(a_node) + " -> " + a_node.generator + "%N")
			end
		end

	find_routine (a_node: ID_SET_ACCESSOR): PROCEDURE_I
			-- Void for local variables and attributes
		require
			a_node /= Void
		do
			inspect a_node.routine_ids.count
			when 0 then
				-- local variable -> return Void
			when 1 then
				if attached {PROCEDURE_I} System.class_of_id (a_node.class_id).feature_of_rout_id (a_node.routine_ids.first) as l_r then
					-- routine
					Result := l_r
				else
					-- attribute -> return Void
				end
			end
		end

	call_routine_with_arg (a_target: ALIAS_OBJECT; a_routine: PROCEDURE_I; a_arg: EXPR_AS): ALIAS_OBJECT_INFO
		require
			a_routine /= Void
			a_arg /= Void
		local
			l_params: EIFFEL_LIST [EXPR_AS]
		do
			create l_params.make (1)
			l_params.extend (a_arg)
			Result := call_routine (a_target, a_routine, l_params)
		end

	call_routine (a_target: ALIAS_OBJECT; a_routine: PROCEDURE_I; a_params: EIFFEL_LIST [EXPR_AS]): ALIAS_OBJECT_INFO
		require
			a_routine /= Void
		local
			l_params: TWO_WAY_LIST [ALIAS_OBJECT_INFO]
		do
			create l_params.make
			if a_params /= Void then
				across a_params as c loop
					l_params.extend (get_alias_info (Void, c.item))
				end
			end

			alias_graph.stack_push (
					if a_target /= Void then a_target else alias_graph.stack_top.current_object end,
					a_routine
				)
			across l_params as c loop
				(create {ALIAS_OBJECT_INFO}.make_variable (
						alias_graph.stack_top.routine,
						alias_graph.stack_top.locals,
						a_routine.arguments.item_name (c.target_index)
					)).alias_object := c.item.alias_object
			end
			a_routine.body.process (Current)
			create Result.make_variable (
					alias_graph.stack_top.routine,
					alias_graph.stack_top.locals,
					"Result"
				)
			alias_graph.stack_pop
		end

	code (a_node: AST_EIFFEL): STRING_32
		require
			a_node /= Void
		local
			l_pretty_printer: PRETTY_PRINTER
		do
			create Result.make_empty
			create l_pretty_printer.make (create {PRETTY_PRINTER_OUTPUT_STREAM}.make_string (Result))
			l_pretty_printer.setup (
					alias_graph.stack_top.routine.written_class.ast,
					Match_list_server.item (alias_graph.stack_top.routine.written_class.class_id),
					True,
					True
				)
			l_pretty_printer.process_ast_node (a_node)
		end

invariant
	alias_graph /= Void

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
