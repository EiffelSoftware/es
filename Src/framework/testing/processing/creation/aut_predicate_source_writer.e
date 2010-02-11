note
	description: "Summary description for {AUT_PREDICATE_SOURCE_WRITER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AUT_PREDICATE_SOURCE_WRITER

inherit
	AUT_SHARED_PREDICATE_CONTEXT

	AUT_SHARED_TYPE_FORMATTER

create
	make

feature{NONE} -- Initialization

	make (a_config: like configuration; a_stream: like stream) is
			-- Initialize `stream' with `a_stream'.
		require
			a_config_attached: a_config /= Void
			a_stream_attached: a_stream /= Void
		do
			configuration := a_config
			stream := a_stream
		ensure
			configuration_set: configuration = a_config
			stream_set: stream = a_stream
		end

feature -- Access

	stream: TEST_INDENTING_SOURCE_WRITER
			-- Stream used to store generated source code

	configuration: TEST_GENERATOR_CONF_I
			-- Configuration of current AutoTest session

feature -- Basic operations

	generate_predicates is
			-- Generate predicate related features.
		do
			generate_initialize_predicates
			generate_predicate_evaluators
		end

	generate_predicate_evaluators is
			-- Generate features to evaluate `predicates'.
		do
			if configuration.is_precondition_checking_enabled then
				predicates.do_all (agent generate_predicate_evaluator)
			end
		end

	generate_predicate_evaluator (a_predicate: AUT_PREDICATE) is
			-- Generate evaluator reoutine for `a_predicate'.
		require
			a_predicate_attached: a_predicate /= Void
		local
			l_arg_cursor: DS_LINKED_LIST_CURSOR [TYPE_A]
		do
			stream.indent

				-- Generate feature signature.
			stream.put_string ("predicate_" + a_predicate.id.out + " (")
			from
				l_arg_cursor := a_predicate.argument_types.new_cursor
				l_arg_cursor.start
			until
				l_arg_cursor.after
			loop
				if not l_arg_cursor.is_first then
					stream.put_string ("; ")
				end
				append_type_dec (l_arg_cursor.index, l_arg_cursor.item)
				l_arg_cursor.forth
			end
			stream.put_line ("): BOOLEAN is")
			stream.indent
			stream.indent
			stream.put_line ("-- Predicate evaluator for %"" + a_predicate.text + "%".")
			stream.dedent
			stream.dedent

				-- Generate feature body.
			stream.indent
			stream.put_line ("do")
			stream.indent

			if not a_predicate.targets.is_empty then

				stream.put_string ("if ")
				from
					a_predicate.targets.start
				until
					a_predicate.targets.after
				loop
					stream.put_string (argument_name (a_predicate.targets.item_for_iteration))
					stream.put_string (" /= Void ")
					if not a_predicate.targets.is_last then
						stream.put_string ("and ")
					end
					a_predicate.targets.forth
				end
				stream.put_line ("then")
				stream.indent
				stream.put_line ("Result := " + predicate_text (a_predicate))
				stream.dedent
				stream.put_line ("end")
			else
				stream.put_line ("Result := " + predicate_text (a_predicate))
			end
			stream.dedent
			stream.put_line ("end")
			stream.dedent
			stream.put_line ("")
			stream.dedent
		end

	generate_initialize_predicates is
			-- Generate source code for `initialize_predicates' feature.
		local
			l_predicates: like predicates
			l_cursor: DS_HASH_SET_CURSOR [AUT_PREDICATE]
			i: INTEGER
			l_feat_cursor: DS_HASH_TABLE_CURSOR [ARRAY [TUPLE [predicate_id: INTEGER_32; operand_indexes: SPECIAL [INTEGER_32]]], INTEGER_32]
			j, k, l_count: INTEGER
			l_pred_array: ARRAY [TUPLE [predicate_id: INTEGER_32; operand_indexes: SPECIAL [INTEGER_32]]]
			l_operands: SPECIAL [INTEGER_32]
		do
			stream.indent
			stream.put_line ("initialize_predicates is")
			stream.indent
			if configuration.is_precondition_checking_enabled then
				stream.put_line ("local")
				stream.indent
				stream.put_line ("l_array: ARRAY [TUPLE [predicate_id: INTEGER; operand_indexes: SPECIAL [INTEGER]]]")
				stream.put_line ("l_ops: SPECIAL [INTEGER]")
				stream.dedent
			end
			stream.put_line ("do")
			if configuration.is_precondition_checking_enabled then
				stream.indent
				l_predicates := predicates
				stream.put_line ("is_predicate_evaluation_enabled := True")
				stream.put_line ("create predicate_table.make (" + l_predicates.count.out + ")")
				stream.put_line ("create predicate_arity.make (" + l_predicates.count.out + ")")
				from
					l_cursor := l_predicates.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					stream.put_line ("predicate_table.put (agent predicate_" + l_cursor.item.id.out + ", " + l_cursor.item.id.out + ")")
					stream.put_line ("predicate_arity.put (" + l_cursor.item.arity.out + ", " + l_cursor.item.id.out + ")")
					l_cursor.forth
				end
				stream.put_line ("create argument_arrays.make (0, 9)")
				from
					i := 0
				until
					i > 9
				loop
					stream.put_line ("argument_arrays.put (create {ARRAY [INTEGER]}.make (1, " + i.out + "), " + i.out + ")")
					i := i + 1
				end

				stream.put_line ("create argument_tuple_cache.make (20)")
				stream.put_line ("create argument_cache.make (1, 20)")
				stream.put_line ("create relevant_predicate_table.make (200)")
				from
					l_feat_cursor := relevant_predicate_with_operand_table.new_cursor
					l_feat_cursor.start
				until
					l_feat_cursor.after
				loop
					l_pred_array := l_feat_cursor.item
					if not l_pred_array.is_empty then
						stream.put_line ("%T-- For feature with ID: " + l_feat_cursor.key.out)
						stream.put_line ("create l_array.make (1, " + l_pred_array.count.out + ")")
						stream.put_line ("relevant_predicate_table.force (l_array, " + l_feat_cursor.key.out + ")")
						from
							j := 1
							l_count := l_pred_array.count
						until
							j > l_count
						loop
							l_operands := l_pred_array.item (j).operand_indexes
							stream.put_line ("create l_ops.make (" + l_operands.count.out  + ")")
							stream.put_line ("l_array.put ([" + l_pred_array.item (j).predicate_id.out + ", l_ops], " + j.out + ")")
							from
								k := 0
							until
								k = l_operands.count
							loop
								stream.put_line ("l_ops.put (" + l_operands.item (k).out + ", " +  k.out + ")")
								k := k + 1
							end
							j := j + 1
							stream.put_line ("")
						end
						stream.put_line ("")
					end
					l_feat_cursor.forth
				end
				stream.dedent
			end

			stream.put_line ("end")
			stream.put_line ("")
			stream.dedent
			stream.dedent
		end

feature{NONE} -- Implementation

	argument_name (a_index: INTEGER): STRING is
			-- Name of the argument at position `a_index'
		do
			Result := "l_arg" + a_index.out
		end

	append_type_dec (a_argument_index: INTEGER; a_type: TYPE_A) is
			-- Append a type declaration in `stream'.
		do
			stream.put_string (argument_name (a_argument_index))
			stream.put_string (": ")
			stream.put_string (type_name (a_type, Void))
		end

	predicate_text (a_predicate: AUT_PREDICATE): STRING is
			-- Text of `a_predicate'
		local
			l_arg_count: INTEGER
			i: INTEGER
			j: INTEGER
			l_text: STRING
		do
			l_arg_count := a_predicate.arity
			l_text := a_predicate.text.twin
			from
				i := 0
			until
				i > l_arg_count
			loop
				l_text.replace_substring_all ("{" + i.out + "}", argument_name (i))
				i := i + 1
			end
			Result := l_text
		end

invariant
	stream_attached: stream /= Void

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
