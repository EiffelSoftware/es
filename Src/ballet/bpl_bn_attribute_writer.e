indexing
	description: "Write out the definition of an attribute"
	author: "Bernd Schoeller, Raphael Mack"
	date: "$Date$"
	revision: "$Revision$"

class
	BPL_BN_ATTRIBUTE_WRITER

inherit
	BPL_BN_FUNCTION_WRITER
		export {NONE}
			write_function
		end

create
	make

feature -- Main

	write_attribute (feat: FEATURE_I) is
			-- Write the definition of the attribute pointed to by `l_as'.
		require
			feat_not_void: feat /= Void
			feat_is_attribute: feat.is_attribute
		local
			field_name: STRING
		do
			field_name := "field." + current_class.name + "." + feat.feature_name
			bpl_out ("// Attribute: " + feat.feature_name + " of class " + current_class.name + "%N")
			bpl_out ("const unique " + field_name + ": <any>name;%N")

			write_function (feat)

			bpl_out ("  axiom (forall H:[ref,<x>name]x, C:ref :: {" + result_call + "} " +
				result_call + " == H[C," + field_name + "]);%N")
			bpl_out ("%N")
		end

end
