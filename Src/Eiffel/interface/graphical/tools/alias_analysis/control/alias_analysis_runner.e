note
	description: "The alias analysis runner/controller."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	ALIAS_ANALYSIS_RUNNER

create
	make

feature {NONE}

	breakpoints: ARRAY [EDITOR_TOKEN_ALIAS_BREAKPOINT]

	gui_refresh_agent: PROCEDURE [ANY, TUPLE]

	make (
				a_routine: PROCEDURE_I;
				a_last_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT;
				a_gui_refresh_agent: PROCEDURE [ANY, TUPLE]
			)
		require
			a_routine /= Void
			(a_last_breakpoint = Void) = (a_gui_refresh_agent = Void)
		local
			l_cur: EDITOR_TOKEN_ALIAS_BREAKPOINT
		do
			routine := a_routine
			if a_last_breakpoint /= Void then
				create breakpoints.make_filled (Void, 1, a_last_breakpoint.pebble.index)
				from
					l_cur := a_last_breakpoint
				until
					l_cur = Void
				loop
					check
						breakpoints[l_cur.pebble.index] = Void
					end
					breakpoints[l_cur.pebble.index] := l_cur
					l_cur := l_cur.previous_alias_breakpoint
				end
				gui_refresh_agent := a_gui_refresh_agent
			end

			index := 1
			step_until (1)
		ensure
			index = 1
		end

feature

	routine: PROCEDURE_I

	index: INTEGER_32
		-- analysis will execute this breakpoint index next

	as_string, as_graph: STRING_8

	step_over
		require
			not is_done
		do
			step_until (index + 1)
		end

	step_out
		require
			not is_done
		do
			step_until (routine.number_of_breakpoint_slots)
		end

	step_until (a_index: INTEGER_32)
		require
			not is_done
			a_index >= index
			a_index <= routine.number_of_breakpoint_slots
		local
			l_visitor: ALIAS_ANALYSIS_VISITOR
		do
			if breakpoints /= Void then
				breakpoints[index].active := False
			end

			index := a_index
			as_string := "[No report taken?!]"
			as_graph := ""

			if index = routine.number_of_breakpoint_slots then
				create l_visitor.make (routine, Void)
				routine.body.process (l_visitor)
				as_string := l_visitor.alias_graph.to_string
				as_graph := l_visitor.alias_graph.to_graph
			else
				create l_visitor.make (
						routine,
						agent (ag_node: AST_EIFFEL; ag_alias_graph: ALIAS_GRAPH)
							do
								if ag_node.breakpoint_slot = 0 then
									(create {ETR_BP_SLOT_INITIALIZER}).init_with_context (
												routine.e_feature.ast,
												routine.written_class
											)
								end
								if index = ag_node.breakpoint_slot then
									--Io.put_string ("Taking report before " + ag_node.generator + " (slot " + index.out + ").%N")
									as_string := ag_alias_graph.to_string
									as_graph := ag_alias_graph.to_graph
								end
							end
					)
				routine.body.process (l_visitor)
			end

			if breakpoints /= Void then
				breakpoints[index].active := True
				gui_refresh_agent.call
			end
		end

	is_done: BOOLEAN
		do
			Result := index = routine.number_of_breakpoint_slots
		end

invariant
	routine /= Void
	(breakpoints = Void) = (gui_refresh_agent = Void)
	breakpoints /= Void implies not breakpoints.is_empty
	breakpoints /= Void implies across breakpoints as c all c.item /= Void end
	breakpoints /= Void implies index >= breakpoints.lower
	breakpoints /= Void implies index <= breakpoints.upper

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
