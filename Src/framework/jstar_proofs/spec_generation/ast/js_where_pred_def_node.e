indexing
	description: "Summary description for {JS_WHERE_PRED_DEF_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_WHERE_PRED_DEF_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (n: STRING; args: LINKED_LIST [JS_ARGUMENT_NODE]; b: JS_ASSERTION_NODE)
		do
			pred_name := n
			arguments := args
			body := b
		end

	pred_name: STRING

	arguments: LINKED_LIST [JS_ARGUMENT_NODE]

	body: JS_ASSERTION_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_where_pred_def (Current)
		end

end
