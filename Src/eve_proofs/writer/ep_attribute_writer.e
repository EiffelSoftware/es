indexing
	description:
		"[
			Boogie code writer for attributes.
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_ATTRIBUTE_WRITER

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

feature -- Basic operations

	write_attribute (a_feature: !FEATURE_I)
			-- Write Boogie code for `a_feature'.
		require
			is_attribute: a_feature.is_attribute
		local
			l_field_name: STRING
			l_functional_name: STRING
			l_type: STRING
		do
			l_field_name := name_generator.attribute_name (a_feature)
			l_functional_name := name_generator.functional_feature_name (a_feature)
			l_type := type_mapper.boogie_type_for_type (a_feature.type)

			put_comment_line ("Attribute name")
			put_line ("const unique " + l_field_name + ": <" + l_type + ">name;")
			put_new_line

			put_comment_line ("Functional represenation of attribute")
			put_line ("function " + l_functional_name + "(heap: [ref, <x>name]x, current: ref) returns (" + l_type + ";")
			put_new_line

			put_comment_line ("Axiomatic mapping of attribute to heap location")
			put_line ("axiom (forall heap: [ref, <x>name]x, current: ref ::")
			put_line ("            { " + l_functional_name + "(heap, current) } // Trigger");
			put_line ("        IsHeap(heap) ==> (" + l_functional_name + "(heap, current) == heap[current, " + l_field_name + "]));")
			put_new_line
		end

end
