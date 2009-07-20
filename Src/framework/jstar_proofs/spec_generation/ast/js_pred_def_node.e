indexing
	description: "Summary description for {JS_PRED_DEF_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_PRED_DEF_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (n: STRING; t: JS_VARIABLE_NODE; l: LINKED_LIST [JS_PARAM_NODE]; b: JS_ASSERTION_NODE)
		do
			predicate_name := n
			target_param := t
			param_list := l
			body := b
		end

	predicate_name: STRING

	target_param: JS_VARIABLE_NODE

	param_list: LINKED_LIST [JS_PARAM_NODE]

	body: JS_ASSERTION_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_pred_def (Current)
		end
		
end
