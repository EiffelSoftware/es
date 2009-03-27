indexing
	description: "Summary description for {SEQUENCE}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	INTEGER_SEQUENCE

feature

	value: INTEGER


	forth
		deferred
		ensure
			value = value
		end

end
