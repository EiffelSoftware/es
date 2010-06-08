indexing
	description: "Summary description for {JS_MAPSTO_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_MAPSTO_NODE

inherit
	JS_ASSERTION_NODE

create
	make

feature

	make (o: JS_ARGUMENT_NODE; f: JS_FIELD_SIG_NODE; v: JS_ARGUMENT_NODE)
		do
			object := o
			field_signature := f
			value := v
		end

	object: JS_ARGUMENT_NODE

	field_signature: JS_FIELD_SIG_NODE

	value: JS_ARGUMENT_NODE

	accept (v: JS_SPEC_VISITOR)
		do
			v.process_mapsto (Current)
		end

end
