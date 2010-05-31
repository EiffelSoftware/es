note
	description: "Summary description for {AUT_OBJECT_STATE_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_OBJECT_STATE_TABLE

inherit
	AUT_SHARED_RANDOM
		export {NONE} all end

	REFACTORING_HELPER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create variables_by_object_states_table.make_default
			create invoked_source_object_states_table.make_default
		end

feature -- Access

	encountered_object_states (a_type: TYPE_A): DS_ARRAYED_LIST[AUT_OBJECT_STATE] is
			-- List of encountered object states of the given type
		require
			a_type_attached: a_type /= Void
		do
			create Result.make_default
			Result.set_equality_tester (create {KL_EQUALITY_TESTER[AUT_OBJECT_STATE]})

			if variables_by_object_states_table.has (a_type) and then variables_by_object_states_table.item (a_type) /= Void then
				Result.append_first (variables_by_object_states_table.item (a_type).keys)
			end
		ensure
			result_attached: Result /= Void
		end

	invoked_source_object_states (a_feature: FEATURE_I; a_type: TYPE_A): DS_ARRAYED_LIST[AUT_OBJECT_STATE] is
			-- List of object states which were already invoke for given feature (of given type)
		require
			a_feature_attached: a_feature /= Void
			a_type_attached: a_type /= Void
		local
			l_by_features_table: DS_HASH_TABLE [DS_HASH_SET [AUT_OBJECT_STATE], FEATURE_I]
		do
			create Result.make_default
			Result.set_equality_tester (create {KL_EQUALITY_TESTER[AUT_OBJECT_STATE]})

			l_by_features_table := Void

			if invoked_source_object_states_table.has (a_type) then
				l_by_features_table := invoked_source_object_states_table.item (a_type)
			end

			if l_by_features_table /= Void and then l_by_features_table.has (a_feature) then
				Result.append_first (l_by_features_table.item (a_feature))
			end
		ensure
			result_attached: Result /= Void
		end

	untried_object_states (a_feature: FEATURE_I; a_type: TYPE_A): DS_ARRAYED_LIST[AUT_OBJECT_STATE] is
			-- List of object states which were not yet invoked for given feature (of given type)
		require
			a_feature_attached: a_feature /= Void
			a_type_attached: a_type /= Void
		local
			l_encountered_object_states: DS_ARRAYED_LIST[AUT_OBJECT_STATE]
			l_invoked_source_object_states: DS_ARRAYED_LIST[AUT_OBJECT_STATE]
		do
			l_invoked_source_object_states := invoked_source_object_states (a_feature, a_type)
			Result := encountered_object_states (a_type)

			from
				l_invoked_source_object_states.start
			until
				l_invoked_source_object_states.after
			loop
				if Result.has (l_invoked_source_object_states.item_for_iteration) then
					Result.delete (l_invoked_source_object_states.item_for_iteration)
				end
				l_invoked_source_object_states.forth
			end
		ensure
			result_attached: Result /= Void
		end

	random_variable (an_object_state: AUT_OBJECT_STATE; a_type: TYPE_A): ITP_VARIABLE is
			-- Choose a random variable among all those in given object state (of given type)
		require
			an_object_state_attached: an_object_state /= Void
			a_type_attached: a_type /= Void
		local
			l_object_states_table: DS_HASH_TABLE[DS_HASH_SET[ITP_VARIABLE], AUT_OBJECT_STATE]
			l_variable_set: DS_HASH_SET[ITP_VARIABLE]
			i: INTEGER
		do
			if variables_by_object_states_table.has (a_type) then
				l_object_states_table := variables_by_object_states_table.item (a_type)
			end

			if l_object_states_table /= Void and then l_object_states_table.has (an_object_state) then
				l_variable_set := l_object_states_table.item (an_object_state)
			end

			if l_variable_set /= Void then
				random.forth
				i := (random.item \\ l_variable_set.count)

				from
					l_variable_set.start
				until
					i = 0 or l_variable_set.after
				loop
					l_variable_set.forth
					i := i - 1
				end

				Result := l_variable_set.item_for_iteration
			end
		end

feature -- Element change

	put_variable (a_variable: ITP_VARIABLE; an_object_state: AUT_OBJECT_STATE; a_type: TYPE_A) is
			-- Puts the variable in a given object state and of a given type into the table
		require
			a_variable_attached: a_variable /= Void
			an_object_state_attached: an_object_state /= Void
			a_type: a_type /= Void
		local
			l_object_states_table: DS_HASH_TABLE[DS_HASH_SET[ITP_VARIABLE], AUT_OBJECT_STATE]
			l_variable_set: DS_HASH_SET[ITP_VARIABLE]
		do
			if not variables_by_object_states_table.has (a_type) then
				create l_object_states_table.make_default
				variables_by_object_states_table.force (l_object_states_table, a_type)
			else
				l_object_states_table := variables_by_object_states_table.item (a_type)
			end

			if not l_object_states_table.has (an_object_state) then
				create l_variable_set.make_default
				l_object_states_table.force (l_variable_set, an_object_state)
			else
				l_variable_set := l_object_states_table.item (an_object_state)
			end

			if not l_variable_set.has (a_variable) then
				l_variable_set.force (a_variable)
			end
		ensure
			variables_by_object_states_table_not_smaller: variables_by_object_states_table.count >= old variables_by_object_states_table.count
		end

	put_invoked_source_object_state (an_object_state: AUT_OBJECT_STATE; a_feature: FEATURE_I; a_type: TYPE_A) is
			-- Puts the object state into the table of invoked source object states
		require
			an_object_state_attached: an_object_state /= Void
			a_feature_attached: a_feature /= Void
			a_type: a_type /= Void
		local
			l_features_table: DS_HASH_TABLE[DS_HASH_SET[AUT_OBJECT_STATE], FEATURE_I]
			l_object_states_set: DS_HASH_SET[AUT_OBJECT_STATE]
		do
			if not invoked_source_object_states_table.has (a_type) then
				create l_features_table.make_default
				invoked_source_object_states_table.force (l_features_table, a_type)
			else
				l_features_table := invoked_source_object_states_table.item (a_type)
			end

			if not l_features_table.has (a_feature) then
				create l_object_states_set.make_equal (10)
				l_features_table.force (l_object_states_set, a_feature)
			else
				l_object_states_set := l_features_table.item (a_feature)
			end

			if not l_object_states_set.has (an_object_state) then
				l_object_states_set.force (an_object_state)
			end
		ensure
			invoked_source_object_states_table_not_smaller: invoked_source_object_states_table.count >= old invoked_source_object_states_table.count
		end

feature {NONE} -- Implementation

	variables_by_object_states_table: DS_HASH_TABLE[DS_HASH_TABLE[DS_HASH_SET[ITP_VARIABLE], AUT_OBJECT_STATE], TYPE_A]
			-- Table of variables by object states (of a class type)

	invoked_source_object_states_table: DS_HASH_TABLE[DS_HASH_TABLE[DS_HASH_SET[AUT_OBJECT_STATE], FEATURE_I], TYPE_A]
			-- Table of object states that a given feature (of a class type) was already called on

invariant
	variables_by_object_states_table_attached: variables_by_object_states_table /= Void
	invoked_source_object_states_table_attached: invoked_source_object_states_table /= Void

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
