indexing
	description: "Event sink that ignores all events"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_PROGRAM_FLOW_SINK

inherit
	PROGRAM_FLOW_SINK

feature -- Access

feature -- Basic operations

	put_feature_exit (res: ANY) is
			-- Ignore event.
		do
			last_result := res
		end

	put_feature_invocation (feature_name: STRING_8; target: ANY; arguments: TUPLE)
			-- Ignore event.
		do

		end

	put_attribute_access (attribute_name: STRING_8; target, value: ANY) is
			-- ignore event
		do

		end

	accept(visitor: PROGRAM_FLOW_SINK_VISITOR) is
			-- Accept a visitor.
		do
			visitor.visit_null_sink (Current)
		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
