note
	description: "Reader using one file in the JSON format to read analysis results."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_JSON_FILE_READER

inherit
	DPA_READER

	DPA_JSON_CONSTANTS
		export
			{NONE} all
		end

	DPA_JSON_UTILITY
		export
			{NONE} all
		end

	KL_SHARED_STRING_EQUALITY_TESTER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_directory: like directory; a_file_name: like file_name)
			-- Initialize JSON file reader.
		require
			a_directory_not_void: a_directory /= Void
			a_file_name_not_void: a_file_name /= Void
		local
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
			l_json_parser: JSON_PARSER
		do
			directory := a_directory
			file_name := a_file_name

			-- Check validity of `directory' and `file_name'.
			create l_file_name.make
			l_file_name.set_directory (directory)
			l_file_name.set_file_name (file_name)

			check
				directory_and_file_name_valid: l_file_name.is_valid
			end

			-- Read whole file.
			create l_file.make (l_file_name)

			check
				file_exists_and_is_readable: l_file.exists and l_file.is_readable
			end

			l_file.open_read
			l_file.read_stream (l_file.count)

			-- Parse analysis results.
			create l_json_parser.make_parser (l_file.last_string)

			check
				attached {JSON_OBJECT} l_json_parser.parse as l_json_analysis_results
			then
				check
					class_exists: l_json_analysis_results.has_key (Json_class)
				then
					-- Extract class.
					class_ := string_from_json_value (l_json_analysis_results.item (Json_class))
				end

				check
					feature_exists: l_json_analysis_results.has_key (Json_feature)
				then
					-- Extract feature.
					feature_ := string_from_json_value (l_json_analysis_results.item (Json_feature))
				end

				check
					transitions_exist: l_json_analysis_results.has_key (Json_transitions)
				then
					-- Extract transitions.
					internal_transitions := transitions_from_json_value (
						l_json_analysis_results.item (Json_transitions)
					)
				end
			end

			l_file.close

			expression_evaluation_plan := expression_evaluation_plan_from_internal_transitions
		ensure
			directory_set: directory.is_equal (a_directory)
			file_name_set: file_name.is_equal (a_file_name)
			class_set: class_ /= Void and then class_.count >= 1
			feature_set: feature_ /= Void and then feature_.count >= 1
			internal_transitions_not_void: internal_transitions /= Void
			expression_evaluation_plan_not_void: expression_evaluation_plan /= Void
		end

feature -- Access

	directory: STRING
			-- Directory where the analysis result file is stored.

	file_name: STRING
			-- File name of the analysis result file.

	class_: STRING
			-- Context class of `feature_'.

	feature_: STRING
			-- Feature which was analyzed.

	expression_evaluation_plan: DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- Expression evaluation plan specifying the program locations at which an expression
			-- is evaluated before and after the execution of a program location.
			-- Keys are expressions.
			-- Values are program locations.

	number_of_transitions (a_expression: STRING; a_program_location: INTEGER): INTEGER
			-- Number of transitions for `a_expression' evaluated before and after
			-- the execution of `a_program_location'.
		do
			Result :=
				internal_transitions.item (a_expression + ";" + a_program_location.out).count
		end

	transitions (a_expression: STRING; a_program_location: INTEGER):
		ARRAYED_LIST [EPA_VALUE_TRANSITION]
			-- Transitions for `a_expression' evaluated before and after the exeuction of
			-- `a_program_location'.
		local
			l_transitions: ARRAYED_LIST [EPA_VALUE_TRANSITION]
		do
			l_transitions := internal_transitions.item (
				a_expression + ";" + a_program_location.out
			)

			create Result.make (l_transitions.count)
			l_transitions.do_all (agent Result.extend)
		end

feature {NONE} -- Inapplicable

	subset_of_transitions (
		a_expression: STRING;
		a_program_location: INTEGER;
		a_lower_bound: INTEGER;
		a_upper_bound: INTEGER
	): ARRAYED_LIST [EPA_VALUE_TRANSITION]
			-- Subset of transitions for `a_expression' evaluated before and after
			-- the execution of `a_program_location'.
			-- Valid values of `a_lower_bound' and `a_upper_bound' are in the interval between 1
			--and `number_of_transitions'.
		do
		end

feature {NONE} -- Implementation

	internal_transitions: DS_HASH_TABLE [ARRAYED_LIST [EPA_VALUE_TRANSITION], STRING]
			-- Internal representation of transitions.

feature {NONE} -- Implementation

	transitions_from_json_value (a_json_value: JSON_VALUE):
		DS_HASH_TABLE [ARRAYED_LIST [EPA_VALUE_TRANSITION], STRING]
			-- Transitions from `a_json_value' if `a_json_value' is a JSON_OBJECT.
			-- Keys are localized expressions of the form "expression;program location".
			-- Values are transitions.
		require
			a_json_value_not_void: a_json_value /= Void
		local
			i, j, l_json_localized_expressions_count: INTEGER
			l_json_localized_expression: JSON_STRING
			l_json_localized_expressions: ARRAY [JSON_STRING]
			l_transitions: ARRAYED_LIST [EPA_VALUE_TRANSITION]
			l_value, l_type, l_class_id, l_address: STRING
			l_pre_state_breakpoint, l_post_state_breakpoint: INTEGER
			l_pre_state_value, l_post_state_value: EPA_EXPRESSION_VALUE
			l_transition: EPA_VALUE_TRANSITION
			l_json_transitions_for_expression_count: INTEGER
		do
			check
				attached {JSON_OBJECT} a_json_value as l_json_transitions
			then
				-- Iterate over keys of the JSON object.
				l_json_localized_expressions := l_json_transitions.current_keys
				l_json_localized_expressions_count := l_json_localized_expressions.count

				create Result.make (l_json_localized_expressions_count)
				Result.set_key_equality_tester (string_equality_tester)

				from
					i := 1
				until
					i > l_json_localized_expressions_count
				loop
					l_json_localized_expression := l_json_localized_expressions.item (i)
					check
						attached {JSON_ARRAY} l_json_transitions.item (
							l_json_localized_expression
						) as l_json_transitions_for_expression
					then
						-- Iterate over the JSON array containing pre-state and post-state values.
						l_json_transitions_for_expression_count :=
							l_json_transitions_for_expression.count

						create l_transitions.make (l_json_transitions_for_expression_count)

						from
							j := 1
						until
							j > l_json_transitions_for_expression_count
						loop
							check
								attached {JSON_OBJECT} l_json_transitions_for_expression.i_th (j)
								as l_json_transition
							then
								-- Extract pre-state and post-state values.

								-- Extract pre-state value.
								l_pre_state_breakpoint := string_from_json_value (
									l_json_transition.item (Json_pre_state_breakpoint)
								).to_integer

								l_value := string_from_json_value (
									l_json_transition.item (Json_pre_state_type)
								)

								l_type := string_from_json_value (
									l_json_transition.item (Json_pre_state_type)
								)

								if
									l_type.is_equal (Reference_value)
								then
									l_class_id := string_from_json_value (
										l_json_transition.item (Json_pre_state_class_id)
									)

									l_pre_state_value := new_reference_value (l_value, l_class_id)
								elseif
									l_type.is_equal (String_value)
								then
									l_address := string_from_json_value (
										l_json_transition.item (Json_pre_state_address)
									)

									l_pre_state_value := new_string_value (l_value, l_address)
								else
									l_pre_state_value := new_expression_value (l_value, l_type)
								end

								-- Extract post-state value.
								l_post_state_breakpoint := string_from_json_value (
										l_json_transition.item (
											Json_post_state_breakpoint
										)
								).to_integer

								l_value := string_from_json_value (
									l_json_transition.item (Json_post_state_value)
								)

								l_type := string_from_json_value (
									l_json_transition.item (Json_post_state_type)
								)

								if
									l_type.is_equal (Reference_value)
								then
									l_class_id := string_from_json_value (
										l_json_transition.item (Json_post_state_class_id)
									)

									l_post_state_value := new_reference_value (l_value, l_class_id)
								elseif
									l_type.is_equal (String_value)
								then
									l_address := string_from_json_value (
										l_json_transition.item (Json_post_state_address)
									)

									l_post_state_value := new_string_value (l_value, l_address)
								else
									l_post_state_value := new_expression_value (l_value, l_type)
								end

								create l_transition.make (
									l_pre_state_breakpoint,
									l_pre_state_value,
									l_post_state_breakpoint,
									l_post_state_value
								)

								l_transitions.extend (l_transition)
							end

							j := j + 1
						end
					end

					Result.force_last (
						l_transitions,
						string_from_json_value (l_json_localized_expression)
					)

					i := i + 1
				end
			end
		ensure
			Result_not_void: Result /= Void
		end

	expression_evaluation_plan_from_internal_transitions:
		DS_HASH_TABLE [DS_HASH_SET [INTEGER], STRING]
			-- Expression evaluation plan from `internal_transitions' specifying the program
			-- locations at which an expression is evaluated before and after the execution of a
			-- program location.
			-- Keys are expressions.
			-- Values are program locations.
		local
			l_localized_expression: LIST [STRING]
			l_expression, l_program_location: STRING
			l_program_locations: DS_HASH_SET [INTEGER]
		do
			create Result.make_default
			Result.set_key_equality_tester (string_equality_tester)

			-- Iterate over keys of `internal_transitions'.
			from
				internal_transitions.start
			until
				internal_transitions.after
			loop
				-- Split current key into expression and program location.
				l_localized_expression :=
					internal_transitions.key_for_iteration.split (';')

				l_expression := l_localized_expression.i_th (1)
				l_expression.right_adjust
				l_expression.left_adjust

				l_program_location := l_localized_expression.i_th (2)
				l_program_location.right_adjust
				l_program_location.left_adjust

				if
					Result.has (l_expression)
				then
					Result.item (l_expression).force_last (l_program_location.to_integer)
				else
					create l_program_locations.make_default
					l_program_locations.force_last (l_program_location.to_integer)
					Result.force_last (l_program_locations, l_expression)
				end

				internal_transitions.forth
			end
		ensure
			Result_not_void: Result /= Void
		end

end
