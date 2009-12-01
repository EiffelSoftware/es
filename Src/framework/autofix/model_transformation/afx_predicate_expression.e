note
	description: "Summary description for {AFX_PREDICATE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PREDICATE_EXPRESSION

inherit

    AFX_HASH_CALCULATOR

create
    make_with_ast_expression

feature -- initialize

	make_with_ast_expression (an_exp: AFX_AST_EXPRESSION; a_predicator: like predicator; a_predicator_string: like predicator_string)
			-- initialization
		do
			expression := an_exp
			predicator := a_predicator
			predicator_string := a_predicator_string
		end

feature -- access

	expression: AFX_AST_EXPRESSION
			-- original expression

	predicator: PREDICATE [ANY, TUPLE[ANY]]
			-- predicator to turn the expression into a predicate

	predicator_string: STRING
			-- string representation of `predicator'

feature -- status report

	is_predicate: BOOLEAN is True
			-- <Precursor>

feature{NONE} -- implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
	        create l_list.make (2)
	        l_list.force_last (expression.hash_code)
	        l_list.force_last (predicator.hash_code)

	        Result := l_list
		end

end
