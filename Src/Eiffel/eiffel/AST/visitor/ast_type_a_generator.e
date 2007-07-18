indexing
	description: "Perform resolution of TYPE_AS into TYPE_A without validity checking."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	AST_TYPE_A_GENERATOR

inherit
	AST_NULL_VISITOR
		redefine
			process_like_id_as, process_like_cur_as,
			process_formal_as, process_class_type_as, process_none_type_as,
			process_bits_as, process_bits_symbol_as,
			process_named_tuple_type_as, process_type_dec_as,
			process_interval_type_as
		end

	COMPILER_EXPORTER
		export
			{NONE} all
		end

	SHARED_WORKBENCH
		export
			{NONE} all
		end

	SHARED_TYPES
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

	REFACTORING_HELPER
		export
			{NONE} all
		end

feature -- Status report

	evaluate_type_if_possible (a_type: TYPE_AS; a_context_class: CLASS_C): TYPE_A is
			-- Given a TYPE_AS node, try to find its equivalent CL_TYPE_A node.
		require
			a_type_not_void: a_type /= Void
			a_context_class_not_void: a_context_class /= Void
		local
			l_vtmc3: VTMC3
		do
			check not has_a_nil_error_occurred end
			is_failure_enabled := True
			current_class := a_context_class
			a_type.process (Current)
			Result := last_type
			if has_a_nil_error_occurred then
				has_a_nil_error_occurred := False
				create l_vtmc3
				l_vtmc3.set_message (system.names.item (system.names.super_none_class_name_id) + " not part of upper type in interval type!")
				l_vtmc3.set_class (system.current_class)
				l_vtmc3.set_type (a_type)
				error_handler.insert_error (l_vtmc3)
				error_handler.checksum
			end
			current_class := Void
			last_type := Void
		end

	evaluate_type (a_type: TYPE_AS; a_context_class: CLASS_C): TYPE_A is
			-- Given a TYPE_AS node, find its equivalent TYPE_A node.
		require
			a_type_not_void: a_type /= Void
			a_context_class_not_void: a_context_class /= Void
			a_type_is_in_universe: True -- All class identifiers of `a_type' are in the universe.
		local
			l_vtmc3: VTMC3
		do
			check not has_a_nil_error_occurred end
			is_failure_enabled := False
			current_class := a_context_class

			a_type.process (Current)
			Result := last_type
			if has_a_nil_error_occurred  then
				has_a_nil_error_occurred := False
				create l_vtmc3
				l_vtmc3.set_message (system.names.item (system.names.super_none_class_name_id) + " not part of upper type in interval type!")
				l_vtmc3.set_class (system.current_class)
				l_vtmc3.set_type (a_type)
				error_handler.insert_error (l_vtmc3)
				error_handler.checksum
			end
			current_class := Void
			last_type := Void
		ensure
			evaluate_type_not_void: Result /= Void
		end

	evaluate_class_type (a_class_type: CLASS_TYPE_AS; a_context_class: CLASS_C): CL_TYPE_A is
			-- Given a CLASS_TYPE_AS node, find its equivalent CL_TYPE_A node.
		require
			a_class_type_not_void: a_class_type /= Void
			a_context_class_not_void: a_context_class /= Void
			a_type_is_in_universe: True -- All class identifiers of `a_class_type' are in the universe.
		do
			is_failure_enabled := False
			current_class := a_context_class
			a_class_type.process (Current)
			Result ?= last_type
			current_class := Void
			last_type := Void
		ensure
			evaluate_type_not_void: Result /= Void
		end

feature {NONE} -- Implementation: Access

	last_type: TYPE_A
			-- Last resolved type of checker

	current_class: CLASS_C
			-- Current class where current type is resolved

	is_failure_enabled: BOOLEAN
			-- Is failure authorized?

feature {NONE} -- Visitor implementation

	process_like_id_as (l_as: LIKE_ID_AS) is
		do
			create {UNEVALUATED_LIKE_TYPE} last_type.make (l_as.anchor.name)
		end

	process_like_cur_as (l_as: LIKE_CUR_AS) is
		local
			l_actual_type: TYPE_A
			l_cur: LIKE_CURRENT
		do
			l_actual_type := current_class.actual_type
			l_actual_type.set_upper (super_none_type)
			create l_cur
			l_cur.set_actual_type (l_actual_type)
			last_type := l_cur
		end

	process_formal_as (l_as: FORMAL_AS) is
		do
			create {FORMAL_A} last_type.make (l_as.is_reference, l_as.is_expanded, l_as.position)
			if need_to_create_interval_type then
--				last_type.set_upper (super_none_type)
			end
			is_parent_an_interval := False
		end

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		local
			l_class_i: CLASS_I
			l_class_c: CLASS_C
			l_actual_generic: ARRAY [TYPE_A]
			i, count: INTEGER
			l_has_error: BOOLEAN
			l_type: TYPE_A
			l_need_to_create_interval: BOOLEAN
		do
			l_need_to_create_interval := need_to_create_interval_type
			is_parent_an_interval := False

			if l_as.class_name.name_id = {PREDEFINED_NAMES}.super_none_class_name_id then
				process_super_none_type (l_as)
			else
					-- Lookup class in universe, it should be present.
				l_class_i := universe.class_named (l_as.class_name.name, current_class.group)
				if l_class_i /= Void and then l_class_i.is_compiled then
					l_class_c := l_class_i.compiled_class
					if l_as.generics /= Void then

						from
							i := 1
							count := l_as.generics.count
							create l_actual_generic.make (1, count)
							l_type := l_class_c.partial_actual_type (l_actual_generic, l_as.is_expanded,
								l_as.is_separate)
						until
							i > count or l_has_error
						loop
							l_as.generics.i_th (i).process (Current)
							l_has_error := last_type = Void
							l_actual_generic.put (last_type, i)
							i := i + 1
						end
						if l_has_error then
							check failure_enabled: is_failure_enabled end
							last_type := Void
						else
							last_type := l_type
						end
					else
						l_type := l_class_c.partial_actual_type (Void, l_as.is_expanded, l_as.is_separate)
						last_type := l_type
					end
				else
					check failure_enabled: is_failure_enabled end
					last_type := Void
				end
			end
			if l_need_to_create_interval and then last_type /= Void then
				if l_actual_generic /= Void then
					last_type.set_upper (generic_super_none_type (l_actual_generic))
				else
					last_type.set_upper (super_none_type)
				end
			end
		end

	process_interval_type_as (l_as: INTERVAL_TYPE_AS) is
		local
			l_upper: TYPE_A
			l_lower: TYPE_A
			l_vtmc3: VTMC3
		do
			is_parent_an_interval := True
			is_upper_of_interval := False
			l_as.lower.process (Current)
			check is_parent_an_interval_false: is_parent_an_interval = false end
			if last_type = Void then
				check failure_enabled: is_failure_enabled end
			elseif need_to_create_interval_type then
				l_lower := last_type
					-- This is a hack which allowes us to keep one copy for most basic types.
					-- But if we have a real interval we twin. (That is to say we are in this procedure ;-)
				if l_lower.is_basic then
					l_lower := l_lower.twin
				end
				is_upper_of_interval := True
				is_parent_an_interval := True
				l_as.upper.process (Current)
				is_upper_of_interval := False
				check is_parent_an_interval_false: is_parent_an_interval = false end
				l_upper := last_type
					-- This is a hack which allowes us to keep one copy for most basic types.
					-- But if we have a real interval we twin. (That is to say we are in this procedure ;-)
				if l_upper.is_basic then
					l_upper := l_upper.twin
				end

				if last_type = Void then
					check failure_enabled: is_failure_enabled end
				else
					l_lower.set_upper (l_upper)
					last_type := l_lower
					if not last_type.is_valid_interval then
						create l_vtmc3
						l_vtmc3.set_message ("Upper type does not conform to lower type of interval!")
						l_vtmc3.set_class (system.current_class)
						l_vtmc3.set_type (l_as)
						error_handler.insert_error (l_vtmc3)
					end
				end
			end
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		local
			l_class_i: CLASS_I
			l_class_c: CLASS_C
			l_actual_generic: ARRAY [TYPE_A]
			i, g, count: INTEGER
			l_type: NAMED_TUPLE_TYPE_A
			l_generics: EIFFEL_LIST [TYPE_DEC_AS]
			l_names: SPECIAL [INTEGER]
			l_id_list: CONSTRUCT_LIST [INTEGER]
			l_has_error: BOOLEAN
			l_need_to_create_interval: BOOLEAN
		do
			l_need_to_create_interval := need_to_create_interval_type
			is_parent_an_interval := False
				-- Lookup class in universe, it should be present.
			l_class_i := System.tuple_class
			if l_class_i /= Void and then l_class_i.is_compiled then
				l_class_c := l_class_i.compiled_class
				l_generics := l_as.generics
				from
					i := 1
					g := 1
					count := l_as.generic_count
					create l_actual_generic.make (1, count)
					create l_names.make (count)
					create l_type.make (l_class_c.class_id, l_actual_generic, l_names)
				until
					i > count or l_has_error
				loop
					l_generics.i_th (g).process (Current)
					l_has_error := last_type = Void
					l_id_list := l_generics.i_th (g).id_list
					from
						l_id_list.start
					until
						l_id_list.after
					loop
						l_actual_generic.put (last_type, i)
						l_names.put (l_id_list.item, i - 1)
						i := i + 1
						l_id_list.forth
					end
					g := g + 1
				end
				if l_has_error then
					check failure_enabled: is_failure_enabled end
					last_type := Void
				else
					last_type := l_type
				end
			else
				check failure_enabled: is_failure_enabled end
				last_type := Void
			end
			if l_need_to_create_interval and then last_type /= Void then
				if l_actual_generic /= Void then
					last_type.set_upper (generic_super_none_type (l_actual_generic))
				else
					last_type.set_upper (super_none_type)
				end
			end
		end

	process_type_dec_as (l_as: TYPE_DEC_AS) is
		do
			l_as.type.process (Current)
		end

	process_none_type_as (l_as: NONE_TYPE_AS) is
		local
			l_actual_generics: ARRAY [TYPE_A]
			l_none_type: NONE_A
		do
			last_type := none_type
			if need_to_create_interval_type then
				last_type.set_upper (super_none_type)
			end
			is_parent_an_interval := False
		end

	process_bits_as (l_as: BITS_AS) is
		do
			create {BITS_A} last_type.make (l_as.bits_value.integer_32_value)
			if need_to_create_interval_type then
				last_type.set_upper (super_none_type)
			end
			is_parent_an_interval := False
		end

	process_bits_symbol_as (l_as: BITS_SYMBOL_AS) is
		do
			create {UNEVALUATED_BITS_SYMBOL_A} last_type.make (l_as.bits_symbol.name)
			if need_to_create_interval_type then
				last_type.set_upper (super_none_type)
			end
			is_parent_an_interval := False
		end

feature {NONE} -- Implementation

	process_generics (l_as: TYPE_LIST_AS): ARRAY [TYPE_A] is
		local
			i, count: INTEGER
			l_has_error: BOOLEAN
		do
			from
				i := 1
				count := l_as.count
				create Result.make (1, count)
			until
				i > count or l_has_error
			loop
				l_as.i_th (i).process (Current)
				l_has_error := last_type = Void
				Result.put (last_type, i)
				i := i + 1
			end
			if l_has_error then
				check failure_enabled: is_failure_enabled end
				Result := Void
			end
			last_type := Void
		end

	generic_super_none_type (a_generics: ARRAY [TYPE_A]): SUPER_NONE_A
			-- Super-none instance
		require
			a_generics_not_void: a_generics /= Void
		do
			create Result.make (a_generics)
		ensure
			Result_not_void: Result /= Void
			Result_has_generics: Result.generics = a_generics
		end

	need_to_create_interval_type: BOOLEAN is
			-- Do we need to create an interval type?
			--| This is true when the parent is not an interval type and
			--| the interval type system is enabled.
		do
		--	Result := not is_parent_an_interval and then current_class.is_interval_type_system_active
			Result := True
		end

	is_parent_an_interval: BOOLEAN
			-- Is the parent node an interval type?
			--| Set to true before processing the children of an interval type.
			--| Has to be set to false in every processing feature.

	is_upper_of_interval: BOOLEAN
			-- Is generating upper type of an interval?
			--| Set to true if we generate the upper type of an interval type.

	has_a_nil_error_occurred: BOOLEAN
			-- Has a nil error occurred?
			--| True is nil is not part of a upper bound of an interval type.

	process_super_none_type (l_as: CLASS_TYPE_AS)
			-- Process super none type.
			--| Part of new CAT call prevention.
		local
			l_super_none: SUPER_NONE_A
			l_class_i: CLASS_I
			l_class_c: CLASS_C
			l_actual_generic: ARRAY [TYPE_A]
			i, count: INTEGER
			l_has_error: BOOLEAN
			l_type: TYPE_A
		do
			if not is_upper_of_interval then
				has_a_nil_error_occurred := True
			end

			if l_as.generics /= Void then
				from
					i := 1
					count := l_as.generics.count
					create l_actual_generic.make (1, count)
					create {SUPER_NONE_A} l_type.make (l_actual_generic)
				until
					i > count or l_has_error
				loop
					l_as.generics.i_th (i).process (Current)
					l_has_error := last_type = Void
					l_actual_generic.put (last_type, i)
					i := i + 1
				end
				if l_has_error then
					check failure_enabled: is_failure_enabled end
					last_type := Void
				else
					last_type := l_type
				end
			else
				create {SUPER_NONE_A} last_type.make (l_actual_generic)
			end
		end

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software"
	license:	"GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options:	"http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful,	but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the	GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301  USA
		]"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"

end
