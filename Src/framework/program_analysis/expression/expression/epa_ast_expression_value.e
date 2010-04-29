note
	description: "A value representing an AST expression"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_AST_EXPRESSION_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			item,
			is_ast_expression_value,
			is_item_equal
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item; a_type: like type)
			-- Initialize `item' with `a_item' and `type' with `a_type'.
		do
			item_cache := a_item
			type := a_type
		ensure
			item_set: item = item_cache
		end

feature -- Access

	type: TYPE_A
			-- Type of current value

	item: EXPR_AS
			-- Value item in current
		do
			Result := item_cache
		end

feature -- Status report

	is_ast_expression_value: BOOLEAN is True
			-- Is current an AST expression value?

	is_item_equal (other: like Current): BOOLEAN
			-- Is `item' equal to `other'.`item'?
		do
			if item = Void and then other.item = Void then
				Result := True
			elseif item /= Void and then other.item /= Void then
				Result := item.is_equivalent (other.item)
			end
		end

feature{NONE} -- Implementation

	item_cache: like item
			-- Cache for `item'

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_ast_expression_value (Current)
		end


end
