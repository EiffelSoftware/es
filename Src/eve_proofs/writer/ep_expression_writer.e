indexing
	description:
		"[
			Boogie code writer to generate expressions
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_EXPRESSION_WRITER

inherit

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

	EP_DEFAULT_NAMES
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_mapper: !EP_NAME_MAPPER)
			-- Initialize expression writer with `a_mapper'.
		do
			name_mapper := a_mapper
		ensure
			name_mapper_set: name_mapper = a_mapper
		end

feature -- Access

	name_mapper: !EP_NAME_MAPPER
			-- Name mapper used to create Boogie code names

	old_handler: !EP_OLD_HANDLER
			-- Handler for old expressions

feature -- Element change

	set_name_mapper (a_mapper: like name_mapper)
			-- Set `name_mapper' to `a_name_mapper'.
		do
			name_mapper := a_mapper
		ensure
			name_mapper_set: name_mapper = a_mapper
		end

end
