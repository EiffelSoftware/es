note
	description: "Operators that rewrite code using different constructs."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_REWRITING_OPS

feature -- Results

	modifications: LIST[ETR_AST_MODIFICATION]
			-- Modifications resulting from the last operator

	breakpoint_mappings: HASH_TABLE[INTEGER,INTEGER]
			-- Mappings between old and new breakpoints

feature -- Operations

	replace_assignment_attempts (a_transformable: ETR_TRANSFORMABLE)
			-- Replaces assignment attempts in `a_transformable'
		local
			l_visitor: ETR_ASS_ATTMPT_REPL_VISITOR
		do
			create l_visitor.make (a_transformable.context.class_context)
			l_visitor.replace_assignment_attempts_in (a_transformable.target_node)
			modifications := l_visitor.modifications
			breakpoint_mappings := l_visitor.breakpoint_mappings
		end

	replace_elseifs (a_transformable: ETR_TRANSFORMABLE)
			-- Removes one layer of elseifs from `a_transformable'
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
		do
			elseif_remover.remove_elseifs_in (a_transformable)
			modifications := elseif_remover.modifications
			breakpoint_mappings := elseif_remover.breakpoint_mappings
		end

	remove_ifs (a_transformable: ETR_TRANSFORMABLE; a_always_branch: BOOLEAN; a_process_first_only: BOOLEAN)
			-- Rewrites if's of `a_transformable' to always or never take the branch
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
		do
			if_remover.remove_ifs_in (a_transformable.target_node, a_always_branch, a_process_first_only)
			modifications := if_remover.modifications
			breakpoint_mappings := if_remover.breakpoint_mappings
		end

	replace_inspects (a_transformable: ETR_TRANSFORMABLE)
			-- Replaces inspects in `a_transformable' by normal conditionals
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
		do
			inspect_replacer.replace_inspects_in(a_transformable.target_node)
			modifications := inspect_replacer.modifications
			breakpoint_mappings := inspect_replacer.breakpoint_mappings
		end

	unroll_loop (a_transformable: ETR_TRANSFORMABLE; a_unroll_count: INTEGER; a_process_first_only: BOOLEAN)
			-- Unrolls loops in `a_transformable' `a_unroll_count' times
		require
			non_void: a_transformable /= void
			valid: a_transformable.is_valid
			count_pos: a_unroll_count>=0
		do
			loop_rewriter.rewrite_loops_in (a_transformable.target_node, a_unroll_count, a_process_first_only)
			modifications := loop_rewriter.modifications
			breakpoint_mappings := loop_rewriter.breakpoint_mappings
		end

feature {NONE} -- Implementation

	loop_rewriter: ETR_LOOP_REWRITING_VISITOR
		once
			create Result
		end

	if_remover: ETR_IF_REMOVING_VISITOR
		once
			create Result
		end

	elseif_remover: ETR_ELSEIF_REMOVING_VISITOR
		once
			create Result
		end

	inspect_replacer: ETR_INSPECT_REPL_VISITOR
		once
			create Result
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
