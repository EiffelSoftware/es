indexing
	description:
		"[
			Boogie code writer for attributes.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_CONSTANT_WRITER

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

feature -- Basic operations

	write_constant (a_feature: !FEATURE_I)
			-- Write Boogie code for `a_feature'.
		require
			is_constant: a_feature.is_constant
		local
			l_functional_name, l_type, l_value: STRING
			l_constant: CONSTANT_I
			l_error: EP_GENERAL_ERROR
		do
			l_constant ?= a_feature
			check l_constant /= Void end

			l_functional_name := name_generator.functional_feature_name (a_feature)
			l_type := type_mapper.boogie_type_for_type (a_feature.type)

			put_comment_line ("Functional represenation of constant")
			put_line ("function " + l_functional_name + "(heap: HeapType, current: ref) returns (" + l_type + ");")
			put_new_line

			if l_constant.value.is_boolean then
				l_value := boolean_value (l_constant.value)
			elseif l_constant.value.is_integer then
				l_value := integer_value (l_constant.value)
			elseif l_constant.value.is_character then
				l_value := character_value (l_constant.value)
			else
				create l_error.make (names.error_constant_type_not_supported)
				l_error.set_description (names.description_constant_type_not_supported)
				l_error.set_class (a_feature.written_class)
				l_error.set_feature (a_feature)
				l_error.set_location (a_feature.body.body.type.start_location)
				warnings.extend (l_error)
			end

			if l_value = Void then
				put_comment_line ("Unsupported type, no axiom generated")
			else
				put_comment_line ("Axiomatic mapping of function to constant value")
				put_line ("axiom (forall heap: HeapType, current: ref ::")
				put_line ("            { " + l_functional_name + "(heap, current) } // Trigger");
				put_line ("        IsHeap(heap) ==> (" + l_functional_name + "(heap, current) == " + l_value + "));")
				put_new_line
			end
		end

feature {NONE} -- Implementation

	boolean_value (a_value: VALUE_I): STRING
			-- Value of `a_value' for Boogie
		require
			a_value.is_boolean
		local
			l_bool: BOOL_VALUE_I
		do
			l_bool ?= a_value
			if l_bool.boolean_value then
				Result := "true"
			else
				Result := "false"
			end
		end

	integer_value (a_value: VALUE_I): STRING
			-- Value of `a_value' for Boogie
		require
			a_value.is_integer
		local
			l_int: INTEGER_CONSTANT
		do
			l_int ?= a_value
			Result := l_int.integer_32_value.out
		end

	character_value (a_value: VALUE_I): STRING
			-- Value of `a_value' for Boogie
		require
			a_value.is_character
		local
			l_char: CHAR_VALUE_I
		do
			l_char ?= a_value
			Result := l_char.character_value.code.out
		end

end
