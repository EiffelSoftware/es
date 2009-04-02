indexing
	description: "Summary description for {INTEGER_SEQUENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	INTEGER_SEQUENCE

feature

	item: INTEGER

	forth
		deferred
		ensure
			item = item -- modifies
		end

end
