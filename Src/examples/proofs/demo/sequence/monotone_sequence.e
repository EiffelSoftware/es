indexing
	description: "Summary description for {MONOTONE_SEQUENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MONOTONE_SEQUENCE

inherit
	INTEGER_SEQUENCE
		redefine
			forth
		end

feature

	forth
		deferred
		ensure then
			value >= old value
		end

end
