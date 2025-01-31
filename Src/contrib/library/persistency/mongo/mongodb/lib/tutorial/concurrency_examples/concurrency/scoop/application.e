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
			w: separate WORK_EXECUTION
			lst: ARRAYED_LIST [separate WORK_EXECUTION]
		do
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
				separate w as w_sep do
					print ("Launch processor " + i.out + "%N")
					w_sep.process
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	Number_of_processors: INTEGER
			-- Number of concurrent scoop processor to run
		do
			Result := {WORK_CONFIG}.Number_of_processors
		end

feature -- Conversion

	output (m: separate READABLE_STRING_8)
		local
			s: STRING_8
		do
			create s.make_from_separate (m)
			print (s)
		end

end
