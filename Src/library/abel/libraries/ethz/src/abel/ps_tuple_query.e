note
	description: "[
		Represents a repository query that returns data tuples of objects.
		Please note that you cannot update or insert data tuples of objects into the repository.
		
		You can set a projection on the attributes you would like to have, to restrict the amount of data that is going to be retrieved.
		You'll get completely loaded objects as attributes if you include an attribute in your projection that is not of a basic type (strings and numbers)		
		]"
	author: "Roman Schmocker"
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TUPLE_QUERY [G->ANY]

inherit
	PS_QUERY [G]
		redefine query_result end

create make

feature

	is_object_query:BOOLEAN = False
			-- Is `Current' an instance of PS_OBJECT_QUERY?


	query_result: PS_RESULT_SET[TUPLE]

feature -- Projections

	--projection: ARRAY [STRING]
			-- Data to be included for projection.


--	set_projection (a_projection: ARRAY [STRING])
			-- Set `a_projection' to the current query.
--		do
--			fixme ("This should be in the creation procedure of the tuple query")			
--			projection := a_projection
--		ensure
--			projected_data_set: projection = a_projection
--		end

end
