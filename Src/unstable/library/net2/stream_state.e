note
	description: "{STREAM_STATE} represents the state of a stream."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STREAM_STATE

feature -- Status report
	is_open: BOOLEAN
		-- Is the current stream open? May change to False at any time due to a lost connection
		deferred
		end

feature -- Status setting
	close
		-- Closes the stream. May affect other streams on the same medium.
		deferred
		ensure
			not is_open
		end
end
