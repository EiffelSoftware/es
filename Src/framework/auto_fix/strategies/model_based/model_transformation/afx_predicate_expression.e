note
	description: "Summary description for {AFX_PREDICATE_EXPRESSION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PREDICATE_EXPRESSION

inherit
    EPA_HASH_CALCULATOR

    DEBUG_OUTPUT

    AFX_SHARED_BOOLEAN_STATE_OUTLINE_MANAGER

create
    make_with_ast_expression, make_from_xml_string

feature -- Initialize

	make_with_ast_expression (an_exp: EPA_AST_EXPRESSION; a_predicator: like predicator; a_predicator_string: like predicator_string)
			-- Initialize.
		do
			expression := an_exp
			predicator := a_predicator
			predicator_string := a_predicator_string
		end

	make_from_xml_string (a_xml_string: STRING; a_class: CLASS_C)
			-- Initialize.
		local
		    l_start_pos, l_end_pos: INTEGER
		    l_exp_str, l_predicator_str: STRING
		    l_extractor: AFX_BOOLEAN_STATE_OUTLINE_EXTRACTOR_I
		do
		    l_start_pos := a_xml_string.index_of ('(', 1)
		    l_end_pos := a_xml_string.last_index_of (')', a_xml_string.count)
		    check l_start_pos > 0 and then l_end_pos > 0 and l_start_pos < l_end_pos and then l_end_pos <= a_xml_string.count end
		    l_exp_str := a_xml_string.substring (l_start_pos + 1, l_end_pos - 1)
		    create expression.make_with_text (a_class, Void, l_exp_str, a_class)

		    	-- predicator from string
		    l_extractor := boolean_state_outline_manager.effective_extractor
		    if l_end_pos < a_xml_string.count then
		    		-- integer queries
    		    l_predicator_str := a_xml_string.substring (l_end_pos + 1, a_xml_string.count)
    		    predicator_string := l_predicator_str
    		    predicator := l_extractor.predicator_from_string (predicator_string)
    		    check predicator /= Void end
    		else
    		    	-- boolean queries
    		    predicator_string := ""
    		    predicator := l_extractor.predicator_from_string (predicator_string)
    		    check predicator /= Void end
		    end
		end

feature -- Access

	expression: EPA_AST_EXPRESSION
			-- Original expression.

	predicator: PREDICATE [ANY, TUPLE[ANY]]
			-- Predicator builds a predicate using the value of `expression'.

	predicator_string: STRING
			-- String representation of `predicator'.

feature -- Status report

	is_predicate: BOOLEAN is True
			-- <Precursor>

	to_xml_string: STRING
			-- String representation in XML format.
		local
		    l_string: STRING
		do
		    l_string := to_string
		    l_string.replace_substring_all ("<", "&lt;")
		    l_string.replace_substring_all (">", "&gt;")
		    Result := l_string
		end

	to_string: STRING
			-- String representation.
		do
		    Result := "("
		    Result.append (expression.debug_output)
		    Result.append (")")
		    Result.append (predicator_string)
		end

	debug_output: STRING
			-- <Precursor>
		do
		    Result := to_string
		end

feature{NONE} -- Implementation

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
