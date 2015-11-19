class
	ALIAS_GRAPH

create
	make

feature {NONE}

	make (a_routine: PROCEDURE_I)
		require
			a_routine /= Void
		do
			create stack.make
			stack_push (
					create {ALIAS_OBJECT}.make (a_routine.written_class.actual_type),
					a_routine
				)
		ensure
			stack /= Void
			stack.count = 1
		end

feature {NONE}

	stack: TWO_WAY_LIST [ALIAS_ROUTINE]

feature {ANY}

	stack_top: ALIAS_ROUTINE
		do
			Result := stack.last
		end

	stack_push (a_current_object: ALIAS_OBJECT; a_routine: PROCEDURE_I)
		require
			a_current_object /= Void
			a_routine /= Void
		do
			stack.extend (create {ALIAS_ROUTINE}.make (
					a_current_object,
					a_routine,
					create {HASH_TABLE [ALIAS_OBJECT, STRING_8]}.make (16)
				))
		end

	stack_pop
		do
			stack.finish
			stack.remove
		end

	to_string: STRING_8
		local
			l_cycles: STRING_8
		do
			create l_cycles.make_empty
			create Result.make_empty

			compute_aliasing_info (stack.last, create {TWO_WAY_LIST [TUPLE [ALIAS_VISITABLE, STRING]]}.make, l_cycles)
			collect_aliasing_info (stack.last, Result)
			reset_visiting (stack.last)

			if not l_cycles.is_empty then
				Result.append ("%N%N-- Cycles:%N")
				Result.append (l_cycles)
			end
		end

	to_graph: STRING_8
		do
			create Result.make_empty
			Result.append ("digraph g {%N")
			Result.append ("	node [shape=box]%N")
			print_nodes (stack.last, create {CELL [NATURAL_32]}.put (0), Result)
			print_edges (stack.last, Result)
			Result.append ("}%N")
		end

feature {NONE}

	compute_aliasing_info (a_cur_node: ALIAS_VISITABLE; a_cur_path: TWO_WAY_LIST [TUPLE [av: ALIAS_VISITABLE; name: STRING]]; a_info: STRING_8)
		require
			a_cur_node /= Void
			a_cur_path /= Void
			a_info /= Void
		local
			l_cycle_head: like a_cur_path
		do
			a_cur_node.add_visiting_data (path_to_string (a_cur_path))
			if not a_cur_node.visited then
				a_cur_node.visited := True

				if attached {ALIAS_ROUTINE} a_cur_node as l_ar then
					compute_aliasing_info (l_ar.current_object, a_cur_path, a_info)
				end
				across a_cur_node.variables as c loop
					a_cur_path.extend ([a_cur_node, c.key])
					compute_aliasing_info (c.item, a_cur_path, a_info)
					a_cur_path.finish
					a_cur_path.remove
				end

				a_cur_node.visited := False
			else
				if not a_info.is_empty then
					a_info.append ("%N")
				end
				a_info.append (path_to_string (a_cur_path))
				a_info.append (" -> ")
				create l_cycle_head.make
				across
					a_cur_path as c
				until
					l_cycle_head = Void
				loop
					if c.item.av = a_cur_node then
						a_info.append (path_to_string (l_cycle_head))
						l_cycle_head := Void
					else
						l_cycle_head.extend (c.item)
					end
				end
			end
		end

	path_to_string (a_path: TWO_WAY_LIST [TUPLE [av: ALIAS_VISITABLE; name: STRING]]): STRING_8
		require
			a_path /= Void
		do
			if a_path.is_empty then
				Result := "Current"
			else
				Result := ""
				across a_path as c loop
					if c.target_index > 1 then
						Result.append (".")
					end
					Result.append (c.item.av.out)
					Result.append (".")
					Result.append (c.item.name)
				end
			end
		end

	collect_aliasing_info (a_cur_node: ALIAS_VISITABLE; a_info: STRING_8)
		require
			a_cur_node /= Void
			a_info /= Void
		do
			if not a_cur_node.visited then
				a_cur_node.visited := True

				if a_cur_node.visiting_data.count >= 2 then
					if not a_info.is_empty then
						a_info.append ("%N")
					end
					across a_cur_node.visiting_data as c loop
						if c.target_index > 1 then
							a_info.append (", ")
						end
						a_info.append (c.item)
					end
				end

				if attached {ALIAS_ROUTINE} a_cur_node as l_ar then
					collect_aliasing_info (l_ar.current_object, a_info)
				end
				across a_cur_node.variables as c loop
					collect_aliasing_info (c.item, a_info)
				end
			end
		end

	reset_visiting (a_cur_node: ALIAS_VISITABLE)
		require
			a_cur_node /= Void
		do
			if a_cur_node.visited then
				a_cur_node.visited := False
				a_cur_node.clear_visiting_data

				if attached {ALIAS_ROUTINE} a_cur_node as l_ar then
					reset_visiting (l_ar.current_object)
				end
				across a_cur_node.variables as c loop
					reset_visiting (c.item)
				end
			end
		end

	print_nodes (a_cur_node: ALIAS_VISITABLE; a_id: CELL [NATURAL_32]; a_output: STRING_8)
		require
			a_cur_node /= Void
			a_id /= Void
			a_output /= Void
		do
			if not a_cur_node.visited then
				a_cur_node.visited := True

				a_id.put (a_id.item + 1)
				a_cur_node.add_visiting_data ("b" + a_id.item.out)
				a_output.append ("	" + a_cur_node.visiting_data.last + "[label=<" + a_cur_node.out + ">]%N")

				if attached {ALIAS_ROUTINE} a_cur_node as l_ar then
					print_nodes (l_ar.current_object, a_id, a_output)
				end
				across a_cur_node.variables as c loop
					print_nodes (c.item, a_id, a_output)
				end
			end
		end

	print_edges (a_cur_node: ALIAS_VISITABLE; a_output: STRING_8)
		require
			a_cur_node /= Void
			a_output /= Void
		do
			if a_cur_node.visited then
				a_cur_node.visited := False

				if attached {ALIAS_ROUTINE} a_cur_node as l_ar then
					a_output.append ("	" + a_cur_node.visiting_data.last + "->" + l_ar.current_object.visiting_data.last + "[label=<Current>]%N")
					print_edges (l_ar.current_object, a_output)
				end
				across a_cur_node.variables as c loop
					a_output.append ("	" + a_cur_node.visiting_data.last + "->" + c.item.visiting_data.last + "[label=<" + c.key + ">]%N")
					print_edges (c.item, a_output)
				end
			end
		end

invariant
	stack /= Void
	not stack.is_empty
	across stack as c all c.item /= Void end

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
