note
	description: "Transformable AST and context."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_TRANSFORMABLE
inherit
	ETR_SHARED_TOOLS
		redefine
			out
		end
	ETR_SHARED_LOGGER
		redefine
			out
		end
create
	make,
	make_invalid

convert
	to_ast: {AST_EIFFEL}

feature {NONE} -- creation

	make (a_node: like target_node; a_context: like context; duplicate: BOOLEAN)
			-- Make with `a_node' and `a_context'. Duplicate AST if `duplicate' set
		require
			non_void: a_node /= void and a_context /= void
		do
			if duplicate then
				ast_tools.duplicate_ast (a_node)
				target_node := ast_tools.duplicated_ast
			else
				target_node := a_node
			end

			context := a_context

			is_valid := true

			-- index it
			calculate_paths
		end

	make_invalid
			-- make and mark as invalid
		do
			context := void
			target_node := void
			is_valid := false
		end

feature -- Conversion

	to_ast: AST_EIFFEL
			-- `Current' as AST-node
		require
			is_valid: is_valid
		do
			Result := target_node
		end

feature {NONE} -- Implementation

	context_transformer: ETR_TRANSFORM_CONTEXT
			-- Shared instance of ETR_TRANSFORM_CONTEXT
		once
			create Result
		end

	path_initializer: ETR_AST_PATH_INITIALIZER
			-- Shared instance of ETR_AST_PATH_INITIALIZER
		once
			create Result
		end

	bp_initializer: ETR_BP_SLOT_INITIALIZER
			-- Shared instance of ETR_BP_SLOT_INITIALIZER
		once
			create Result
		end

	calculate_paths
			-- Calculate all the paths in `target_node'
		do
			if is_valid then
				path_initializer.process_from_root(target_node)
			end
		end

	apply_tracked_modifications(a_tracked_mods: LIST[ETR_TRACKABLE_MODIFICATION])
			-- Apply `a_tracked_mods'
		local
			l_modifier: ETR_AST_MODIFIER
			l_breakpoint_count: INTEGER
			l_map_chain: LINKED_LIST[HASH_TABLE[INTEGER,INTEGER]]
			l_new_mapping: like breakpoint_map
		do
			create l_modifier.make
			l_modifier.add_list (a_tracked_mods)
			l_modifier.apply_to (Current)
			target_node := l_modifier.modified_transformable.target_node

			-- update breakpoint-slots
			calculate_breakpoint_slots

			l_breakpoint_count := breakpoint_count

			l_new_mapping := tracking_tools.unified_breakpoint_mapping(a_tracked_mods, l_breakpoint_count)

			if has_code_tracking then
				-- If there already is code tracking
				-- Combine with the existing mapping
				breakpoint_map := tracking_tools.chained_breakpoint_mapping (breakpoint_map, l_new_mapping, l_breakpoint_count)
			else
				breakpoint_map := l_new_mapping
			end

			has_code_tracking := true
		end

feature -- Operation

	enable_code_tracking
			-- Enable this transformable to track modifications
		do
			-- Don't allow for nodes containing multiple features
			if attached {EIFFEL_LIST[FEATURE_AS]}target_node or attached {FEATURE_CLAUSE_AS}target_node or attached {CLASS_AS}target_node or attached {EIFFEL_LIST[FEATURE_CLAUSE_AS]}target_node then
				logger.log_warning ("Couldn't enable code tracking because contained ast contains multiple features.")
			else
				calculate_breakpoint_slots
				is_code_tracking_enabled := true
			end
		end

	calculate_breakpoint_slots
			-- Calculate the breakpoint slots in `target_node'
		do
			if is_valid then
				if not context.is_empty then
					bp_initializer.init_with_context (target_node, context.class_context.written_class)
				else
					bp_initializer.init_from (target_node)
				end
				are_breakpoints_calculated := true
			end
		end

	as_in_other_context (a_other_context: like context): like Current
			-- Transform `Current' to `a_other_context'
		require
			is_valid: is_valid
			valid_context: a_other_context /= void
		do
			context_transformer.transform_to_context (Current, a_other_context)
			Result := context_transformer.transformation_result
		end

	apply_modifications (a_modification_list: LIST[ETR_AST_MODIFICATION])
			-- Apply `a_modification_list' to `Current'
		require
			non_void: a_modification_list /= void
			valid: is_valid
		local
			l_modifier: ETR_AST_MODIFIER
			l_tracked_list: LINKED_LIST[ETR_TRACKABLE_MODIFICATION]
		do
			-- Check if we can track the modifactions
			if is_code_tracking_enabled then
				create l_tracked_list.make
				from
					a_modification_list.start
				until
					a_modification_list.after
				loop
					if a_modification_list.item.is_trackable then
						l_tracked_list.extend (a_modification_list.item.tracked_modification)
					end
					a_modification_list.forth
				end
			end

			-- Are all trackable?
			if is_code_tracking_enabled and then l_tracked_list.count=a_modification_list.count then
				apply_tracked_modifications (l_tracked_list)
			else
				-- Apply untrackable
				if is_code_tracking_enabled and then not l_tracked_list.is_empty then
					logger.log_warning ("{ETR_TRANSFORMABLE}.apply_modifications: Can't track modifications because only some are trackable.")
				end

				create l_modifier.make
				l_modifier.add_list (a_modification_list)
				l_modifier.apply_to (Current)
				target_node := l_modifier.modified_transformable.target_node

				-- update breakpoint-slots
				if are_breakpoints_calculated then
					calculate_breakpoint_slots
				end

				breakpoint_map := void
				has_code_tracking := false
			end
		end

	apply_modification (a_modification: ETR_AST_MODIFICATION)
			-- Apply `a_modification' to `Current'
		require
			non_void: a_modification /= void
			valid: is_valid
		local
			l_modifier: ETR_AST_MODIFIER
			l_mod_list: LINKED_LIST[ETR_AST_MODIFICATION]
		do
			create l_mod_list.make
			l_mod_list.extend (a_modification)
			apply_modifications (l_mod_list)
		end

feature -- Access

	breakpoint_count: INTEGER
			-- Number of breakpoints in `Current'
		do
			if is_valid then
				Result := ast_tools.num_breakpoint_slots_in (target_node)
			end
		end

	is_code_tracking_enabled: BOOLEAN
			-- Is code tracking enabled?

	breakpoint_map: HASH_TABLE[INTEGER, INTEGER]
			-- Map to determine code movement

	has_code_tracking: BOOLEAN
			-- Does the transformable contain a map to track code?

	are_breakpoints_calculated: BOOLEAN
			-- Have breakpoint slots been calculated in `target_node'

	path: detachable AST_PATH
			-- Path of `Current'
		do
			if attached target_node then
				Result := target_node.path
			end
		end

	context: detachable ETR_CONTEXT
			-- Context of the transformable

	target_node: detachable AST_EIFFEL
			-- AST belonging to the transformable

	is_valid: BOOLEAN
			-- Is `Current' valid?

feature -- Output

	out: STRING
			-- Print
		do
			if is_valid then
				Result := ast_tools.ast_to_string (target_node)
			else
				Result := "<INVALID>"
			end
		end

invariant
	valid_target: is_valid implies (attached target_node and attached context)
	tracking_has_breakpoits: has_code_tracking implies (are_breakpoints_calculated and breakpoint_map /= void)
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
