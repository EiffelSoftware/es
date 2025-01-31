note
	description: "[
			Object to handle the MongoDB lifecyle. 
			Call at initialize feature before any feature call to MongoDB API.
			
			(At the end of the process, only if required in specific cases call force_cleanup, 
			 otherwise leave the Garbage Collector handles the cleanup).
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Object Lifecycle", "protocol=URI", "src=https://mongoc.org/libmongoc/current/lifecycle.html#"

class
	MONGODB_DRIVER

feature -- Basic operation

	initialize
			-- Enter the MongoDB C driver context
			-- initialize only once the driver for a same thread.
		require
			not is_destroyed
		do
			implementation.initialize_driver
		ensure
			is_initialized
		end

	force_cleanup
			-- Force the driver cleanup, it should not be called directly as it is handled automatically
			-- thanks to the garbage collector
			-- be aware that once the driver is cleanup, there is NO way to initialize again the driver to use it
			-- so it should really be done at the end of your process (or thread) execution
		do
			if
				is_initialized and then
				not is_destroyed
			then
				implementation.cleanup_driver
			end
		end

feature -- Status report

	is_initialized: BOOLEAN
			-- Driver is initialized
		do
			Result := implementation.is_initialized
		end

	is_destroyed: BOOLEAN
			-- Driver was already destroyed/cleanup
		do
			Result := implementation.is_destroyed
		end

feature {NONE} -- Implementation

	implementation: MONGODB_DRIVER_IMP
		once -- per Thread
			create Result
		end

end
