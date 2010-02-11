note
	description: "[
			Predicate access pattern from a feature.
			This classes maintains a two way mapping from
			entities of a feature (target, argument) to arguments
			of a predicate.
			
			For example:
			
			l.put (v: ANY; i: INTEGER)
				require
					extendible: l.extendible
					not_has_v: not has (v)
					
			The predicate "extendible" is a one argument predicate, the first
			argument of the predicate is the target object.
			
			The predicate "not_has_v" is a two argument predicate, the first
			argument of the predicate is the target object, and then second 
			argument of the predicate is the first argument of the feature call.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_ACCESS_PATTERN

inherit
	HASHABLE
		redefine
			is_equal
		end

	DEBUG_OUTPUT
		undefine
			is_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_feature: like feature_; a_predicate: like predicate; a_access_pattern: like access_pattern; a_assertion: AUT_EXPRESSION) is
			-- Initialize current.
		require
			a_feature_attached: a_feature /= Void
			a_predicate_attached: a_predicate /= Void
			a_access_pattern_attached: a_access_pattern /= Void
			a_access_pattern_valid: is_argument_operand_mapping_valid (a_access_pattern, a_predicate, a_feature)
			a_assertion_attached: a_assertion /= Void
		do
			feature_ := a_feature
			predicate := a_predicate
			access_pattern := a_access_pattern
			assertion := a_assertion
		ensure
			feature_set: feature_ = a_feature
			predicate_set: predicate = a_predicate
			access_pattern_set: access_pattern = a_access_pattern
			assertion_set: assertion = a_assertion
		end

feature -- Access

	feature_: AUT_FEATURE_OF_TYPE
			-- Feature whose predicates are represented in Current

	context_class: CLASS_C is
			-- Class associated with `feature_'
		do
			Result := feature_.associated_class
		ensure
			good_result: Result = feature_.associated_class
		end

	predicate: AUT_PREDICATE
			-- Predicate associated with `feature_'

	access_pattern: DS_HASH_TABLE [INTEGER, INTEGER]
			-- Access patterns for the predicates associated with current feature.
			-- [0-based call operand index, 1-based predicate argument index]
			-- Key is the predicate argument index in `predicate'.
			-- Value is the 0-based call operand index of `feature_', 0 means
			-- the target object of the call.

	break_point_slot: INTEGER
			-- Break point slot indicating where current predicate appears in
			-- `feature_' viewed from `context_class'

	hash_code: INTEGER
			-- Hash code value
		local
			l_name: STRING
		do
			Result := internal_hash_code
			if Result = 0 then
				create l_name.make (64)
				l_name.append (context_class.name_in_upper)
				l_name.append_character ('.')
				l_name.append (feature_.feature_.feature_name)
				l_name.append_character (':')
				l_name.append_integer (break_point_slot)
				internal_hash_code :=  l_name.hash_code
				Result := internal_hash_code
			end
		end

	assertion: AUT_EXPRESSION
			-- Associated assertion expression

feature -- Status report

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		do
			Result :=
				predicate.is_equal (other.predicate) and then
				context_class.class_id = other.context_class.class_id and then
				feature_.feature_.equiv (other.feature_.feature_) and then
				access_pattern.is_equal (other.access_pattern)
		end

feature -- Status report

	is_argument_operand_mapping_valid (a_mapping: like access_pattern; a_predicate: like predicate; a_feature: like feature_): BOOLEAN is
			-- Is `a_mapping' from 0-based call operand index to 1-based predicate argument valid in the context
			-- of `a_predicate' and `a_feature'?
		require
			a_mapping_attached: a_mapping /= Void
			a_predicate_attached: a_predicate /= Void
			a_feature_attached: a_feature /= Void
		do
			Result :=
				a_mapping.count = a_predicate.arity and then
				a_mapping.keys.for_all (agent (a_key: INTEGER; a_pred: AUT_PREDICATE): BOOLEAN do Result := a_key >= 1 and then a_key <= a_pred.arity end (?, a_predicate)) and then
				a_mapping.for_all (agent (a_item: INTEGER; a_feat: AUT_FEATURE_OF_TYPE): BOOLEAN do Result := a_item >= 0 and then a_item <= a_feat.argument_count end (?, a_feature))
		end

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.			
		local
			l_cursor: DS_HASH_TABLE_CURSOR [INTEGER, INTEGER]
		do
			create Result.make (64)
			Result.append (predicate.text)
			Result.append (": ")
			from
				l_cursor := access_pattern.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				Result.append ("operand:")
				Result.append (l_cursor.item.out)
				Result.append ("-")
				Result.append ("argument:")
				Result.append (l_cursor.key.out)
				if not l_cursor.is_last then
					Result.append (", ")
				end
				l_cursor.forth
			end
		end

feature -- Setting

	set_break_point_slot (a_index: INTEGER) is
			-- Set `break_point_slot' with `a_index'.
		do
			break_point_slot := a_index
		ensure
			index_set: break_point_slot = a_index
		end

feature{NONE} -- Implementation

	internal_hash_code: INTEGER
			-- Cache for `hash_code'

invariant
	feature_attached: feature_ /= Void
	predicate_attached: predicate /= Void
	access_pattern_valid: is_argument_operand_mapping_valid (access_pattern, predicate, feature_)

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
