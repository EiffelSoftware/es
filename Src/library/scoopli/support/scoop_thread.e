indexing
	description: "Objects that implement SCOOP threads."
	author: "Pior Nienaltowski, Volkan Arslan"
	date: "$Date$"
	revision: "$Revision$"
	build_number: "0.4.4000"

deferred class
	SCOOP_THREAD
	
inherit
	ANY
		redefine
			default_create
		end
	
	THREAD
		rename
			execute as execute_thread
		undefine
			default_create
		end

feature {NONE} -- Initialization

	default_create is 
			-- Create new thread and associate it with feature `execute_thread'.
		do
			Precursor {ANY}
			launch
		end
		

feature {NONE} -- Implementation	
	
	execute_thread is
			-- Main execution loop.
		deferred
		end	
		
end -- class SCOOP_THREAD
