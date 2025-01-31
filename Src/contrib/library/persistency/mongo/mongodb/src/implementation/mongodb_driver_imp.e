note
	description: "Summary description for {MONGODB_DRIVER_IMP}."
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_DRIVER_IMP

inherit
	DISPOSABLE

feature -- Access

	is_initialized: BOOLEAN
			-- MongoDB Driver was initialized.

	is_destroyed: BOOLEAN
			-- MongoDB Driver was cleanup

feature {MONGODB_DRIVER} -- Basic operations

	initialize_driver
			-- Initialize the underlaying MongoDB C driver.
			-- Call it exactly once at the beginning of you application.
			--| It's responsible for initializing global state such use process counter,
			--| SSL and threading primitives.
		note
			EIS: "name=init", "protocol=URI", "src=https://mongoc.org/libmongoc/current/mongoc_init.html"
		require
			not is_destroyed
		do
			if not is_initialized then
				is_initialized := True
				debug ("mongodb_mem")
					print (generator + ".initialize_driver%N")
				end
				{MONGODB_EXTERNALS}.c_mongoc_init
				debug ("mongodb_mem")
					print (generator + ".initialize_driver: completed%N")
				end
			end
		ensure
			is_initialized
		end

	cleanup_driver
			-- Call it exactly once at the end of your thread execution to release all memory and resources allocated by the
			-- driver.
		note
			EIS: "name=cleanup", "protocol=URI", "src=https://mongoc.org/libmongoc/current/mongoc_cleanup.html"
		require
			is_initialized
			not is_destroyed
		do
			debug ("mongodb_mem")
				if not is_in_final_collect then
					print (generator + ".cleanup_driver%N")
				end
			end
			{MONGODB_EXTERNALS}.c_mongoc_cleanup
			is_destroyed := True
			debug ("mongodb_mem")
				if not is_in_final_collect then
					print (generator + ".cleanup_driver: completed%N")
				end
			end
		ensure
			is_destroyed
		end

feature -- Removal

	dispose
			-- <Precursor/>
		do
			if is_initialized then
				cleanup_driver
			end
		end

end
