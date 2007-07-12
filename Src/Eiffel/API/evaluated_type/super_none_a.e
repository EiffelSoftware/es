indexing
	description: "Descritpion of an actual generical type."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class SUPER_NONE_A

inherit

	TYPE_A
		redefine
			format, valid_expanded_creation, expanded_deferred,
			 error_generics, good_generics, is_loose,
			 has_formal_generic, is_full_named_type ,is_valid ,
			 has_expanded, check_constraints,
			dump, type_i, same_as, has_associated_class, generics,
			instantiated_in, instantiation_in, deep_actual_type,
			valid_generic,
			has_like, has_like_argument, duplicate,
			is_equivalent,
			actual_argument_type, update_dependance,
			evaluated_type_in_descendant, is_super_none
		end

	HASHABLE

	DEBUG_OUTPUT

	SHARED_NAMES_HEAP
		export
			{NONE} all
		undefine
			is_equal,
			out
		end

create
	make

feature {NONE} -- Initialization

	make (g: like generics) is
			-- Create Current with `g' types as generic parameter.
		do
			if g = Void then
				create generics.make (1, 0)
			else
				generics := g
			end
		ensure
			generics_set: g /= Void implies generics = g and then g = Void implies generics /= Void
		end

feature -- Visitor

	process (v: TYPE_A_VISITOR) is
			-- Process current element.
		do
			v.process_super_none_a (Current)
		end

feature -- Elment change

	substitute (new_generics: ARRAY [TYPE_A]) is
			-- Take the arguments from `new_generics' to create an
			-- effective representation of the current GEN_TYPE
		require
			new_generics_not_void: new_generics /= Void
		local
			i, count, pos: INTEGER
			constraint_type: TYPE_A
			formal_type: FORMAL_A
			gen_type: GEN_TYPE_A
		do
			from
				i := 1
				count := generics.count
			until
				i > count
			loop
				constraint_type := generics.item (i)

				if constraint_type.is_formal then
					formal_type ?= constraint_type
					pos := formal_type.position
					generics.force (new_generics.item (pos), i)
				elseif constraint_type.generics /= Void then
					gen_type ?= constraint_type
					gen_type.substitute (new_generics)
				end
				i := i + 1
			end
		end

feature -- Comparison

	is_conforming_descendant (other: TYPE_A): BOOLEAN is
			-- Is `Current' conform to `other'?
		local
			l_generics, l_other_generics: like generics
			i, l_generics_count: INTEGER
		do
			l_generics := generics
				-- Generic count matches
			l_generics_count := generics.count
				-- TODO DIRTY HACK
			if other.is_super_none and False then
				Result := True
			else
				if other.has_generics then
					l_other_generics := other.generics
					if other.is_tuple then
						Result := l_generics_count < l_other_generics.count
					else
						Result := l_generics_count = l_other_generics.count or l_generics_count = 0
					end
				else
					Result := l_generics_count = 0
				end

				if Result and then l_generics_count > 0 then
					from
						i := 1
					until
						i > l_generics_count or not Result
					loop
						Result := l_generics.item (i).conform_to (l_other_generics.item (i))
						i := i + 1
					end
				end
			end
		end

	same_as (other: TYPE_A): BOOLEAN is
			-- Is the current type the same as `other' ?
		local
			other_super_none_type: like Current
			i, nb: INTEGER
			other_generics: like generics
		do
			other_super_none_type ?= other
			if
				other_super_none_type /= Void
			then
				from
					i := 1
					nb := generics.count
					other_generics := other_super_none_type.generics
					Result := nb = other_generics.count
				until
					i > nb or else not Result
				loop
					Result := generics.item (i).same_as (other_generics.item (i))
					i := i + 1
				end
			end
		end

	is_equivalent (other: like Current): BOOLEAN is
			-- Is `other' equivalent to the current object ?
		local
			i, nb: INTEGER
			l_other: SUPER_NONE_A
			other_generics: like generics
		do

			l_other ?= other
			Result := l_other /= Void
			if Result then
				from
					i := 1
					nb := generics.count
					other_generics := other.generics
					Result := nb = other_generics.count
				until
					i > nb or else not Result
				loop
					Result := equivalent (generics.item (i),
							other_generics.item (i))
					i := i + 1
				end
			end
		end

feature -- Output

	dump: STRING is
			-- Dumped trace
		local
			i, count: INTEGER
			class_name: STRING
		do
			Result := names_heap.item (names_heap.super_none_class_name_id).twin
			if generics /= Void then

				count := generics.count

				-- TUPLE may have zero generic parameters

				if count > 0 then
					Result.append (" [")
					from
						i := 1
					until
						i > count
					loop
						Result.append (generics.item (i).dump)
						if i /= count then
							Result.append (", ")
						end
						i := i + 1
					end
					Result.append ("]")
				end
			end
		end

	ext_append_to (st: TEXT_FORMATTER; c: CLASS_C) is
			-- Append to `st'
		local
			i, count: INTEGER
		do
			st.add (names_heap.item (names_heap.super_none_class_name_id))

			count := generics.count
				-- TUPLE may have zero generic parameters
			if count > 0 then
				st.add_space
				st.process_symbol_text (ti_L_bracket)
				from
					i := 1
				until
					i > count
				loop
					generics.item (i).ext_append_to (st, c)
					if i /= count then
						st.process_symbol_text (ti_Comma)
						st.add_space
					end
					i := i + 1
				end
				st.process_symbol_text (ti_R_bracket)
			end
		end

feature {COMPILER_EXPORTER} -- Primitives


	set_generics (g: like generics) is
			-- Assign `g' to `generics'.
		do
			generics := g
		end

	instantiated_in (class_type: TYPE_A): TYPE_A is
			-- Instantiation of Current in the context of `class_type'
			-- assuming that Current is written in the associated class
			-- of `class_type'.
		local
			i, count: INTEGER
			new_generics: like generics
		do
			from
				Result := duplicate
				i := 1
				count := generics.count
				new_generics := Result.generics
			until
				i > count
			loop
				new_generics.put
					(generics.item (i).instantiated_in (class_type), i)
				i := i + 1
			end
		end

	deep_actual_type: like Current is
			-- Actual type of Current; recursive version for generics
		local
			i: INTEGER
			new_generics: like generics
		do
			if not has_like then
				Result := Current
			else
				from
					i := generics.count
					create new_generics.make (1, i)
				until
					i <= 0
				loop
					new_generics.put (generics.item (i).deep_actual_type, i)
					i := i - 1
				end
				Result := twin
				Result.set_generics (new_generics)
			end
		end

	instantiation_in (type: TYPE_A; written_id: INTEGER): SUPER_NONE_A is
			-- TODO: new comment
		local
			i: INTEGER
			old_generics: like generics
			new_generics: like generics
			old_type: TYPE_A
			new_type: TYPE_A
		do
			Result := Current
			from
				old_generics := Result.generics
				i := old_generics.count
			until
				i <= 0
			loop
				old_type := old_generics.item (i)
				new_type := old_type.instantiation_in (type, written_id)
				if new_type /= old_type then
						-- Record a new type of a generic parameter.
					if new_generics = Void then
							-- Avoid modifying original type descriptor.
						Result := Result.duplicate
						new_generics := Result.generics
					end
					new_generics.put (new_type, i)
				end
				i := i - 1
			end
		end

	valid_generic (type: TYPE_A): BOOLEAN is
			-- Check generic parameters
		local
			i, count: INTEGER
			type_generics: like generics
			l_is_tuple: BOOLEAN
		do
			if type.has_generics then
				from
					i := 1
					l_is_tuple := type.is_tuple
					type_generics := type.generics
					count := generics.count
					if l_is_tuple then
						Result := count <= type_generics.count
					else
						Result := count = type_generics.count
					end
				until
					i > count or else not Result
				loop
					Result := type_generics.item (i).
						conform_to (generics.item (i))
					i := i + 1
				end
			else
					-- Class-type or formal
				Result := generics.count = 0
			end
		end

feature -- Status report

	is_super_none: BOOLEAN is
			-- Is the current actual type a super-none type ?
		do
			Result := True
		end

	has_like: BOOLEAN is
			-- Has the type anchored type in its definition ?
		local
			i, count: INTEGER
		do
			from
				i := 1
				count := generics.count
			until
				i > count or else Result
			loop
				Result := generics.item (i).has_like
				i := i + 1
			end
		end

	has_associated_class: BOOLEAN is
			-- Does `Current' have an assocaited class?
			--| The answer is no...
		do
			-- Result := False
		end


	has_expanded: BOOLEAN is
			-- Are some expanded type in the current generic declaration ?
		local
			i, count: INTEGER
		do
			from
				Result := is_expanded
				i := 1
				count := generics.count
			until
				i > count or else Result
			loop
				Result := generics.item (i).has_expanded
				i := i + 1
			end
		end

	is_valid: BOOLEAN is
		local
			i, count: INTEGER
		do
			from
				Result := True
				i := 1
				count := generics.count
			until
				i > count or else not Result
			loop
				Result := generics.item (i).is_valid
				i := i + 1
			end
		end

	is_full_named_type: BOOLEAN is
			-- Is Current a fully named type?
		local
			i, count: INTEGER
		do
			from
				i := 1
				count := generics.count
			until
				i > count or else Result
			loop
				Result := generics.item (i).is_full_named_type
				i := i + 1
			end
		end

	has_formal_generic: BOOLEAN is
			-- Has type a formal generic parameter?
		local
			i, count: INTEGER
		do
			from
				i := 1
				count := generics.count
			until
				i > count or else Result
			loop
				Result := generics.item (i).has_formal_generic
				i := i + 1
			end
		end

	is_loose: BOOLEAN is
			-- Does type depend on formal generic parameters and/or anchors?
		local
			g: like generics
			i: INTEGER
		do
			from
				g := generics
				i := g.count
			until
				i <= 0 or else Result
			loop
				Result := g.item (i).is_loose
				i := i - 1
			end
		end

		evaluated_type_in_descendant (a_ancestor, a_descendant: CLASS_C; a_feature: FEATURE_I): like Current is
		local
			i, nb: INTEGER
			new_generics: like generics
		do
			if a_ancestor /= a_descendant then
				if is_loose then
					from
						nb := generics.count
						create new_generics.make (1, nb)
						i := 1
					until
						i > nb
					loop
						new_generics.put (
							generics.item (i).evaluated_type_in_descendant (a_ancestor, a_descendant, a_feature),
							i)
						i := i + 1
					end
					Result := twin
					Result.set_generics (new_generics)
				else
					Result := Current
				end
			else
				Result := Current
			end
		end

	hash_code: INTEGER is
			-- Hash code value
		local
			i, nb: INTEGER
			l_cl_type_a: CL_TYPE_A
		do
			Result := 423245
			from
				i := 1
				nb := generics.count
			until
				i > nb
			loop
				l_cl_type_a ?= generics.item (i)
				if l_cl_type_a /= Void then
					Result := Result + l_cl_type_a.hash_code
				end
				i := i + 1
			end
				-- Clear sign if it becomes negative
			Result := 0x7FFFFFFF & Result
		end

	update_dependance (feat_depend: FEATURE_DEPENDANCE) is
			-- Update dependency for Dead Code Removal
		local
			i, count: INTEGER
		do
			from
				i := 1
				count := generics.count
			until
				i > count
			loop
				generics.item (i).update_dependance (feat_depend)
				i := i + 1
			end
		end

	actual_argument_type (a_arg_types: ARRAY [TYPE_A]): like Current is
		local
			i, count: INTEGER
			new_generics: like generics
		do
			if not has_like then
				Result := Current
			else
				from
					i := 1
					count := generics.count
					create new_generics.make (1, count)
				until
					i > count
				loop
					new_generics.put (generics.item (i).actual_argument_type (a_arg_types), i)
					i := i + 1
				end
				Result := twin
				Result.set_generics (new_generics)
-- MTN: mostlikeley not needed	Result.set_mark (declaration_mark)
			end
		end

	duplicate: like Current is
			-- Duplication
		local
			i, count: INTEGER
			duplicate_generics: like generics
		do
			from
				i := 1
				count := generics.count
				create duplicate_generics.make (1, count)
			until
				i > count
			loop
				duplicate_generics.put (generics.item (i).duplicate, i)
				i := i + 1
			end
			Result := twin
			Result.set_generics (duplicate_generics)
			if internal_upper /= Void then
				Result.set_upper (internal_upper.duplicate)
			end
		end

	has_like_argument: BOOLEAN is
			-- Has the type like argument in its definition?
		local
			i, count: INTEGER
		do
			from
				i := 1
				count := generics.count
			until
				i > count or else Result
			loop
				Result := generics.item (i).has_like_argument
				i := i + 1
			end
		end

feature -- Access

	associated_class: CLASS_C
			-- Assocaited class
		do
				-- Not intended to be called
			check false end
		end


	type_i: NONE is
			-- Meta generic interpretation of the generic type
		do
			-- not needed!
			check false end
		end

	create_info: CREATE_TYPE is
			-- Byte code information for entity type creation
		do
				-- Should never get to code generation
			check false end
		end

	generics: ARRAY [TYPE_A]
			-- Actual generical parameter

feature -- Status report

	good_generics: BOOLEAN is

		local
			i, count: INTEGER
		do
			-- Any number of generic parameters is allowed.
			-- Therefore we only check the gen. parameters.
			from
				Result := True
				count := generics.count
				i := 1
			until
				i > count or else not Result
			loop
				Result := generics.item (i).good_generics
				i := i + 1
			end
		end

	error_generics: VTUG is

		local
			i, count: INTEGER
		do
			-- Any number of generic parameters is allowed.
			-- Therefore we only check the gen. parameters.
			from
				count := generics.count
				i := 1
			until
				i > count or else (Result /= Void)
			loop
				if not generics.item (i).good_generics then
					Result := generics.item (i).error_generics
				end
				i := i + 1
			end
		end

	check_constraints (context_class: CLASS_C; a_context_feature: FEATURE_I;  a_check_creation_readiness: BOOLEAN) is
			-- Check the constrained genericity validity rule
		local
			i, count: INTEGER
			gen_param: TYPE_A
		do
				-- There are no constraints in a TUPLE type.
				-- Therefore we only check the gen. parameters.
			from
				i := 1
				count := generics.count
			until
				i > count
			loop
				gen_param := generics.item (i)
					-- Creation readiness check is set to false because:
					--  * one cannot inherit from TUPLE
					--  * there is no expanded entity
				gen_param.check_constraints (context_class, a_context_feature, False)
				i := i + 1
			end
		end

	delayed_creation_constraint_check (
			context_class: CLASS_C;
			a_context_feature: FEATURE_I;
			to_check: TYPE_A
			constraint_type: TYPE_SET_A
			formal_dec_as: FORMAL_CONSTRAINT_AS
			i: INTEGER;
			formal_type: FORMAL_A) is
				-- Check that declaration of generic class is conform to
				-- defined creation constraint in delayed mode.
		do
				-- The intention is that this feature is never called.
			check false end
		end

	creation_constraint_check (
			formal_dec_as: FORMAL_CONSTRAINT_AS
			a_constraint_types: TYPE_SET_A;
			context_class: CLASS_C;
			to_check: TYPE_A;
			i: INTEGER;
			formal_type: FORMAL_A) is
				-- Check that declaration of generic class is conform to
				-- defined creation constraint.	
		do
				-- The intention is that this feature is never called.
			check false end
		end

	expanded_deferred: BOOLEAN is
			-- Are the expanded class types present in the current generic
			-- type not based on deferred classes ?
		local
			i, nb: INTEGER
			gen_param: TYPE_A
		do
				-- The intention is that this never gets called.
			check false end
--			from
--				Result := False
--				i := 1
--				nb := generics.count
--			until
--				i > nb or else Result
--			loop
--				gen_param := generics.item (i)
--				if gen_param.has_expanded then
--					Result := gen_param.expanded_deferred
--				end
--				i := i + 1
--			end
		end

	valid_expanded_creation (a_class: CLASS_C): BOOLEAN is
			-- Is the expanded type has an associated class with one
			-- creation routine with no arguments only ?
		local
			i, nb: INTEGER
			gen_param: TYPE_A
		do
				-- The intention is that this feature is never called
			check false end
		end

	format (ctxt: TEXT_FORMATTER_DECORATOR) is
		local
			i, count: INTEGER
		do
			ctxt.add (names_heap.item (names_heap.super_none_class_name_id))
			count := generics.count

				-- SUPER_NONE may have zero generic parameters
			if count > 0 then
				ctxt.put_space
				ctxt.process_symbol_text (ti_L_bracket)
				from
					i := 1
				until
					i > count
				loop
					generics.item (i).format (ctxt)
					if i /= count then
						ctxt.process_symbol_text (ti_Comma)
						ctxt.put_space
					end
					i := i + 1
				end
				ctxt.process_symbol_text (ti_R_bracket)
			end
		end

	debug_output: STRING is
			-- Display name of associated class.
		do
			if is_valid then
				Result := dump
			else
				Result := "Class not in system anymore"
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

end -- class GEN_TYPE_A

