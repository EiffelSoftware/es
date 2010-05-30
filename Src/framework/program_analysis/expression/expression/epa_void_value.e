note
	description: "Summary description for {AFX_VOID_VALUE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_VOID_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			type,
			item,
			is_void,
			as_void
		end

	ITP_SHARED_CONSTANTS
		undefine
			is_equal,
			copy,
			out
		end
create
	make

feature{NONE} -- Initialization

	make is
			-- Initialize Current.
		do
			type := none_type
			item := void_value
		end

feature -- Access

	type: TYPE_A
			-- Type of current value

	item: ANY
			-- Value item in current

	as_void: detachable EPA_VOID_VALUE
			-- Current as integer
		do
			Result := Current
		end

feature -- Status report

	is_void: BOOLEAN = True
			-- Is current a Void value?

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_void_value (Current)
		end

end
