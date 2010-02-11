note
	description: "Summary description for {AUT_OBJECT_STATE_REQUEST_UTILITY}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_OBJECT_STATE_REQUEST_UTILITY

inherit
	SHARED_TYPES
		export {ANY} all end

	SHARED_WORKBENCH
		undefine
			system
		end

	AUT_AGENT_UTILITY [FEATURE_I]

feature -- Access

	supported_queries_of_type (a_type: TYPE_A): LIST [FEATURE_I] is
			-- Support queries to define an object state from `a_type'
		do
			create {LINKED_LIST [FEATURE_I]} Result.make
			if
				a_type.is_integer or else
				a_type.is_natural or else
				a_type.is_real_32 or else
				a_type.is_real_64 or else
				a_type.is_character or else
				a_type.is_character_32 or else
				a_type.is_boolean or else
				a_type.is_pointer
			then
				Result.extend (a_type.associated_class.feature_named ("item"))
			elseif
				not a_type.is_formal and then
				(a_type.conform_to (system.any_class.compiled_class, system.string_8_class.compiled_class.actual_type) or else
				 a_type.conform_to (system.any_class.compiled_class, system.string_32_class.compiled_class.actual_type))
			then
				Result.extend (a_type.associated_class.feature_named ("out"))
			else
				Result := features_of_type (
					a_type,
					anded_agents (<<
						ored_agents (<<
							agent is_boolean_query,
							agent is_integer_query>>),
					agent is_argumentless_query,
					agent is_exported_to_any,
					agent is_non_any_feature>>))
			end
		end

	features_of_type (a_type: TYPE_A; a_criterion: detachable FUNCTION [ANY, TUPLE [FEATURE_I], BOOLEAN]): LIST [FEATURE_I] is
			-- List of features satisfying `a_criterion' from `a_type'.
			-- `a_criterion' is a filter function used to selected wanted features: all the features causing
			-- `a_criterion' to return true are kept in the result.
			-- If `a_criterion' is Void, all features are returned.
			-- If there is no satisfying feature, an empty list will be returned.
		require
			a_type_attached: a_type /= Void
			a_type_valid: a_type /= none_type and then a_type.has_associated_class
		local
			l_class: CLASS_C
			l_feat_table: FEATURE_TABLE
			l_feature: FEATURE_I
			l_list: DS_ARRAYED_LIST [FEATURE_I]
			l_tester: AGENT_BASED_EQUALITY_TESTER [FEATURE_I]
			l_sorter: DS_QUICK_SORTER [FEATURE_I]
		do
			l_feat_table := a_type.associated_class.feature_table
			create {LINKED_LIST [FEATURE_I]} Result.make
			create l_list.make (10)
			from
				l_feat_table.start
			until
				l_feat_table.after
			loop
				l_feature := l_feat_table.item_for_iteration
				if a_criterion.item ([l_feature]) then
					l_list.force_last (l_feature)
				end
				l_feat_table.forth
			end
			create l_tester.make (agent (a, b: FEATURE_I):  BOOLEAN do Result := a.feature_name < b.feature_name end)
			create l_sorter.make (l_tester)
			l_sorter.sort (l_list)
			l_list.do_all (agent Result.extend)
		ensure
			result_attached: Result /= Void
		end

	final_feature (a_feature_name: STRING; a_written_class: CLASS_C; a_context_class: CLASS_C): detachable FEATURE_I is
			-- Final feature name for `a_feature_name' (which is written in `a_written_class') in `a_context_class'
			-- A Void return value means that the feature doesn't exist in `a_context_class'.
		require
			a_feature_name_attached: a_feature_name /= Void
			a_written_class_attached: a_written_class /= Void
			a_context_class_attached: a_context_class /= Void
		local
			l_feature: detachable FEATURE_I
		do
			l_feature := a_written_class.feature_named (a_feature_name)
			if l_feature /= Void then
				Result := a_context_class.feature_of_rout_id (l_feature.rout_id_set.first)
			else
				Result := a_context_class.feature_named (a_feature_name)
			end
		end

	final_argument_index (a_name: STRING; a_feature: FEATURE_I; a_written_class: CLASS_C): INTEGER is
			-- 1-based argument index of an argument `a_name' in feature `a_feature'.
			-- Resolve `a_name' in case that the argument name changes in inherited features.
			-- If there is no argument called `a_name' in `a_feature', return 0.
		local
			l_round: INTEGER
			l_arg_count: INTEGER
			l_feature: detachable FEATURE_I
			i: INTEGER
		do
			from
				l_round := 1
				l_feature := a_feature
				l_arg_count := l_feature.argument_count
			until
				l_round > 2 or else Result > 0
			loop
				from
					i := 1
				until
					Result > 0 or else i > l_arg_count
				loop
					if l_feature.arguments.item_name (i).is_case_insensitive_equal (a_name) then
						Result := i
					else
						i := i + 1
					end
				end

				if l_round = 1 then
					l_feature := a_written_class.feature_of_rout_id_set (a_feature.rout_id_set)
					if l_feature = Void then
						l_round := l_round + 1
					end
				end
				l_round := l_round + 1
			end
		end

feature -- Feature criteria

	is_boolean_query (a_feature: FEATURE_I): BOOLEAN is
			-- Is `a_feature' a boolean query?
		require
			a_feature_attached: a_feature /= Void
		do
			Result := a_feature.type /= Void and then a_feature.type.is_boolean
		end

	is_integer_query (a_feature: FEATURE_I): BOOLEAN is
			-- Is `a_feature' an integer query?
		require
			a_feature_attached: a_feature /= Void
		do
			Result := a_feature.type /= Void and then a_feature.type.is_integer
		end

	is_argumentless_query (a_feature: FEATURE_I): BOOLEAN is
			-- Is `a_feature' an argumentless query?
		require
			a_feature_attached: a_feature /= Void
		do
			Result := a_feature.type /= Void and then a_feature.argument_count = 0
		end

	is_exported_to_any (a_feature: FEATURE_I): BOOLEAN is
			-- Is `a_feature' exported to {ANY}?
		require
			a_feature_attached: a_feature /= Void
		do
			Result := a_feature.export_status.is_exported_to (system.any_class.compiled_class)
		end

	is_non_any_feature (a_feature: FEATURE_I): BOOLEAN is
			-- Is `a_feature' not written in class ANY?
		require
			a_feature_attached: a_feature /= Void
		do
			Result := a_feature.e_feature.written_class.class_id /= system.any_class.compiled_class.class_id
		end

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
