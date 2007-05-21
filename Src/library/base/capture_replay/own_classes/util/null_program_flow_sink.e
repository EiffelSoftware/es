indexing
	description: "Event sink that ignores all events"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_PROGRAM_FLOW_SINK

inherit
	PROGRAM_FLOW_SINK

create
	make

feature -- Basic operations

	put_feature_exit (res: ANY): ANY is
			-- Ignore event.
		do

		end

	put_feature_invocation (feature_name: STRING_8; target: OBSERVABLE; arguments: TUPLE)
			-- Ignore event.
		do

		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
