note
	description: "Summary description for {AUT_CALL_BASED_REQUEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_CALL_BASED_REQUEST

inherit
	AUT_REQUEST

	ERL_G_TYPE_ROUTINES
		export {NONE} all end

	EPA_TYPE_UTILITY
		undefine
			system,
			type_a_generator
		end

feature -- Access

	target: ITP_VARIABLE
			-- Target for the call to feature `feature_to_call'
			-- In case of object creation, this means the object to be created

	target_type: TYPE_A
			-- Type of target for call to feature `feature_to_call'.
			-- In case of object creation, this means the type of the object to be created

	class_of_target_type: CLASS_C
			-- Direct base class of `target_type'
		require
			ready: is_setup_ready
		do
			Result := target_type.associated_class
		ensure
			definition: Result = target_type.associated_class
		end

	argument_list: detachable DS_LINEAR [ITP_EXPRESSION]
			-- Arguments used to invoke `procedure';
			-- Void if default creation procedure is to be used .

	feature_to_call: FEATURE_I
			-- Feature to be called in current request
		require
			ready: is_setup_ready
		deferred
		ensure
			result_attached: Result /= Void
		end

	argument_count: INTEGER
			-- Number of arguments in `feature_to_call'
			-- 0 if `feature_to_call' takes no argument.
		require
			ready: is_setup_ready
		do
			if feature_to_call /= Void then
				Result := feature_to_call.argument_count
			end
		ensure
			good_result:
				(feature_to_call /= Void implies Result = feature_to_call.argument_count) and then
				(feature_to_call = Void implies Result = 0)
		end

	feature_name_with_class: STRING
			-- Feature name with call in form of "CLASS.feature"
		do
			create Result.make (64)
			Result.append (class_of_target_type.name_in_upper)
			Result.append_character ('.')
			Result.append (feature_to_call.feature_name)
		end

	feature_id: INTEGER
			-- Id of the feature to call
			-- This is an ID used for predicate evaluation

	operand_indexes: SPECIAL [INTEGER] is
			-- Indexes of operands for the feature call in current
			-- Index 0 is for the target object, index 1 is for the first argument, and so on.
			-- The result object (if any) is placed in (Result.count - 1)-th position.
		deferred
		end

	operand_type_names: SPECIAL [STRING] is
			-- Type names of operands
		local
			l_types: like operand_types
			i: INTEGER
			c: INTEGER
		do
			l_types := operand_types
			c := l_types.count
			create Result.make_filled ("", c)
			from
				i := 0
			until
				i = c
			loop
				Result.put (l_types.item (i).name, i)
				i := i + 1
			end
		end

	operand_types: SPECIAL [TYPE_A]
			-- Types of operands
			-- Index 0 is for the target object, index 1 is for the first argument, and so on.
			-- The result object (if any) is placed in (Result.count - 1)-th position.
		deferred
		end

	operand_variable_index_table: HASH_TABLE [INTEGER, INTEGER]
			-- Table for the mapping from 0-based operand indexes to object indexes of those operands.
			-- Key is 0-based operand indexes (0 for target, 1 for the first argument, and so on, followed by possible result).
			-- Value is the index of the object for that operand in the object pool.
		local
			l_opd_indexes: like operand_indexes
			i: INTEGER
			c: INTEGER
		do
			l_opd_indexes := operand_indexes
			c := l_opd_indexes.count
			create Result.make (c)
			from
				i := 0
			until
				i = c
			loop
				Result.put (l_opd_indexes.item (i), i)
				i := i + 1
			end
		end

feature -- Status report

	is_setup_ready: BOOLEAN
			-- Is setup of current request ready?
		deferred
		end

	is_feature_query: BOOLEAN
			-- Is `feature_to_call' a query?
		require
			type_attached: target_type /= Void
		do
			Result := feature_to_call.type /= void_type
		ensure
			good_result: Result = (feature_to_call.type /= void_type)
		end

	has_argument: BOOLEAN
			-- Does `feature_to_call' has any formal argument?
		require
			is_ready: is_setup_ready
		do
			Result := argument_count > 0
		ensure
			good_result: Result = (argument_count > 0)
		end

	is_creation: BOOLEAN
			-- Is Current a creation procedure request?
		do
		end

feature -- Setting

	set_feature_id (a_id: INTEGER) is
			-- Set `feature_id' with `a_id'.
		require
			a_id_valid: a_id >= 0
		do
			feature_id := a_id
		ensure
			feature_id_set: feature_id = a_id
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
