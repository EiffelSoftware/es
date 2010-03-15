note
	description: "[
					Roundtrip visitor to process generics.
					Usage: 
					One can call the visitor by passing it a context and process the generics on the created visitor
					After creating the visitor before calling it one can set `set_generics_to_substitute' with a list of generic parameters to replace.
					The list contains the indexes of the parameter one wants to substitute.
					`set_prefix' can be set to print generic parameter as well as the 'SCOOP_SEPARATE__' prefix in front of it. (only used in process_id_as probably obsolete)
					`without_constraints' can be set to ignore generic constraints. (i.e D[X -> INTEGER])
					The `generic_index' in this visitor defines the index of the current generic parameter beeing processed and is used to match the items in the `generics_to_substitute' list.
					Generic indexes contain a stage which defines the depth of the parameter and a position which defines the position of the current stage.(i.e TUPLE[INTEGER, D[X]] -> index(X) = [2,2])
					Also see note in `SCOOP_CONTEXT_AST_PRINTER'.
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_GENERICS_VISITOR

inherit
	SCOOP_CONTEXT_AST_PRINTER
		redefine
			process_class_type_as,
			process_generic_class_type_as,
			process_named_tuple_type_as,
			process_formal_dec_as,
			process_id_as,
			process_like_cur_as,
			process_like_id_as,
			process_eiffel_list
		end

	SCOOP_WORKBENCH

	SCOOP_CLASS_NAME

create
	make_with_context

feature -- Initialisation

	make_with_context(a_context: ROUNDTRIP_CONTEXT)
			-- Initialise and reset flags
		require
			a_context_not_void: a_context /= Void
		do
			context := a_context

			--Initialise index of the current generic parameter
			create generic_index.default_create
			generic_index.stage := 1
			generic_index.pos := 1
		end

feature -- Access

	process_internal_generics (l_as: TYPE_LIST_AS; set_prefix, without_constraints: BOOLEAN) is
			-- Process `l_as'.
		do
			is_set_prefix := set_prefix
			is_print_without_constraints := without_constraints
			if l_as /= Void then
				last_index := l_as.first_token (match_list).index - 1
				safe_process (l_as)
			end
		end

	process_class_internal_generics(l_as: EIFFEL_LIST [FORMAL_DEC_AS]; set_prefix, without_constraints: BOOLEAN) is
			-- Process `l_as'.
		do
			is_set_prefix := set_prefix
			is_print_without_constraints := without_constraints
			if l_as /= Void then
				last_index := l_as.first_token (match_list).index - 1
				safe_process (l_as)
			end
		end

	process_type_internal_generics(l_as: TYPE_LIST_AS; set_prefix, without_constraints: BOOLEAN) is
			-- Process `l_as'.
		do
			is_set_prefix := set_prefix
			is_print_without_constraints := without_constraints
			if l_as /= Void then
				last_index := l_as.first_token (match_list).index - 1
				safe_process (l_as)
			end
		end

	process_type_locals(l_as: TYPE_LIST_AS; set_prefix, without_constraints: BOOLEAN) is
			-- Process `l_as' for proxy type visitor.
			-- replace like_id_as with 'implementation_'.
		do
			is_set_prefix := set_prefix
			is_print_without_constraints := without_constraints
			is_print_proxy_locals := True
			if l_as /= Void then
				last_index := l_as.first_token (match_list).index - 1
				safe_process (l_as)
			end
			is_print_proxy_locals := False
		end

	get_last_index: INTEGER is
			-- Returns the last processed index
		do
			Result := last_index
		ensure
			valid_index: last_index > 0
		end

	set_generic_index(l_stage,l_pos:INTEGER) is
			-- Set the generic index (for nested generic parameters)
		do
			if generic_index = void then
				create generic_index.default_create
			end
			generic_index.stage := l_stage
			generic_index.pos := l_pos
		end

	set_generics_to_substitute(gen: LINKED_LIST[TUPLE[INTEGER,INTEGER]]) is
			-- Set the generic's which need to be substituted
		do
			generics_to_substitute := gen
		ensure
			is_set: generics_to_substitute = gen
		end


feature {NONE} -- Visitor implementation

	process_id_as (l_as: ID_AS) is
		do

			process_leading_leaves (l_as.index)
			process_class_name (l_as, is_set_prefix, context, match_list)
	--		process_class_name (l_as, False, context, match_list)
			if l_as /= Void then
				last_index := l_as.index
			end
		end

	l_process_id_as (l_as: ID_AS; is_separate: BOOLEAN) is
		local
			l_is_separate: BOOLEAN
		do
			l_is_separate := is_separate
			process_leading_leaves (l_as.index)

			if generics_to_substitute /= void and then not generics_to_substitute.is_empty then
				from
					generics_to_substitute.start
				until
					generics_to_substitute.after
				loop
					if generics_to_substitute.item.is_equal (generic_index) then
						l_is_separate := not is_separate
					end
					generics_to_substitute.forth
				end
			end
			process_class_name (l_as, l_is_separate, context, match_list)
	--		process_class_name (l_as, is_set_prefix, context, match_list)
	--		process_class_name (l_as, False, context, match_list)
			if l_as /= Void then
				last_index := l_as.index
			end
		end

	process_class_type_as (l_as: CLASS_TYPE_AS) is
		do
			generic_index.stage  := generic_index.stage+1
			safe_process (l_as.lcurly_symbol (match_list))

				-- generic separate type should be attached.
			if not l_as.is_separate then
				safe_process (l_as.attachment_mark (match_list))
			end

			safe_process (l_as.expanded_keyword (match_list))

			if l_as.is_separate then
				l_process_id_as (l_as.class_name, True)
			else
				l_process_id_as (l_as.class_name, False)
			end

			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_generic_class_type_as (l_as: GENERIC_CLASS_TYPE_AS) is
		local
			l_generics_visitor: SCOOP_GENERICS_VISITOR
		do
			-- Update index
			generic_index.stage  := generic_index.stage+1

			safe_process (l_as.lcurly_symbol (match_list))

				-- generic separate type should be attached.
			if not l_as.is_separate then
				safe_process (l_as.attachment_mark (match_list))
			end

			safe_process (l_as.expanded_keyword (match_list))

			if l_as.is_separate then
				l_process_id_as (l_as.class_name, True)
			else
				l_process_id_as (l_as.class_name, False)
			end

			if l_as.internal_generics /= Void then
				context.add_string (" ")
				l_generics_visitor := scoop_visitor_factory.new_generics_visitor (context)
				l_generics_visitor.set_generic_index(generic_index.stage, generic_index.pos)
				l_generics_visitor.set_generics_to_substitute(generics_to_substitute)
				l_generics_visitor.process_internal_generics (l_as.internal_generics, is_set_prefix, is_print_without_constraints)
				last_index := l_generics_visitor.get_last_index
			end

			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_named_tuple_type_as (l_as: NAMED_TUPLE_TYPE_AS) is
		do
			safe_process (l_as.lcurly_symbol (match_list))

				-- generic separate type should be attached.
			if not l_as.is_separate then
				safe_process (l_as.attachment_mark (match_list))
			end

			if l_as.is_separate then
				l_process_id_as (l_as.class_name, True)
			else
				l_process_id_as (l_as.class_name, False)
			end

			safe_process (l_as.parameters)
			safe_process (l_as.rcurly_symbol (match_list))
		end

	process_formal_dec_as (l_as: FORMAL_DEC_AS) is
		do
			safe_process (l_as.formal)
			if not is_print_without_constraints then
				safe_process (l_as.constrain_symbol (match_list))
				safe_process (l_as.constraints)
				safe_process (l_as.create_keyword (match_list))
				safe_process (l_as.creation_feature_list)
				safe_process (l_as.end_keyword (match_list))
			else
				-- skip the constraints and creation part
				if l_as.has_constraint then
					last_index := l_as.last_token (match_list).index
				end
			end
		end

	process_like_cur_as (l_as: LIKE_CUR_AS) is
		do
			if is_print_proxy_locals then
				safe_process (l_as.lcurly_symbol (match_list))
				safe_process (l_as.attachment_mark (match_list))
				safe_process (l_as.like_keyword (match_list))

				-- replace current with implementation
				context.add_string (" implementation_")
				last_index := l_as.current_keyword.index

				safe_process (l_as.rcurly_symbol (match_list))
			else
				Precursor (l_as)
			end
		end

	process_like_id_as (l_as: LIKE_ID_AS) is
		local
			l_proxy_type_locals_visitor: SCOOP_PROXY_TYPE_LOCALS_PRINTER
		do
			if is_print_proxy_locals then
				if l_as.lcurly_symbol_index > 0 then
					process_leading_leaves (l_as.lcurly_symbol_index)
				else
					process_leading_leaves (l_as.like_keyword_index)
				end
				l_proxy_type_locals_visitor := scoop_visitor_factory.new_proxy_type_local_printer (context)
				l_proxy_type_locals_visitor.process_type (l_as)
				if l_as.rcurly_symbol_index > 0 then
					last_index := l_as.rcurly_symbol_index
				else
					last_index := l_as.anchor.index
				end
			else
				Precursor (l_as)
			end
		end

	process_eiffel_list (l_as: EIFFEL_LIST [AST_EIFFEL])
			local
				x,i, l_count: INTEGER
			do
				if l_as.count > 0 then
					from
						l_as.start
						i := 1
						x := 1
						if l_as.separator_list /= Void then
							l_count := l_as.separator_list.count
						end
					until
						l_as.after
					loop

						-- Update Index
						generic_index.pos := i
						safe_process (l_as.item)
						generic_index.stage := generic_index.stage-1
						if i <= l_count then
							safe_process (l_as.separator_list_i_th (i, match_list))
							i := i + 1
						end
						x := x +1
						l_as.forth
					end
				end
			end

feature {NONE} -- Implementation

	is_set_prefix: BOOLEAN
			-- indicates if prefix should be printed or not.

	is_print_without_constraints: BOOLEAN
			-- Prints a 'FORMAL_DEC_AS' without constraints
			-- necessary to create an attribute of a generic class type.

	is_print_proxy_locals: BOOLEAN
			-- Print generics as locals of proxy printer.

	generic_index: TUPLE[stage: INTEGER; pos: INTEGER]
			-- Index of current generic parameter
			-- Stage: Level of nesting
			-- Pos: # of generic parameter in the current lvl
			-- i.e CLASS[CLASS[A,B]] -> B has index 2,2
	generics_to_substitute: LINKED_LIST[TUPLE[INTEGER,INTEGER]]
			-- List of generics which need to be changed.

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

end -- class SCOOP_GENERICS_VISITOR
