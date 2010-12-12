note
	description: "Constants"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DKN_CONSTANTS

feature -- Escape strings

	escaped_space: STRING = "\_"
			-- Encoded space string

	space: STRING = " "
			-- Space string

	backslash: STRING = "\"
			-- Backslash

	double_backslash: STRING = "\\"
			-- Double baskslash.

feature -- Program point types

	point_program_point: STRING = "point"
	class_program_point: STRING = "class"
	object_program_point: STRING = "object"
	enter_program_point: STRING = "enter"
	exit_program_point: STRING = "exit"
	subexit_program_point: STRING = "subexit"
			-- Types of program points


	progrm_point_types: LINKED_SET [STRING]
			-- Set of program point types
		once
			create Result.make
			Result.compare_objects
			Result.extend (point_program_point)
			Result.extend (class_program_point)
			Result.extend (object_program_point)
			Result.extend (enter_program_point)
			Result.extend (exit_program_point)
			Result.extend (subexit_program_point)
		end

feature -- Program point suffixes

	enter_program_point_suffix: STRING = ":::ENTER"
	exit_program_point_suffix: STRINg = ":::EXIT1"
	ppt_tag_separator: STRING = ":::"

feature -- Variable var-kind

	field_var_kind: STRING = "field"
	function_var_kind: STRING = "function"
	array_var_kind: STRING = "array"
	variable_var_kind: STRING = "variable"
	return_var_kind: STRING = "return"
		-- valid var-kind strings

	var_kinds: LINKED_SET [STRING]
			-- Set of values of var_kind
		once
			create Result.make
			Result.compare_objects
			Result.extend (field_var_kind)
			Result.extend (function_var_kind)
			Result.extend (array_var_kind)
			Result.extend (variable_var_kind)
			Result.extend (return_var_kind)
		end

feature -- Variable rep-type

	boolean_rep_type: STRING = "boolean"
	integer_rep_type: STRING = "int"
	hashcode_rep_type: STRING = "hashcode"
	double_rep_type: STRING = "double"
	string_rep_type: STRING = "java.lang.String"
			-- Variable rep-type strings

	rep_types: LINKED_SET [STRING]
			-- Set of values for rep_type
		once
			create Result.make
			Result.compare_objects
			Result.extend (boolean_rep_type)
			Result.extend (integer_rep_type)
			Result.extend (hashcode_rep_type)
			Result.extend (double_rep_type)
			Result.extend (string_rep_type)
		end

feature -- Nonsensical

	daikon_nonsensical_value: STRING = "nonsensical"
			-- "nonsensical" string used by Daikon

feature -- Modification flag

	modified_flag_0: INTEGER = 0
	modified_flag_1: INTEGER = 1
	modified_flag_2: INTEGER = 2

	modification_flags: LINKED_SET [INTEGER]
			-- Values of possible modification flags
		once
			create Result.make
			Result.extend (modified_flag_0)
			Result.extend (modified_flag_1)
			Result.extend (modified_flag_2)
		end

feature -- Comparability

	boolean_comparability: INTEGER = 1
	integer_comparability: INTEGER = 2
	double_comparability: INTEGER = 3
	hash_code_comparability: INTEGER = 4

feature -- Misc

	daikon_equality_sign: STRING = " == "
			-- Equality sign

	ppt_string: STRING = "ppt"
	ppt_type_string: STRING = "ppt-type"
	var_kind_string: STRING = "var-kind"
	dec_type_string: STRING = "dec-type"
	rep_type_string: STRING = "rep-type"
	comparability_string: STRING = "comparability"
	variable_string: STRING = "variable"

	daikon_version_string: STRING = "decl-version 2.0%N"

end
