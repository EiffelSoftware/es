indexing
	description:
		"[
			Boogie code writer to generate expressions
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_EXPRESSION_WRITER

inherit

	EP_VISITOR

inherit {NONE}

	SHARED_EP_ENVIRONMENT
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_mapper: !EP_NAME_MAPPER)
			-- Initialize expression writer with `a_mapper'.
		do
			name_mapper := a_mapper
			create expression.make
			create side_effect.make
			create {LINKED_LIST [TUPLE [name: STRING; type: STRING]]} locals.make
		ensure
			name_mapper_set: name_mapper = a_mapper
		end

feature -- Access

	name_mapper: !EP_NAME_MAPPER
			-- Name mapper used to create Boogie code names

	old_handler: !EP_OLD_HANDLER
			-- Handler for old expressions

	expression: !EP_OUTPUT_BUFFER
			-- Output produced from expression

	side_effect: !EP_OUTPUT_BUFFER
			-- Side effect instructions

	locals: LIST [TUPLE [name: STRING; type: STRING]]
			-- List of locals needed for side effects

feature -- Status report

	is_recording_side_effects: BOOLEAN
			-- Is writer recording side effects of expressions?

feature -- Element change

	set_name_mapper (a_mapper: like name_mapper)
			-- Set `name_mapper' to `a_name_mapper'.
		do
			name_mapper := a_mapper
		ensure
			name_mapper_set: name_mapper = a_mapper
		end

	reset
			-- Reset expression writer for a new expression.
		do
			expression.reset
			side_effect.reset
			locals.wipe_out
		end

feature {BYTE_NODE} -- Visitors




end
