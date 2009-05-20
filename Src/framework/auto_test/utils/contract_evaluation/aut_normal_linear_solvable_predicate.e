note
	description: "Summary description for {AUT_LINEAR_SOLVABLE_PREDICATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_NORMAL_LINEAR_SOLVABLE_PREDICATE

inherit
	AUT_LINEAR_SOLVABLE_PREDICATE

create
	make

feature{NONE} -- Initializaiton

	make (a_types: DS_LIST [TYPE_A]; a_text: STRING; a_context_class: like context_class; a_assertion: like assertion; a_constrained_arguments: like constrained_arguments; a_constraining_queries: like constraining_queries) is
			-- Initialize current.
		do
			create types.make
			a_types.do_all (agent types.force_last)
			text_internal := a_text.twin
			context_class := a_context_class
			assertion := a_assertion
			create constrained_arguments.make (a_constrained_arguments.count)
			from
				a_constrained_arguments.start
			until
				a_constrained_arguments.after
			loop
				constrained_arguments.force (a_constrained_arguments.item_for_iteration, a_constrained_arguments.key_for_iteration)
				a_constrained_arguments.forth
			end

			create constraining_queries.make (a_constraining_queries.count)
			constraining_queries.set_equality_tester (create {AGENT_BASED_EQUALITY_TESTER [STRING]}.make (agent (a, b: STRING): BOOLEAN do Result := a ~ b end))
			a_constraining_queries.do_all (agent constraining_queries.force_last)
		end

feature -- Access

	text: STRING is
			-- Text of Current predicate
			-- The arguments in of the predicates are replaced by "{1}", "{2}"
			-- in the text. For example: "{1}.valid_cursor ({2})"
		do
			Result := text_internal
		end

	assertion: AUT_ASSERTION
			-- Assertion associated with current predicates

	constrained_argument_indexes (a_feature: AUT_FEATURE_OF_TYPE): DS_HASH_SET [INTEGER] is
			-- Set of 1-based indexes of arguments that are linearly solvable in `a_feature'
		local
			l_feat: FEATURE_I
			i: INTEGER
			l_arg_count: INTEGER
			l_arg_name: STRING
		do
			l_feat := assertion.written_class.feature_of_rout_id_set (a_feature.feature_.rout_id_set)
			check l_feat /= Void end
			l_arg_count := l_feat.argument_count
			create Result.make (l_arg_count)
			from
				i := 1
			until
				i > l_arg_count
			loop
				l_arg_name := l_feat.arguments.item_name (i)
				constrained_arguments.do_all (
					agent (arg, arg2: STRING; ind: INTEGER; a_set: DS_HASH_SET [INTEGER])
						do
							if arg.is_case_insensitive_equal (arg2) then
								a_set.force_last (ind)
							end
						end (?, l_arg_name, i, Result))
				i := i + 1
			end
		end

feature{NONE} -- Implementation

	text_internal: like text;
			-- Implementation of `text'

note
	copyright: "Copyright (c) 1984-2009, Eiffel Software"
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
