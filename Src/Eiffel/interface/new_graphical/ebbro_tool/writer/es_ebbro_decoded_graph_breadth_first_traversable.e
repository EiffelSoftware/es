indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ES_EBBRO_DECODED_GRAPH_BREADTH_FIRST_TRAVERSABLE

inherit
	ES_EBBRO_DECODED_GRAPH_TRAVERSABLE

feature {NONE} -- Implementation

	new_dispenser: ARRAYED_QUEUE [ANY] is
			-- Create the dispenser to use for storing visited objects.
		do
			create Result.make (default_size)
		end


end
