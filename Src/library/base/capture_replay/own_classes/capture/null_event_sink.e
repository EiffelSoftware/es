indexing
	description: "Event sink that ignores all events"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

class
	NULL_EVENT_SINK

inherit
	CONTROLLER

create
	make

feature -- Basic operations

	methodbody_end (res: ANY): ANY is
			-- Ignore event.
		do

		end

	methodbody_start (feature_name: STRING_8; target: OBSERVABLE; arguments: TUPLE)
			-- Ignore event.
		do

		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
