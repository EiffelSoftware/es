indexing
	description: "Summary description for {B}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	A

feature

	process (a_processor: !PROCESSOR)
		deferred
		ensure
			a_processor.sum = a_processor.sum -- modifies sum
		end

end
