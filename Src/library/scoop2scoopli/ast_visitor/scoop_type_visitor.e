note
	description: "[
					Roundtrip visitor to determine type.
					Usage: See note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_TYPE_VISITOR

inherit
	AST_ROUNDTRIP_ITERATOR
		export
			{NONE} all
			{ANY} setup
		redefine
			process_bits_as,
			process_bits_symbol_as,
			process_class_type_as,
			process_generic_class_type_as,
			process_formal_as,
			process_like_cur_as,
			process_like_id_as,
			process_named_tuple_type_as,
			process_none_type_as,
			process_type_dec_as
		end

	SCOOP_BASIC_TYPE
		export
			{NONE} all
		end

	SCOOP_WORKBENCH
		export
			{NONE} all
		end

	SHARED_ERROR_HANDLER
		export
			{NONE} all
		end

feature -- Access

	evaluate_class_from_type (a_type: TYPE_AS; a_base_class: CLASS_C): CLASS_C is
			-- Given a TYPE_AS node, try to find its equivalent CLASS_C node.
		require
			a_type_not_void: a_type /= Void
			a_base_class_not_void: a_base_class /= Void
		local
			i: INTEGER
			class_i: CLASS_I
		do
			last_class_name := Void
			last_class_c := Void
			is_formal := False
			is_tuple_type := False
			is_separate := False
			is_a_like_type := False
			is_class_type := False

			base_class := a_base_class

			a_type.process (Current)

			-- get associated class
			if last_class_name /= Void then

				class_i := system.universe.class_named (last_class_name, a_base_class.group)
				if class_i /= Void then
					last_class_c := class_i.compiled_class
				elseif base_class.generics /= Void then
					-- test if the current type is a formal generic parameter
					from i := 1	until i > base_class.generics.count loop
						if base_class.generics.i_th (i).name.name.as_upper.is_equal (last_class_name) then
							is_formal := True
						end
						i := i + 1
					end
				else
					-- should not be the case
					error_handler.insert_error (create {INTERNAL_ERROR}.make("SCOOP Unexpected error: {SCOOP_TYPE_VISITOR}.evaluate_class_from_type."))
				end
			end

			-- check: it cannot be separate be if it is of basic type
			if last_class_c /= Void and then is_special_class (last_class_c.name_in_upper) then
				is_separate := False
			end

			Result := last_class_c
		ensure
			Result_not_void_when_or_formal: Result /= Void or is_formal
		end

	is_formal: BOOLEAN
			-- Is last resolved type formal?

	is_tuple_type: BOOLEAN
			-- Is last resolved type of type tuple?

	is_separate: BOOLEAN
			-- Is last resolved type separate?

	is_a_like_type: BOOLEAN
			-- Is last resolved type a like type?

	is_class_type: BOOLEAN
			-- Is last resolved type of class type?

feature {NONE} -- Visitor implementation

	process_like_id_as (l_as: LIKE_ID_AS) is
		local
			l_type_a: TYPE_A
			l_type_as: TYPE_AS
			l_class_c: CLASS_C
			l_typ_visitor: like Current
		do
			if base_class.feature_table.has (l_as.anchor.name.as_lower) then
				l_type_a := base_class.feature_table.item (l_as.anchor.name.as_lower).type
				if l_type_a.is_formal then
					is_formal := True
				else
					if l_type_a.associated_class /= Void then
						create last_class_name.make_from_string (l_type_a.associated_class.name_in_upper)
					else
						-- may be the case when a like type refers to a like type of generic type
						-- todo: check other implementation
						is_formal := l_type_a.actual_type.is_formal
						create last_class_name.make_from_string (l_type_a.actual_type.name.as_upper)
					end

				end
				is_separate := l_type_a.is_separate
			elseif feature_as.body.internal_arguments /= Void then
				-- check internal arguments
				if feature_object.arguments.has (l_as.anchor.name) then
					l_type_as := feature_object.arguments.get_type_by_name (l_as.anchor.name.as_lower)
					create l_typ_visitor
					l_typ_visitor.setup (class_as, match_list, True, True)
					l_class_c := l_typ_visitor.evaluate_class_from_type (l_type_as, class_c)
					create last_class_name.make_from_string (l_class_c.name_in_upper)
				end
			end
			is_a_like_type := True
		end

	process_like_cur_as (l_as: LIKE_CUR_AS) is
		do
			last_class_name := base_class.name_in_upper
			is_a_like_type := True
		end

	process_formal_as (l_as: FORMAL_AS) is
		do
			is_formal := True
			last_class_name := l_as.name.name.as_upper
		end

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			last_class_name := l_as.class_name.name.as_upper
			is_separate := l_as.is_separate
			is_class_type := True
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		do
			last_class_name := l_as.class_name.name
			is_separate := l_as.is_separate
			is_class_type := True
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			is_tuple_type := True
			last_class_name := l_as.class_name.name.as_upper
			is_separate := l_as.is_separate
		end

	process_type_dec_as (l_as: TYPE_DEC_AS) is
		do
			l_as.type.process (Current)
		end

	process_none_type_as (l_as: NONE_TYPE_AS) is
		do
			last_class_name := l_as.class_name_literal.name.as_upper
		end

	process_bits_as (l_as: BITS_AS) is
		do
			last_class_name := Void
		end

	process_bits_symbol_as (l_as: BITS_SYMBOL_AS) is
		do
			last_class_name := Void
		end

--	process_parameter_list_as (l_as: PARAMETER_LIST_AS) is
--			-- Process `l_as'.
--		do
--			safe_process (l_as.lparan_symbol (match_list))
--			-- process parameters with new visitor
--			process_parameter_list (l_as.parameters)
--			safe_process (l_as.rparan_symbol (match_list))
--		end

--feature {NONE} -- Implementation

--	process_parameter_list (l_as: EIFFEL_LIST [AST_EIFFEL]) is
--			-- Process parameter eiffel list like `process_eiffel_list'
--			-- but create for each new parameter a new visitor
--		local
--			i, l_count: INTEGER
--		do
--			if l_as.count > 0 then
--				from
--					l_as.start
--					i := 1
--					if l_as.separator_list /= Void then
--						l_count := l_as.separator_list.count
--					end
--				until
--					l_as.after
--				loop
--					-- process each internal parameter in a new visitor.
--					safe_process (l_as.item)
--					if i <= l_count then
--						safe_process (l_as.separator_list_i_th (i, match_list))
--						i := i + 1
--					end
--					l_as.forth
--				end
--			end
--		end

feature {NONE} -- Implementation

	last_class_name: STRING
			-- Last resolved class name

	last_class_c: CLASS_C
			-- Last resolved class c

	base_class: CLASS_C
			-- Starting point for type analysis

;note
	copyright:	"Copyright (c) 1984-2010, Chair of Software Engineering"
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
			ETH Zurich
			Chair of Software Engineering
			Website http://se.inf.ethz.ch/
		]"

end -- class SCOOP_TYPE_VISITOR
