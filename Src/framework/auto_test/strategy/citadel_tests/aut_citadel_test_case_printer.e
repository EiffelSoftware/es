note
	description: "Summary description for {AUT_CITADEL_TEST_CASE_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class AUT_CITADEL_TEST_CASE_PRINTER

inherit
	AUT_TEST_CASE_PRINTER
		redefine
			make_null,
			print_test_case,
			print_routine_header,
			process_create_object_request,
			process_invoke_feature_request,
			print_argument_list
		end

create
	make_null

feature {NONE} -- Initialization

	make_null (a_system: like system)
		do
			Precursor (a_system)
			create name_generator.make_with_string_stream ("test_case_")
			create {ARRAYED_LIST [STRING]} test_features.make (0)
		end

feature -- Printing

	print_class_header
			-- Print the header for the class containing the test cases.
		do
			output_stream.put_line ("class CITADEL_TEST_CASE")
			output_stream.put_new_line
			output_stream.put_line ("inherit")
			output_stream.put_new_line
			indent
			print_indentation
			output_stream.put_line ("CITADEL_GLOBAL")
			dedent
			output_stream.put_new_line
			output_stream.put_line ("create")
			indent
			print_indentation
			output_stream.put_line ("make")
			dedent
			output_stream.put_new_line
			output_stream.put_line ("feature")
			output_stream.put_new_line
		end

	print_class_footer
			-- Print the footer for the class containing the test cases.
		do
			output_stream.put_string (code_added)
			output_stream.put_new_line
			print_footer
		end

	print_routine_header
			-- Print the header of the routine containing the test case.
		local
			routine_name: STRING_8
		do
			indent
			print_indentation
			name_generator.output_string.wipe_out
			name_generator.generate_new_name
			routine_name := name_generator.output_string
			output_stream.put_line (routine_name)
			test_features.force (routine_name.twin)
		end

	print_test_case  (a_request_list: DS_BILINEAR [AUT_REQUEST]; a_var_list: like used_vars)
			-- Print the request list `a_list' as an Eiffel test case.
		local
			cs: DS_BILINEAR_CURSOR [AUT_REQUEST]
			l_cursor: DS_HASH_TABLE_CURSOR [TUPLE [type: detachable TYPE_A; name: detachable STRING; check_dyn_type: BOOLEAN], ITP_VARIABLE]
			l_type: TYPE_A
		do
			used_vars := a_var_list
			ot_counter := 1
			print_routine_header
			indent
			print_indentation
			output_stream.put_line ("local")
			indent
			if used_vars /= Void then
				l_cursor := used_vars.new_cursor
				from
					l_cursor.start
				until
					l_cursor.after
				loop
					l_type := variable_type (l_cursor.key)
					print_indentation
					output_stream.put_string (variable_name (l_cursor.key))
					output_stream.put_string (": ")
					output_stream.put_string (variable_type_name (l_cursor.key))
					if l_type = none_type then
						output_stream.put_string (" -- Placeholder for queries returning Void")
					end
					output_stream.put_new_line
					l_cursor.forth
				end
			else
				print_indentation
				output_stream.put_line ("-- TODO: add variable declarations for not failing and not minimized TCs.")
			end
			dedent
			print_indentation
			output_stream.put_line ("do")
			indent
			print_indentation
			output_stream.put_line (citadel_enable_monitoring)
			print_indentation
			output_stream.put_line ("set_is_recovery_enabled (True)")
			from
				cs := a_request_list.new_cursor
				cs.start
			until
				cs.off
			loop
				if cs.is_last then
					output_stream.put_new_line
					indent
					print_indentation
					output_stream.put_line ("-- Final routine call")
					dedent
					print_indentation
					output_stream.put_line ("set_is_recovery_enabled (False)")
				end
				cs.item.process (Current)
				cs.forth
			end
			dedent
			print_indentation
			output_stream.put_line ("end")
			dedent
			dedent
			output_stream.put_new_line
			used_vars := Void
		end

	print_root_creation_procedure
			-- Print the root creation procedure of the test class, which calls the routines containing the test cases.
		do
			indent
			print_indentation
			output_stream.put_line ("make")
			indent
			print_indentation
			output_stream.put_line ("do")
			indent
			from
				test_features.start
			until
				test_features.after
			loop
				print_indentation
				output_stream.put_line (test_features.item)
				test_features.forth
			end
			dedent
			print_indentation
			output_stream.put_line ("end")
			dedent
			dedent
		end

feature {NONE} -- Name generation

	name_generator: AUT_UNIQUE_NAME_GENERATOR
			-- Generator of names for the test routines

	test_features: LIST [STRING]
			-- List containing the names of the features containing the test cases

feature {AUT_REQUEST} -- Request processing

	process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
		do
			if a_request.has_response and then a_request.response.is_normal then
				internal_process_create_object_request (a_request)
			else
				print_indentation
				output_stream.put_line (citadel_disable_monitoring)
				internal_process_create_object_request (a_request)
				print_indentation
				output_stream.put_line (citadel_enable_monitoring)
			end
		end

	process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
		do
			if a_request.has_response and then (a_request.response.is_normal and not a_request.response.is_exception) then
				internal_process_invoke_feature_request (a_request)
			else
				print_indentation
				output_stream.put_line (citadel_disable_monitoring)
				internal_process_invoke_feature_request (a_request)
				print_indentation
				output_stream.put_line (citadel_enable_monitoring)
			end
		end

feature {NONE} -- Implementation

	internal_process_create_object_request (a_request: AUT_CREATE_OBJECT_REQUEST)
		local
			l_args: detachable DS_LINEAR [ITP_EXPRESSION]
			l_type: STRING
			i: INTEGER
		do
			l_args := a_request.argument_list
			l_type := type_name (a_request.target_type, a_request.creation_procedure)
			print_indentation
			output_stream.put_string ("execute_safe (agent")
			if l_args /= Void then
				print_argument_list (l_args, True)
			end
			output_stream.put_string (": ")
			output_stream.put_line (l_type)
			indent
			print_indentation
			output_stream.put_line ("do")
			indent
			print_indentation
			output_stream.put_string ("create {")
			output_stream.put_string (l_type)
			output_stream.put_string ("} Result")
			if not a_request.is_default_create_used then
				output_stream.put_string (".")
				output_stream.put_string (a_request.creation_procedure.feature_name)
				if l_args /= Void and then not l_args.is_empty then
					output_stream.put_string (" (")
					from
						l_args.start
						i := 1
					until
						l_args.after
					loop
						output_stream.put_string ("a_arg")
						output_stream.put_integer (i)
						l_args.forth
						if not l_args.after then
							output_stream.put_string (", ")
						end
						i := i + 1
					end
					output_stream.put_string (")")
				end
			end
			output_stream.put_new_line
			dedent
			print_indentation
			output_stream.put_string ("end")
			if l_args /= Void then
				print_argument_list (l_args, False)
			end
			output_stream.put_line (")")
			dedent
			print_indentation

--			output_stream.put_string ("if {l_ot")
--			output_stream.put_integer (ot_counter.to_integer_32)
--			output_stream.put_string (": ")
--			output_stream.put_string (l_type)
--			output_stream.put_line ("} last_object then")
--			indent
--			print_indentation
--			output_stream.put_string (variable_name (a_request.target))
--			output_stream.put_string (" := l_ot")
--			output_stream.put_integer (ot_counter.to_integer_32)

			output_stream.put_string (variable_name (a_request.target))
			output_stream.put_string (" ?= last_object")

			output_stream.put_new_line
--			dedent
--			print_indentation
--			output_stream.put_line ("end")
			ot_counter := ot_counter + 1
		end

	internal_process_invoke_feature_request (a_request: AUT_INVOKE_FEATURE_REQUEST)
		local
			l_rec_type: TYPE_A
			l_use_ot: BOOLEAN
			a: EQA_SYNTHESIZED_TEST_SET
		do
			print_indentation
			output_stream.put_string ("execute_safe (agent ")
			output_stream.put_string (variable_name (a_request.target))
			output_stream.put_character ('.')
			output_stream.put_string (a_request.feature_name)
			print_argument_list (a_request.argument_list, False)
			output_stream.put_line (")")

			if a_request.is_feature_query then
				print_indentation
				l_rec_type := variable_type (a_request.receiver)
				output_stream.put_string (variable_name (a_request.receiver))
				if l_rec_type.is_basic then
					output_stream.put_string (" := ")
					if l_rec_type.is_boolean then
						output_stream.put_string ("last_boolean")
					elseif l_rec_type.is_character then
						output_stream.put_string ("last_character_8")
					elseif l_rec_type.is_character_32 then
						output_stream.put_string ("last_character_32")
					elseif l_rec_type.is_pointer then
						output_stream.put_string ("last_pointer")
					elseif l_rec_type.is_real_32 then
						output_stream.put_string ("last_real_32")
					elseif l_rec_type.is_real_64 then
						output_stream.put_string ("last_real_64")
					elseif attached {INTEGER_A} l_rec_type as l_int_type then
						output_stream.put_string ("last_integer_")
						output_stream.put_integer (l_int_type.size)
					elseif attached {NATURAL_A} l_rec_type as l_nat_type then
						output_stream.put_string ("last_natural_")
						output_stream.put_integer (l_nat_type.size)
					else
						output_stream.put_string ("Void")
					end
				else
					output_stream.put_string (" ?= ")
					output_stream.put_string ("last_object")
				end
				output_stream.put_new_line
			end
		end

	print_argument_list (an_argument_list: DS_LINEAR [ITP_EXPRESSION]; a_print_types: BOOLEAN)
		local
			cs: DS_LINEAR_CURSOR [ITP_EXPRESSION]
			l_var: ITP_VARIABLE
			i: INTEGER_32
			l_type: TYPE_A
		do
			if an_argument_list.count > 0 then
				output_stream.put_character (' ')
				output_stream.put_character ('(')
				from
					cs := an_argument_list.new_cursor
					cs.start
					i := 1
				until
					cs.off
				loop
					l_var ?= cs.item
					l_type := variable_type (l_var)
					if a_print_types then
						output_stream.put_string ("a_arg")
						output_stream.put_integer (i)
						output_stream.put_string (": ")
						if l_type = none_type then
--							output_stream.put_string ("ANY")
							output_stream.put_string ("NONE")
						else
--							if not l_type.is_basic then
--								output_stream.put_string ("?")
--							end
							output_stream.put_string (l_type.name)
						end
					else
						if l_type = none_type or else (l_var /= Void and then should_use_void (l_var)) then
							output_stream.put_string ("Void")
						else
							cs.item.process (expression_printer)
						end
					end
					cs.forth
					i := i + 1
					if not cs.after then
						if a_print_types then
							output_stream.put_character (';')
						else
							output_stream.put_character (',')
						end
						output_stream.put_character (' ')
					end
				end
				output_stream.put_character (')')
			end
		end

feature {NONE} -- String constants

	citadel_enable_monitoring: STRING is "enable_monitoring"
	citadel_disable_monitoring: STRING is "disable_monitoring"

	code_added: STRING is
"feature {NONE} -- Implementation%N%
%%N%
%	last_object: ANY%N%
%	last_boolean: BOOLEAN%N%
%	last_character_8: CHARACTER_8%N%
%	last_character_32: CHARACTER_32%N%
%	last_integer_8: INTEGER_8%N%
%	last_integer_16: INTEGER_16%N%
%	last_integer_32: INTEGER_32%N%
%	last_integer_64: INTEGER_64%N%
%	last_natural_8: NATURAL_8%N%
%	last_natural_16: NATURAL_16%N%
%	last_natural_32: NATURAL_32%N%
%	last_natural_64: NATURAL_64%N%
%	last_real_32: REAL_32%N%
%	last_real_64: REAL_64%N%
%	last_pointer: POINTER%N%
%			-- Values returned from last routine call in `execute_safe'%N%
%%N%
%	is_recovery_enabled: BOOLEAN%N%
%			-- Should `execute_safe' try to recover from an exceptional routine call?%N%
%%N%
%	set_is_recovery_enabled (a_is_recovery_enabled: like is_recovery_enabled)%N%
%			-- Set `is_recovering_enabled' to True.%N%
%		do%N%
%			is_recovery_enabled := a_is_recovery_enabled%N%
%		ensure%N%
%			is_recovery_enabled_set: is_recovery_enabled = a_is_recovery_enabled%N%
%		end%N%
%%N%
%	execute_safe (a_routine: ROUTINE [ANY, TUPLE])%N%
%			-- Call `a_agent'%N%
%		require%N%
%			a_routine_attached: a_routine /= Void%N%
%			no_open_args: a_routine.empty_operands /= Void and then a_routine.empty_operands.count = 0%N%
%		local%N%
%			l_rescued: BOOLEAN%N%
%			l_empty: TUPLE%N%
%			l_func: FUNCTION [ANY, TUPLE, ANY]%N%
%			l_bool_func: FUNCTION [ANY, TUPLE, BOOLEAN]%N%
%			l_char8_func: FUNCTION [ANY, TUPLE, CHARACTER_8]%N%
%			l_char32_func: FUNCTION [ANY, TUPLE, CHARACTER_32]%N%
%			l_int8_func: FUNCTION [ANY, TUPLE, INTEGER_8]%N%
%			l_int16_func: FUNCTION [ANY, TUPLE, INTEGER_16]%N%
%			l_int32_func: FUNCTION [ANY, TUPLE, INTEGER_32]%N%
%			l_int64_func: FUNCTION [ANY, TUPLE, INTEGER_64]%N%
%			l_nat8_func: FUNCTION [ANY, TUPLE, NATURAL_8]%N%
%			l_nat16_func: FUNCTION [ANY, TUPLE, NATURAL_16]%N%
%			l_nat32_func: FUNCTION [ANY, TUPLE, NATURAL_32]%N%
%			l_nat64_func: FUNCTION [ANY, TUPLE, NATURAL_64]%N%
%			l_real32_func: FUNCTION [ANY, TUPLE, REAL_32]%N%
%			l_real64_func: FUNCTION [ANY, TUPLE, REAL_64]%N%
%			l_pointer_func: FUNCTION [ANY, TUPLE, POINTER]%N%
%		do%N%
%			if not l_rescued then%N%
%				reset_results%N%
%%N%
%				l_empty := a_routine.empty_operands%N%
%				check l_empty.count = 0 end%N%
%				a_routine.call (l_empty)%N%
%%N%
%				l_func ?= a_routine%N%
%				if l_func /= Void then%N%
%					l_bool_func ?= l_func%N%
%					if l_bool_func /= Void then%N%
%						last_boolean := l_bool_func.last_result%N%
%					else%N%
%						l_char8_func ?= l_func%N%
%						if l_char8_func /= Void then%N%
%							last_character_8 := l_char8_func.last_result%N%
%						else%N%
%							l_char32_func ?= l_func%N%
%							if l_char32_func /= Void then%N%
%								last_character_32 := l_char32_func.last_result%N%
%							else%N%
%								l_int8_func ?= l_func%N%
%								if l_int8_func /= Void then%N%
%									last_integer_8 := l_int8_func.last_result%N%
%								else%N%
%									l_int16_func ?= l_func%N%
%									if l_int16_func /= Void then%N%
%										last_integer_16 := l_int16_func.last_result%N%
%									else%N%
%										l_int32_func ?= l_func%N%
%										if l_int32_func /= Void then%N%
%											last_integer_32 := l_int32_func.last_result%N%
%										else%N%
%											l_int64_func ?= l_func%N%
%											if l_int64_func /= Void then%N%
%												last_integer_64 := l_int64_func.last_result%N%
%											else%N%
%												l_nat8_func ?= l_func%N%
%												if l_nat8_func /= Void then%N%
%													last_natural_8 := l_nat8_func.last_result%N%
%												else%N%
%													l_nat16_func ?= l_func%N%
%													if l_nat16_func /= Void then%N%
%														last_natural_16 := l_nat16_func.last_result%N%
%													else%N%
%														l_nat32_func ?= l_func%N%
%														if l_nat32_func /= Void then%N%
%															last_natural_32 := l_nat32_func.last_result%N%
%														else%N%
%															l_nat64_func ?= l_func%N%
%															if l_nat64_func /= Void then%N%
%																last_natural_64 := l_nat64_func.last_result%N%
%															else%N%
%																l_real32_func ?= l_func%N%
%																if l_real32_func /= Void then%N%
%																	last_real_32 := l_real32_func.last_result%N%
%																else%N%
%																	l_real64_func ?= l_func%N%
%																	if l_real64_func /= Void then%N%
%																		last_real_64 := l_real64_func.last_result%N%
%																	else%N%
%																		l_pointer_func ?= l_func%N%
%																		if l_pointer_func /= Void then%N%
%																			last_pointer := l_pointer_func.last_result%N%
%																		else%N%
%																			last_object := l_func.last_result%N%
%																		end%N%
%																	end%N%
%																end%N%
%															end%N%
%														end%N%
%													end%N%
%												end%N%
%											end%N%
%										end%N%
%									end%N%
%								end%N%
%							end%N%
%						end%N%
%					end	%N%
%				end%N%
%			end%N%
%		rescue%N%
%			if is_recovery_enabled then%N%
%				l_rescued := True%N%
%				retry%N%
%			end%N%
%		end%N%
%%N%
%	reset_results%N%
%			-- Set all `last_*' attributes to their default value.%N%
%		do%N%
%			last_object := Void%N%
%			last_boolean := last_boolean.default%N%
%			last_character_8 := last_character_8.default%N%
%			last_character_32 := last_character_32.default%N%
%			last_integer_8 := last_integer_8.default%N%
%			last_integer_16 := last_integer_16.default%N%
%			last_integer_32 := last_integer_32.default%N%
%			last_integer_64 := last_integer_64.default%N%
%			last_natural_8 := last_natural_8.default%N%
%			last_natural_16 := last_natural_16.default%N%
%			last_natural_32 := last_natural_32.default%N%
%			last_natural_64 := last_natural_64.default%N%
%			last_real_32 := last_real_32.default%N%
%			last_real_64 := last_real_64.default%N%
%			last_pointer := last_pointer.default%N%
%		end%N"


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
