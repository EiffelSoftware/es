note
	description: "This class is the ancestor to all objects representing an error that might occur during execution."
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_ERROR
inherit
	DEVELOPER_EXCEPTION

feature

	description:STRING
			-- A human-readable string containing an error description
		deferred
		end


	accept (a_visitor: PS_ERROR_VISITOR)
			-- `accept' function of the visitor pattern
		deferred
		end


end
