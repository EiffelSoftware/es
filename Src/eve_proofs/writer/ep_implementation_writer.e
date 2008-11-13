indexing
	description:
		"[
			Boogie code writer to generate feature implementations
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_IMPLEMENTATION_WRITER

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	EP_DEFAULT_NAMES
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do

		end

feature -- Basic operations

	write_feature_implementation (a_feature: !FEATURE_I)
			-- Write Boogie code for implementation of `a_feature'.
		local
			l_procedure_name: STRING
			i: INTEGER
			l_argument_name: STRING
			l_argument_type: TYPE_A
		do
			l_procedure_name := procedural_feature_name (a_feature)

			put_comment_line ("Implementation")

			-- TODO: code reuse with signature writer => inherit from signature writer?

			put ("implementation " + l_procedure_name + "(Current: ref")
			from
				i := 1
			until
				i > a_feature.argument_count
			loop
				l_argument_name := a_feature.arguments.item_name (i)
				l_argument_type := a_feature.arguments.i_th (i)
				put (", " + l_argument_name + ": " + type_mapper.boogie_type_for_type (l_argument_type))
				i := i + 1
			end
			put (")")
			if not a_feature.type.is_void then
				put (" returns (Result: " + type_mapper.boogie_type_for_type (a_feature.type) + ")")
			end
			put (";%N")
			put_line ("{")

			-- TODO

			put_line ("}")
		end

end
