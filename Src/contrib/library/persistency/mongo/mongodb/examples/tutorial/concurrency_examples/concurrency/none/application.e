note
	description: "MongoDB multi-threaded example application"
	date: "$Date$"
	revision: "$Revision$"

class APPLICATION

inherit
	WORK_OUTPUT_STREAM

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize and run concurrent MongoDB operations
		local
			i: INTEGER
			l_connection_string: STRING
			w: WORK_EXECUTION
			lst: ARRAYED_LIST [WORK_EXECUTION]
		do
				-- Initialize MongoDB driver
				-- it could also be initialized in the WORK_EXECUTION
			(create {MONGODB_DRIVER}).use

				-- Create connection string and mutex
			l_connection_string := "mongodb://localhost:27017"

			print ("Starting concurrent MongoDB operations with " + Number_of_processors.out + " processors%N")

				-- Launch multiple worker threads
			create lst.make (Number_of_processors)
			from
				i := 1
			until
				i > Number_of_processors
			loop
				create w.make (i, l_connection_string, Current)
				lst.force (w)
				print ("Launch processor " + i.out + "%N")
				w.process
				i := i + 1

			end

				-- This is not needed as it is handled during Garbage Collection.
--			(create {MONGODB_DRIVER}).force_cleanup
		end

feature {NONE} -- Implementation

	Number_of_processors: INTEGER
			-- Number of sequencial executions to run
		do
			Result := {WORK_CONFIG}.Number_of_processors
		end

feature -- Conversion

	output (m: READABLE_STRING_8)
		do
			print (m)
		end

end
