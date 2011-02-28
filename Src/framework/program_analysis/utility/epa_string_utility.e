note
	description: "Various helper functions to generate strings"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STRING_UTILITY

inherit
	EPA_TYPE_UTILITY

	EPA_UTILITY

feature -- Access

	curly_brace_surrounded_integer (i: INTEGER): STRING
			-- An interger surrounded by curly braces
			-- For example {0}.
		do
			create Result.make (20)
			Result.append_character ('{')
			Result.append (i.out)
			Result.append_character ('}')
		end

	double_square_surrounded_integer (i: INTEGER): STRING
			-- An interger surrounded by double square braces.
			-- For example [[0]].
		do
			create Result.make (20)
			Result.append (once "[[")
			Result.append (i.out)
			Result.append (once "]]")
		end

	curly_brace_surrounded_typed_integer (i: INTEGER; a_type: TYPE_A): STRING
			-- An interger (with type) surrounded by curly braces
			-- For example {LINKED_LIST [ANY] @ 1}
		do
			create Result.make (32)
			Result.append_character ('{')
			Result.append (cleaned_type_name (a_type.name))
			Result.append (once " @ ")
			Result.append (i.out)
			Result.append_character ('}')
		end

	anonymous_variable_name (a_position: INTEGER): STRING
			-- Anonymous name for `a_position'-th variable
			-- Format: {`a_position'}, for example "{0}".
		do
			Result := curly_brace_surrounded_integer (a_position)
		end


	curly_braced_operands_from_operands (a_feature: FEATURE_I; a_class: CLASS_C): HASH_TABLE [STRING, STRING]
			-- A mapping from actual operands from `a_feature' viewed in `a_class' to
			-- the curly-braced integer form of those operands.
			-- For example, if `a_feature' is ARRAY.put, then the result would be:
			-- Current -> {0}, v -> {1}, i -> {2}.
		local
			l_operands: like operands_of_feature
		do
			l_operands := operands_of_feature (a_feature)
			create Result.make (l_operands.count)
			Result.compare_objects
			from
				l_operands.start
			until
				l_operands.after
			loop
				Result.force (curly_brace_surrounded_integer (l_operands.item_for_iteration), l_operands.key_for_iteration)
				l_operands.forth
			end
		end

	operands_from_curly_braced_operands (a_feature: FEATURE_I; a_class: CLASS_C): HASH_TABLE [STRING, STRING]
			-- A mapping from curly-braced operands from `a_feature' viewed in `a_class' to
			-- actual operands of those operands.
			-- For example, if `a_feature' is ARRAY.put, then the result would be:
			-- {0} -> Current, {1} -> v, {2} -> i.
		local
			l_operands: like operands_of_feature
		do
			l_operands := operands_of_feature (a_feature)
			create Result.make (l_operands.count)
			Result.compare_objects
			from
				l_operands.start
			until
				l_operands.after
			loop
				Result.force (l_operands.key_for_iteration, curly_brace_surrounded_integer (l_operands.item_for_iteration))
				l_operands.forth
			end
		end

	class_name_dot_feature_name (a_class: CLASS_C; a_feature: FEATURE_I): STRING
			-- String in form of "CLASS_NAME.feature_name' where
			-- the class name is from `a_class' and feature name is from `a_feature'
		do
			create Result.make (a_class.name.count + a_feature.feature_name.count + 1)
			Result.append (a_class.name_in_upper)
			Result.append_character ('.')
			Result.append (a_feature.feature_name)
		end
end
