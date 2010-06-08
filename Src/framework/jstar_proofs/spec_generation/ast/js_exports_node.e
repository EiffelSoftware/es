indexing
	description: "Summary description for {JS_EXPORTS_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_EXPORTS_NODE

inherit
	JS_SPEC_NODE

create
	make

feature

	make (nfl: LINKED_LIST [JS_NAMED_FORMULA_NODE]; wpl: LINKED_LIST [JS_WHERE_PRED_DEF_NODE])
		do
			named_formulas := nfl
			where_pred_defs := wpl
		end

	named_formulas: LINKED_LIST [JS_NAMED_FORMULA_NODE]

	where_pred_defs: LINKED_LIST [JS_WHERE_PRED_DEF_NODE]

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_exports (Current)
		end

end
