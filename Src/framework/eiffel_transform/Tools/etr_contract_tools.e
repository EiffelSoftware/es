note
	description: "Features for counting and extracting contracts of features."
	date: "$Date$"
	revision: "$Revision$"

class
	ETR_CONTRACT_TOOLS

feature -- Extract contract expressions

	all_preconditions (a_feature: FEATURE_I): LIST[ETR_CONTRACT_EXPRESSION]
			-- Written and inherited complete preconditions of `a_feature'
		require
			non_void: a_feature /= void
		do
			Result := inherited_preconditions (a_feature)
			Result.append (preconditions (a_feature))
		ensure
			all_preconditions: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_precondition end)
			count_correct: Result.count = total_precondition_count (a_feature)
		end

	all_postconditions (a_feature: FEATURE_I): LIST[ETR_CONTRACT_EXPRESSION]
			-- Written and inherited complete postconditions of `a_feature'
		require
			non_void: a_feature /= void
		do
			Result := inherited_postconditions (a_feature)
			Result.append (postconditions (a_feature))
		ensure
			all_postconditions: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_postcondition end)
			count_correct: Result.count = total_postcondition_count (a_feature)
		end

	all_invariants (a_class: CLASS_C): LIST[ETR_CONTRACT_EXPRESSION]
			-- Written and inherited complete invariants of `a_class'
		require
			non_void: a_class /= void
		do
			Result := invariants (a_class)
			Result.append (inherited_invariants (a_class))
		ensure
			all_invariants: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_invariant end)
			count_correct: Result.count = total_invariant_count (a_class)
		end

	invariants (a_class: CLASS_C): LIST[ETR_CONTRACT_EXPRESSION]
			-- Complete invariants written in `a_class'
		require
			non_void: a_class /= void
		do
			create {LINKED_LIST[ETR_CONTRACT_EXPRESSION]}Result.make
			if a_class.has_invariant then
				Result.extend (create {ETR_CONTRACT_EXPRESSION}.make_invariant (a_class.invariant_ast, a_class))
			end
		ensure
			all_invariants: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_invariant end)
			count_correct: Result.count = invariant_count (a_class)
		end

	preconditions (a_feature: FEATURE_I): LIST[ETR_CONTRACT_EXPRESSION]
			-- Complete preconditions written in `a_feature'
		require
			non_void: a_feature /= void
		do
			create {LINKED_LIST[ETR_CONTRACT_EXPRESSION]}Result.make

			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				if l_rout.precondition /= void and then l_rout.precondition.assertions /= void then
					Result.extend (create {ETR_CONTRACT_EXPRESSION}.make_pre_post (l_rout.precondition, a_feature))
				end
			end
		ensure
			all_preconditions: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_precondition end)
			count_correct: Result.count = precondition_count (a_feature)
		end

	postconditions (a_feature: FEATURE_I): LIST[ETR_CONTRACT_EXPRESSION]
			-- Complete postconditions written in `a_feature'
		require
			non_void: a_feature /= void
		do
			create {LINKED_LIST[ETR_CONTRACT_EXPRESSION]}Result.make

			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				if l_rout.postcondition /= void and then l_rout.postcondition.assertions /= void then
					Result.extend (create {ETR_CONTRACT_EXPRESSION}.make_pre_post (l_rout.postcondition, a_feature))
				end
			end
		ensure
			all_postconditions: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_postcondition end)
			count_correct: Result.count = postcondition_count (a_feature)
		end

	inherited_invariants (a_class: CLASS_C): LIST[ETR_CONTRACT_EXPRESSION]
			-- Complete inherited postconditions of `a_feature'
		require
			non_void: a_class /= void
		local
			l_anc: LIST[CLASS_C]
		do
			create {LINKED_LIST[ETR_CONTRACT_EXPRESSION]} Result.make
			l_anc := ancestors (a_class)
			l_anc.do_all (agent (cls: CLASS_C; res: LIST[ETR_CONTRACT_EXPRESSION])
					do
						res.append (invariants (cls))
					end(?, Result))
		ensure
			all_invariants: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_invariant end)
			count_correct: Result.count = inherited_invariant_count (a_class)
		end

	inherited_postconditions (a_feature: FEATURE_I): LIST[ETR_CONTRACT_EXPRESSION]
			-- Complete inherited postconditions of `a_feature'
		require
			non_void: a_feature /= void
		local
			l_precursors: LIST[FEATURE_I]
		do
			create {LINKED_LIST[ETR_CONTRACT_EXPRESSION]} Result.make
			l_precursors := precursors (a_feature)

			l_precursors.do_all (agent (feat: FEATURE_I; res: LIST[ETR_CONTRACT_EXPRESSION])
					do
						res.append (postconditions (feat))
					end(?,Result))
		ensure
			all_postconditions: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_postcondition end)
			count_correct: Result.count = inherited_postcondition_count (a_feature)
		end

	inherited_preconditions (a_feature: FEATURE_I): LIST[ETR_CONTRACT_EXPRESSION]
			-- Complete inherited preconditions of `a_feature'
		require
			non_void: a_feature /= void
		local
			l_precursors: LIST[FEATURE_I]
		do
			create {LINKED_LIST[ETR_CONTRACT_EXPRESSION]} Result.make
			l_precursors := precursors (a_feature)

			l_precursors.do_all (agent (feat: FEATURE_I; res: LIST[ETR_CONTRACT_EXPRESSION])
					do
						res.append (preconditions (feat))
					end(?,Result))
		ensure
			all_preconditions: Result.for_all (agent (a: ETR_CONTRACT_EXPRESSION):BOOLEAN do Result := a.is_precondition end)
			count_correct: Result.count = inherited_precondition_count (a_feature)
		end

feature -- Count

	total_precondition_count (a_feature: FEATURE_I): INTEGER
			-- Total number of precondtions of `a_feature'
		require
			non_void: a_feature /= void
		do
			Result := precondition_count (a_feature) + inherited_precondition_count (a_feature)
		ensure
			count_pos: Result>=0
		end

	total_postcondition_count (a_feature: FEATURE_I): INTEGER
			-- Total number of postcondition of `a_feature'
		require
			non_void: a_feature /= void
		do
			Result := postcondition_count (a_feature) + inherited_postcondition_count (a_feature)
		ensure
			count_pos: Result>=0
		end

	total_invariant_count (a_class: CLASS_C): INTEGER
			-- Total number of invariants of `a_class'
		require
			non_void: a_class /= void
		do
			Result := invariant_count (a_class) + inherited_invariant_count (a_class)
		ensure
			count_pos: Result>=0
		end

	invariant_count (a_class: CLASS_C): INTEGER
			-- Number of complete postcondition written directly in `a_class'
		require
			non_void: a_class /= void
		do
			if a_class.has_invariant then
				Result := a_class.invariant_ast.assertion_list.count
			end
		ensure
			count_pos: Result>=0
		end

	postcondition_count (a_feature: FEATURE_I): INTEGER
			-- Number of complete postcondition written directly in `a_feature'
		require
			non_void: a_feature /= void
		do
			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				if l_rout.postcondition /= void and then l_rout.postcondition.assertions /= void then
					Result := l_rout.postcondition.assertions.count
				end
			end
		ensure
			count_pos: Result>=0
		end

	precondition_count (a_feature: FEATURE_I): INTEGER
			-- Number of complete preconditions written directly in `a_feature'
		require
			non_void: a_feature /= void
		do
			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				if l_rout.precondition /= void and then l_rout.precondition.assertions /= void then
					Result := l_rout.precondition.assertions.count
				end
			end
		ensure
			count_pos: Result>=0
		end

	inherited_invariant_count (a_class: CLASS_C): INTEGER
			-- Number of inherited complete invariants of `a_feature'
		require
			non_void: a_class /= void
		local
			l_anc: LIST[CLASS_C]
		do
			temp_count := 0
			l_anc := ancestors (a_class)
			l_anc.do_all (agent (cls: CLASS_C)
					do
						temp_count := temp_count + invariant_count (cls)
					end)
			Result := temp_count
		ensure
			count_pos: Result>=0
		end

	inherited_postcondition_count (a_feature: FEATURE_I): INTEGER
			-- Number of inherited complete postconditions of `a_feature'
		require
			non_void: a_feature /= void
		local
			l_precursors: LIST[FEATURE_I]
		do
			temp_count := 0
			l_precursors := precursors (a_feature)
			l_precursors.do_all (agent (feat: FEATURE_I)
					do
						temp_count := temp_count + postcondition_count (feat)
					end)
			Result := temp_count
		ensure
			count_pos: Result>=0
		end

	inherited_precondition_count (a_feature: FEATURE_I): INTEGER
			-- Number of inherited complete preconditions of `a_feature'
		require
			non_void: a_feature /= void
		local
			l_precursors: LIST[FEATURE_I]
		do
			temp_count := 0
			l_precursors := precursors (a_feature)
			l_precursors.do_all (agent (feat: FEATURE_I)
					do
						temp_count := temp_count + precondition_count (feat)
					end)
			Result := temp_count
		ensure
			count_pos: Result>=0
		end

feature -- Helpers

	precursors (a_feature: FEATURE_I): LIST[FEATURE_I]
			-- Precursors of `a_feature'
		require
			non_void: a_feature /= void
		local
			l_precursors: LIST[CLASS_C]
		do
			create {LINKED_LIST[FEATURE_I]}Result.make
			l_precursors := a_feature.e_feature.precursors

			if l_precursors /= void then
				from
					l_precursors.start
				until
					l_precursors.after
				loop
					if attached l_precursors.item.feature_of_rout_id_set (a_feature.rout_id_set) as l_feat then
						Result.extend (l_feat)
					end

					l_precursors.forth
				end
			end
		end

	ancestors (a_class: CLASS_C): LIST[CLASS_C]
			-- Ancestors of `a_class', no duplicates
		require
			non_void: a_class /= void
		do
			Result := ancestors_internal (a_class, create {HASH_TABLE[BOOLEAN,INTEGER]}.make(10))
		end

feature {NONE} -- Implementation	

	temp_count: INTEGER

	ancestors_internal (a_class: CLASS_C; a_processed: HASH_TABLE[BOOLEAN,INTEGER]): LIST[CLASS_C]
			-- Ancestors of `a_class', use `a_processed' to filter duplicates
		require
			non_void: a_class /= void and a_processed /= void
		local
			l_ancestors: LIST[CLASS_C]
		do
			create {LINKED_LIST[CLASS_C]}Result.make
			l_ancestors := a_class.parents_classes

			from
				l_ancestors.start
			until
				l_ancestors.after
			loop
				if not a_processed[l_ancestors.item.class_id] then
					a_processed.extend (true, l_ancestors.item.class_id)
					Result.extend (l_ancestors.item)
					Result.append (ancestors_internal (l_ancestors.item, a_processed))
				end

				l_ancestors.forth
			end
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
