note
	description: "[
					Roundtrip visitor to simply iterate an AST tree, prints basic types, 
					defines the printing context.
					Usage: 
						There are some things that you always have to check:
							1.	Bottom-up: When redefining process nodes features or making updates on it
								be sure that the feature might operate on other process node features which
								might be redefined in one of the ancestor visitor classes:
								- New inserted / updated process node feature calls another process 
								feature which is redefined in an ancestor other then AST_ROUNDTRIP_ITERATOR 
								which could lead to side effects.
								- New inserted / updated process node feature covers processing of all 	subnodes.
							2.	Top-down: When redefining process nodes features or making updates be sure 
								that all descendant visitors behave still correctly:
								- Descendant visitors might use new or updated process node feature.
								- New inserted or updated process feature node is redefined in a 
								descendant visitor and therefore not visible in its content.
							3.	Take care of the non-terminals (see also `SCOOP_CLIENT_CONTEXT_AST_PRINTER').
				]"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date$"
	revision: "$Revision$"

class
	SCOOP_CONTEXT_AST_PRINTER

inherit
	AST_ROUNDTRIP_ITERATOR
		redefine
			process_infix_prefix_as,
			process_keyword_as,
			process_symbol_as,
			process_bool_as,
			process_char_as,
			process_typed_char_as,
			process_result_as,
			process_retry_as,
			process_unique_as,
			process_deferred_as,
			process_void_as,
			process_string_as,
			process_verbatim_string_as,
			process_current_as,
			process_integer_as,
			process_real_as,
			process_id_as,
			process_break_as,
			process_symbol_stub_as,
			reset,
			process_none_id_as
		end

	SCOOP_BASIC_TYPE

	SCOOP_WORKBENCH

	SCOOP_SYSTEM_CONSTANTS

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Basic SCOOP changes

	process_infix_prefix_as (l_as: INFIX_PREFIX_AS) is
			-- Process `l_as', the infix prefix node.
		local
			l_feature_name_visitor: SCOOP_FEATURE_NAME_VISITOR
		do
			l_feature_name_visitor := scoop_visitor_factory.new_feature_name_visitor
			last_index := l_as.first_token (match_list).index - 1

			-- process INFIX_PREFIX_AS node
			if l_as.frozen_keyword /= void and then l_as.frozen_keyword.index > 0 then
				safe_process (l_as.frozen_keyword)
			else
				process_leading_leaves (l_as.infix_prefix_keyword.index)
			end
			l_feature_name_visitor.process_infix_prefix (l_as)
			context.add_string (" " + l_feature_name_visitor.feature_name)
			last_index := l_as.alias_name.index
		end

feature -- Roundtrip: printing

	process_break_as (l_as: BREAK_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_keyword_as (l_as: KEYWORD_AS) is
			-- Process `l_as', print it to context.
		do
			if l_as.is_separate_keyword then
				-- skip
				Precursor (l_as)
			else
				Precursor (l_as)
				put_string (l_as)
			end
		end

	process_symbol_as (l_as: SYMBOL_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_symbol_stub_as (l_as: SYMBOL_STUB_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_bool_as (l_as: BOOL_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_char_as (l_as: CHAR_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_typed_char_as (l_as: TYPED_CHAR_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_result_as (l_as: RESULT_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_retry_as (l_as: RETRY_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_unique_as (l_as: UNIQUE_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_deferred_as (l_as: DEFERRED_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_void_as (l_as: VOID_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_string_as (l_as: STRING_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_verbatim_string_as (l_as: VERBATIM_STRING_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_current_as (l_as: CURRENT_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_integer_as (l_as: INTEGER_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			context.add_string (l_as.number_text (match_list))
		end

	process_real_as (l_as: REAL_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			context.add_string (l_as.number_text (match_list))
		end

	process_id_as (l_as: ID_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			put_string (l_as)
		end

	process_none_id_as (l_as: NONE_ID_AS) is
			-- Process `l_as', print it to context.
		do
			Precursor (l_as)
			context.add_string ("NONE")
		end

feature -- Context setting and getting

	reset is
			-- Reset visitor for a next visit.
		do
			Precursor
			context.clear
		end

	reset_context is
			-- Reset only context.
		do
			context.clear
		end

	set_context (a_ctxt: ROUNDTRIP_CONTEXT) is
			-- Set `context' with `a_ctxt'.
		require
			a_ctxt_not_void: a_ctxt /= Void
		do
			context := a_ctxt
		ensure
			context_set: context = a_ctxt
		end

	get_context: STRING is
			-- Get `context'.
		do
			Result := context.string_representation
		end

feature{NONE} -- Context handling

	context: ROUNDTRIP_CONTEXT
			-- Context used to store generated code.

	put_string (l_as: LEAF_AS) is
			-- Print text contained in `l_as' into `context'.
		require
			l_as_in_list: l_as.index >= start_index and then l_as.index <= end_index
		do
			context.add_string (l_as.text (match_list))
		end

	print_leading_separators(i: INTEGER)
			-- Print leading separator from `match_list' infront and with position `i'.
		do
			if match_list.i_th (i).is_separator then
				print_leading_separators(i-1)
				match_list.i_th (i).process (current)
			end


		end

	compute_inlining(i: INTEGER):STRING
			-- Prints leading separator from `match_list' infront and with position `i'.
		local
			str: STRING
			j: INTEGER
		do
			create result.make_empty
			if match_list.i_th (i).is_separator then
				if attached {BREAK_AS} match_list.i_th (i) as text then
					str := text.literal_text (match_list)
					from
						j := str.count
					until
						j <= 0
					loop
						if not str.item (j).is_equal ('%N') then
							result.append_character (str.item (j))
							j := j-1
						else
							j := 0
						end
					end
				end
				result.append (compute_inlining(i-1))
			end
		end

--	last_new_line(str: STRING): INTEGER is
--			-- returns the postion of the last `%N' in `str'
--			local
--				i,j : INTEGER
--			do
--				if str.has_substring ("%N") then
--					i := str.substring_index ("%N", 1)
--					j := last_new_line(str.substring (i+2, str.count))
--					if j = 0 then
--						-- no further `%N'
--						result := i
--					else
--						-- further `%N'
--						result := j
--					end
--				else
--					result := 0
--				end
--			end

feature -- Debug

	safe_process_debug (l_as: AST_EIFFEL): ROUNDTRIP_CONTEXT is
			-- Process the ast in a testing context.
		local
			original_context: ROUNDTRIP_CONTEXT
			l_last_index: INTEGER
		do
				-- create testing context
			original_context := context
			l_last_index := last_index
			context := create {ROUNDTRIP_STRING_LIST_CONTEXT}.make

				-- process the node
			last_index := l_as.first_token (match_list).index - 1
			safe_process (l_as)

				-- set original context
			Result := context
			last_index := l_last_index
			context := original_context
		end

invariant
	context_not_void: context /= Void

note
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

end -- SCOOP_CONTEXT_AST_PRINTER
