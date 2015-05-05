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

	index: INTEGER_32
		-- stop before this index when running the analyzer

	make (
				a_last_breakpoint: EDITOR_TOKEN_ALIAS_BREAKPOINT;
				a_gui_refresh_agent: PROCEDURE [ANY, TUPLE];
			)
		require
			a_last_breakpoint /= Void
			a_gui_refresh_agent /= Void
		local
			l_cur: EDITOR_TOKEN_ALIAS_BREAKPOINT
		do
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

			index := 1
			report := "[No report taken?!]";

			breakpoints[index].active := True
			gui_refresh_agent.call
		ensure
			index = 1
		end

	alias_analyzer_update (a_analyzer: ALIAS_ANALYZER_ON_RELATION; a_data: ANY)
		do
			if attached {AST_EIFFEL} a_data as ag_ast then
				if ag_ast.breakpoint_slot = 0 then
					(create {ETR_BP_SLOT_INITIALIZER}).init_with_context (
								breakpoints[1].pebble.routine.associated_feature_i.body,
								breakpoints[1].pebble.routine.associated_class
							)
				end
				if index = ag_ast.breakpoint_slot then
					--Io.put_string ("Taking report before " + ag_ast.generator + " (slot " + index.out + ").%N")
					report := a_analyzer.report
				end
			end
		end

feature

	report: STRING_32

	step
		require
			not is_done
		local
			l_analyzer: ALIAS_ANALYZER_ON_RELATION
		do
			breakpoints[index].active := False
			index := index + 1

			report := "[No report taken?!]";
			create l_analyzer.make
			l_analyzer.process_feature (
					breakpoints[1].pebble.routine.associated_feature_i,
					breakpoints[1].pebble.routine.associated_class,
					agent alias_analyzer_update (l_analyzer, ?)
				)
			if index = breakpoints.count then
				report := l_analyzer.report
			end

			breakpoints[index].active := True
			gui_refresh_agent.call
		end

	is_done: BOOLEAN
		do
			Result := index = breakpoints.count
		end

	terminate
		do
			-- nothing to do (yet)
		end

invariant
	breakpoints /= Void
	not breakpoints.is_empty
	across breakpoints as c all c.item /= Void end
	index >= breakpoints.lower
	index <= breakpoints.upper

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
