indexing
	description: "Summary description for {JS_PURE_TYPE_JUDGEMENT_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_PURE_TYPE_JUDGEMENT_NODE

inherit
	JS_PURE_NODE

create
	make
	
feature

	make (a: JS_ARGUMENT_NODE; t: JS_TYPE_NODE)
		do
			argument := a
			type := t
		end

	argument: JS_ARGUMENT_NODE

	type: JS_TYPE_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_pure_type_judgement (Current)
		end

end
