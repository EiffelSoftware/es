indexing
	description: "Summary description for {STRICT_SEQUENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	STRICT_SEQUENCE

inherit
	MONOTONE_SEQUENCE
		redefine
			forth
		end

feature

	forth
		deferred
		ensure then
			value > old value
		end

end
