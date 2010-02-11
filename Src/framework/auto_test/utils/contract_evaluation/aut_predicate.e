note
	description: "Predicate used in predicate pool"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AUT_PREDICATE

inherit
	HASHABLE
		undefine
			is_equal
		end

	REFACTORING_HELPER
		undefine
			is_equal
		end

	DEBUG_OUTPUT
		undefine
			is_equal
		end

feature{NONE} -- Initialization

	make (a_types: DS_LIST [TYPE_A]; a_text: STRING; a_context_class: like context_class) is
			-- Initialize current.
		require
			a_types_attached: a_types /= Void
			a_types_valid: not a_types.there_exists (agent (a: TYPE_A): BOOLEAN do Result := a.is_like end)
		do
			create argument_types.make
			a_types.do_all (agent argument_types.force_last)

			text := a_text.twin
			context_class_internal := a_context_class
			create targets.make (2)
		end

feature -- Access

	id: INTEGER
			-- 1-based Idendity of current predicate
			-- Used for fast identification
			-- Note: this id is not used in equality comparison

	context_class: CLASS_C is
			-- Class where current predicate is viewed
		do
			fixme ("To be removed because `context_class' should be accessible through `expression.context_class'.");
			Result := context_class_internal
		ensure
			good_result: Result = context_class_internal
		end

	argument_types: DS_LINKED_LIST [TYPE_A]
			-- Type of all arguments of Current predicate
			-- Arguments are 1-based. The first argument of
			-- this predicate has index 1 and so on.

	arity: INTEGER
			-- Number of arguments of Current predicate
			-- Can be zero for constant predicate, for example,
			-- "{PLATFORM}.is_windows".
		do
			Result := argument_types.count
		ensure
			good_result: Result = argument_types.count
		end

	text: STRING
			-- Text of Current predicate
			-- The arguments in of the predicates are replaced by "{1}", "{2}"
			-- in the text. For example: "{1}.valid_cursor ({2})"
			-- All the feature name are final names (feature renaming is resolved).
			-- And all the calls are changed to qualified.
			-- "{1}" means the first argument of the predicate.

	text_with_type_name: STRING is
			-- Text of Current predicate with type name.
		local
			l_text: STRING
			l_cursor: DS_LINKED_LIST_CURSOR [TYPE_A]
			i: INTEGER
		do
			if text_with_type_name_cache = Void then
				create l_text.make (64)
				l_text.append (text)
				from
					l_cursor := argument_types.new_cursor
					i := 1
					l_cursor.start
				until
					l_cursor.after
				loop
					l_text.replace_substring_all ("{" + i.out + "}", "{" + l_cursor.item.actual_type.name + "}")
					i := i + 1
					l_cursor.forth
				end

				text_with_type_name_cache := l_text
			end
			Result := text_with_type_name_cache
		end

	hash_code: INTEGER
			-- Hash code value
		do
			Result := internal_hash_code
			if Result = 0 then
				internal_hash_code := (context_class.name_in_upper + text).hash_code
				Result := internal_hash_code
			end
		end

	targets: DS_HASH_SET [INTEGER]
			-- Positions of arguments (1-based) that are used as target
			-- of some feature call.

feature -- Equality

	is_equal (other: like Current): BOOLEAN
			-- Is `other' attached to an object considered
			-- equal to current object?
		local
			l_cur, l_other_cur: DS_LINKED_LIST_CURSOR [TYPE_A]
--			l_feat1, l_feat2: FEATURE_I
		do
				-- Two predicate are considered to be equal iff:
				-- 1. They come from the same class
				-- 2. They have the same number of arguments and each
				--    corresponding argument is of the same type
				-- 3. Text of these two predicates are equal.

				-- Check if both predicates come from the same class.
			if
				context_class.class_id = other.context_class.class_id and then
				argument_types.count = other.argument_types.count and then
				text ~ other.text
			then
					-- Check type equivalence of corresponding arguments.
				l_cur := argument_types.new_cursor
				l_other_cur := other.argument_types.new_cursor
				from
					Result := True
					l_cur.start
					l_other_cur.start
				until
					l_cur.after or else not Result
				loop
					Result :=
						l_cur.item.same_type (l_other_cur.item) and then
						l_cur.item.is_equivalent (l_other_cur.item)
					l_cur.forth
					l_other_cur.forth
				end

--				if Result then
--					l_feat1 := expression.context_feature
--					l_feat2 := other.expression.context_feature
--					if l_feat1 /= Void and then l_feat2 /= Void then
--						Result := (l_feat1.body_index = l_feat2.body_index) implies expression.line_number /= other.expression.line_number
--					end
--				end
			end
		end

feature -- Status report

	is_linear_solvable: BOOLEAN is
			-- Is current predicate linearly solvable?
		deferred
		end

	is_nullary: BOOLEAN is
			-- Does current predicate have no argument?
		do
			Result := arity = 0
		ensure
			good_result: Result = (arity = 0)
		end

	is_unary: BOOLEAN is
			-- Is current a unary predicate?
		do
			Result := arity = 1
		ensure
			good_result: Result = (arity = 1)
		end

	is_binary: BOOLEAN is
			-- Is Current a binary predicate?
		do
			Result := arity = 2
		ensure
			good_result: Result = (arity = 2)
		end

	is_argument_used_as_target (i: INTEGER): BOOLEAN is
			-- Is the `i'-th argument used as a target of a feature
			-- call in Current?
		require
			i_valid: i >= 1 and i <= arity
		do
			Result := targets.has (i)
		end

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

feature -- Setting

	set_id (a_id: like id)
			-- Set `id' with `a_id'.
		require
			a_id_positive: a_id > 0
		do
			id := a_id
		ensure
			id_set: id = a_id
		end

	set_arguments_as_target (a_targets: like targets) is
			-- Set `targets' with `a_targets'.
		do
			targets.wipe_out
			targets.append_last (a_targets)
		end

feature{NONE} -- Implementation

	context_class_internal: like context_class
			-- Storage for `context_class'

	internal_hash_code: like hash_code
		-- Cache `hash_code'

	text_with_type_name_cache: detachable STRING
			-- Cache for `text_with_type_name'

invariant
	id_positive: id > 0
	targets_attached: targets /= Void

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
