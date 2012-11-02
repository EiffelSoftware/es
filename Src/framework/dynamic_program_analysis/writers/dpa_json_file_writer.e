note
	description: "Writer using one JSON file to write analysis results."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DPA_JSON_FILE_WRITER

inherit
	DPA_WRITER

	DPA_JSON_CONSTANTS
		export
			{NONE} all
		end

	DPA_JSON_UTILITY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_class: like class_;
		a_feature: like feature_;
		a_directory: like directory;
		a_file_name: like file_name
	)
			-- Initialize JSON file writer.
		require
			a_class_not_void: a_class /= Void
			a_feature_not_void: a_feature /= Void
			a_directory_not_void: a_directory /= Void
			a_file_name_not_void: a_file_name /= Void
		do
			class_ := a_class
			feature_ := a_feature
			directory := a_directory
			file_name := a_file_name

			create transitions.make
		ensure
			class_set: class_ = a_class
			feature_set: feature_ = a_feature
			directory_set: directory.is_equal (a_directory)
			file_name_set: file_name.is_equal (a_file_name)
			transitions_not_void: transitions /= Void
		end

feature -- Access

	directory: STRING
			-- Directory where the analysis result file should be written to.

	file_name: STRING
			-- File name of the analysis result file written by current writer.

feature -- Basic operations

	try_write
			-- Try to write analysis results.
		do
			-- Nothing to be done.
		end

	write
			-- Write analysis results.
		local
			l_transition: EPA_EXPRESSION_VALUE_TRANSITION
			l_json_localized_expression: JSON_STRING
			l_json_transition: JSON_OBJECT
			l_expression_value_type_finder: EPA_EXPRESSION_VALUE_TYPE_FINDER
			l_json_transitions: JSON_ARRAY
			l_all_json_transitions: JSON_OBJECT
			l_json_analysis_results: JSON_OBJECT
			l_json_print_visitor: PRINT_JSON_VISITOR
			l_file_name: FILE_NAME
			l_file: PLAIN_TEXT_FILE
		do
			-- Initialize analysis result data structures.
			create l_json_analysis_results.make
			create l_all_json_transitions.make
			l_json_analysis_results.put (json_string_from_string (class_.name), Json_class)
			l_json_analysis_results.put (
				json_string_from_string (feature_.feature_name_32),
				Json_feature
			)
			l_json_analysis_results.put (l_all_json_transitions, Json_transitions)

			-- Initialize the expression value type finder which finds the type of an expression's
			-- value.
			create l_expression_value_type_finder

			-- Iterate over `transitions' and add each transition's JSON representation to
			-- `json_transition'.
			from
				transitions.start
			until
				transitions.after
			loop
				l_transition := transitions.item_for_iteration

				-- Create JSON representation of current transition.
				create l_json_transition.make

				-- Create key of `l_json_transition' which is used in `internal_json_transition'.
				l_json_localized_expression := json_string_from_string (
					l_transition.expression.text + ";" + l_transition.pre_state_breakpoint.out
				)

				-- Add pre-state results of current transition to `l_json_transition'.
				l_expression_value_type_finder.set_value (l_transition.pre_state_value)
				l_expression_value_type_finder.find

				l_json_transition.put (
					json_string_from_string (l_transition.pre_state_breakpoint.out),
					Json_pre_state_breakpoint
				)
				l_json_transition.put (
					json_string_from_string (l_expression_value_type_finder.type),
					Json_pre_state_type
				)
				l_json_transition.put (
					json_string_from_string (l_transition.pre_state_value.text),
					Json_pre_state_value
				)

				if
					l_expression_value_type_finder.type.is_equal (Reference_value) and then
					attached {CL_TYPE_A} l_transition.pre_state_value.type as l_type
				then
					l_json_transition.put (
						json_string_from_string (l_type.class_id.out),
						Json_pre_state_class_id
					)
				end

				if
					l_expression_value_type_finder.type.is_equal (String_value)
				then
					l_json_transition.put (
						json_string_from_string (l_transition.pre_state_value.item.out),
						Json_pre_state_address
					)
				end

				-- Add post-state results of current transition to `l_json_transition'.
				l_expression_value_type_finder.set_value (l_transition.post_state_value)
				l_expression_value_type_finder.find

				l_json_transition.put (
					json_string_from_string (l_transition.post_state_breakpoint.out),
					Json_post_state_breakpoint
				)
				l_json_transition.put (
					json_string_from_string (l_expression_value_type_finder.type),
					Json_post_state_type
				)
				l_json_transition.put (
					json_string_from_string (l_transition.post_state_value.text),
					Json_post_state_value
				)

				if
					l_expression_value_type_finder.type.is_equal (Reference_value) and then
					attached {CL_TYPE_A} l_transition.post_state_value.type as l_type
				then
					l_json_transition.put (
						json_string_from_string (l_type.class_id.out),
						Json_post_state_class_id
					)
				end

				if
					l_expression_value_type_finder.type.is_equal (String_value)
				then
					l_json_transition.put (
						json_string_from_string (l_transition.post_state_value.item.out),
						json_post_state_address
					)
				end

				-- Add JSON representation of current transition to `internal_json_transitions'.
				if
					l_all_json_transitions.has_key (l_json_localized_expression) and then
					attached {JSON_ARRAY} l_all_json_transitions.item (
						l_json_localized_expression
					) as l_json_existing_transitions
				then
					l_json_existing_transitions.add (l_json_transition)
				else
					create l_json_transitions.make_array
					l_json_transitions.add (l_json_transition)
					l_all_json_transitions.put (
						l_json_transitions,
						l_json_localized_expression
					)
				end

				transitions.forth
			end

			-- Parse `l_json_analysis_results' to get a writable JSON representation of analysis
			-- results.
			create l_json_print_visitor.make
			l_json_analysis_results.accept (l_json_print_visitor)

			-- Write analysis results to disk.
			create l_file_name.make
			l_file_name.set_directory (directory)
			l_file_name.set_file_name (file_name)
			create l_file.make_create_read_write (l_file_name)
			l_file.put_string (l_json_print_visitor.to_json)
			l_file.close
		end

end
