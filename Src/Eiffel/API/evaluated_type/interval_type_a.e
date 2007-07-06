indexing
	description: "[
		todo
	]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	INTERVAL_TYPE_A

inherit
	COMPILER_EXPORTER

	TYPE_A
		rename
			lower_type as lower
		redefine
			instantiated_in, instantiation_in,
			check_constraints,
			has_associated_class,
			generics,
			meta_type,
			lower
		end

	SHARED_TEXT_ITEMS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_lower: like lower; a_upper: like upper) is
			-- Initialize
		require
			a_lower_not_void: a_lower /= Void
			a_upper_not_void: a_upper /= Void
		do
			lower := a_lower
			upper := a_upper
		ensure
			lower_set: a_lower = lower
			upper_set: upper = a_upper
		end

feature -- Access

	lower: TYPE_A
			-- Lower bound

	upper: TYPE_A
			-- Upper bound

feature {COMPILER_EXPORTER} -- Access

	associated_class: CLASS_C is
			-- Class associated to the current type.		
		do
			Result := lower.associated_class
		end

	conform_to (other: TYPE_A): BOOLEAN is
			-- Does Current conform to `other' ?
		local
			other_interval: INTERVAL_TYPE_A
		do
			other_interval ?= other
			if other_interval = Void then
					-- Depending on how the default behaviour is for a single type one has to do changes here.
					-- Currently we have the default that A <=> A..NONE
--				Result := lower.same_as (upper) and then lower.same_as (other)
				Result := lower.conform_to (other)
				-- and then other.conform_to (upper)
			else
				Result := lower.conform_to (other_interval.lower) and then other_interval.upper.conform_to (upper)
			end
		end

	instantiated_in (a_class_type: TYPE_A): INTERVAL_TYPE_A is
			-- Instantiation of Current in the context of `class_type'
			-- assuming that Current is written in the associated class
			-- of `class_type'.
		do
			create Result.make (lower.instantiated_in (a_class_type), upper.instantiated_in (a_class_type))
		end

	instantiation_in (a_class_type: TYPE_A; a_written_id: INTEGER): INTERVAL_TYPE_A is
			-- Instantiation of Current in the context of `class_type'
			-- assuming that Current is written in the class of id `written_id'.
		do
			create Result.make (lower.instantiation_in (a_class_type, a_written_id), upper.instantiation_in (a_class_type, a_written_id))
		end

	type_i: TYPE_I is
			-- C type
		do
			Result := lower.type_i
		end

	meta_type: TYPE_I is
			-- Meta type
		do
			Result := lower.meta_type
		end

	generics: ARRAY [TYPE_A] is
			-- Actual generic types
		do
			Result := lower.generics
		end

	create_info: CREATE_INFO is
			-- Byte code information for entity type creation
		do
			Result := lower.create_info
		end
feature {COMPILER_EXPORTER} -- Validity checks

 check_constraints (a_type_context: CLASS_C; a_context_feature: FEATURE_I; a_check_creation_readiness: BOOLEAN) is
			-- Check the constained genericity validity rule and leave
			-- error info in `constraint_error_list'
		do
			lower.check_constraints (a_type_context, a_context_feature, a_check_creation_readiness)
				-- The upper type does not have to be creation ready.
			upper.check_constraints (a_type_context, a_context_feature, false)
		end

feature -- Comparison

	is_equivalent (other: like Current): BOOLEAN is
			-- Is `other' equivalent to the current object ?
		do
			Result := lower.is_equivalent (other.lower) and then upper.is_equivalent (other.upper)
		end

feature -- Visitor

	process (v: TYPE_A_VISITOR) is
			-- Process current element.
		do
			v.process_interval_type_a (Current)
		end

feature -- Status

	has_associated_class: BOOLEAN
			-- Does current type have an associated class?
		do
			Result := lower.has_associated_class
		end

feature -- Output

	ext_append_to (a_text_formatter: TEXT_FORMATTER; c: CLASS_C) is
			-- Append `Current' to `text'.
			-- `f' is used to retreive the generic type or argument name as string.
			-- This replaces the old "G#2" or "arg#1" texts in feature signature views.
			-- Actually used in FORMAL_A and LIKE_ARGUMENT.		
		do
			lower.ext_append_to (a_text_formatter, c)
			a_text_formatter.add_space
			a_text_formatter.process_symbol_text (ti_dotdot)
			a_text_formatter.add_space
			upper.ext_append_to (a_text_formatter, c)
		end

	dump: STRING is
			-- Dumped trace
		do
			Result := lower.dump
			Result.append (ti_dotdot)
			Result.append (upper.dump)
		end

invariant
	lower_not_void: lower /= Void
	upper_not_void: upper /= Void

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
