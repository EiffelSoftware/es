note
	description: "Class that represents an integer query, used to infer sequence-based properties"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CI_INTEGER_QUERY

inherit
	HASHABLE
		undefine
			out
		end

	DEBUG_OUTPUT
		redefine
			out
		end

	EPA_STRING_UTILITY
		undefine
			out
		end

create
	make

feature{NONE} -- Initialization

	make (a_target_operand_index: INTEGER; a_type: like target_operand_type; a_feature_name: like feature_name)
			-- Initialize Current.		
		do
			target_operand_index := a_target_operand_index
			target_operand_type := a_type

			create out.make (32)
			out.append_character ('{')
			out.append (target_operand_index.out)
			if a_feature_name = Void then
				feature_name := Void
			else
				feature_name := a_feature_name.twin
				out.append_character ('.')
				out.append (feature_name)
			end
			out.append_character ('}')
			hash_code := out.hash_code
			debug_output := out
		end

feature -- Access

	target_operand_index: INTEGER
			-- Index of 0-based target operand

	feature_name: detachable STRING
			-- Feature name of the integer query on `target_operand_index'
			-- If Void, the operand at `target_operand_index' is an integer query itself

	target_operand_type: TYPE_A
			-- Static type of the operand at position `target_operand_index'
			-- Note: The type should be resolved.

	out, debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.			

	hash_code: INTEGER
			-- Hash code value

	final_feature_name (a_dynamic_type: TYPE_A): STRING
			-- Actual text of current integer query when evaluated using `a_dynamic_type'
		require
			a_dynamic_type_valid: a_dynamic_type.has_associated_class
			current_valid: not is_target_integer_query
		local
			l_feature: FEATURE_I
		do
				-- If current is a feature access on an operand.
			l_feature := target_operand_type.associated_class.feature_named (feature_name)
			l_feature := a_dynamic_type.associated_class.feature_of_rout_id_set (l_feature.rout_id_set)
			create Result.make (32)
			Result.append (l_feature.feature_name.as_lower)
		end

feature -- Status

	is_target_integer_query: BOOLEAN
			-- Is the operand at position `target_operand_index' an integer query?
		do
			Result := target_operand_type.is_integer
		end

end
