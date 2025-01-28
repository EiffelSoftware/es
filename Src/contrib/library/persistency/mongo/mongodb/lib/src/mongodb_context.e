note
	description: "[
			Object to handle the MongoDB lifecyle. 
			Call at start feature before any feature call to MongoDB API.
			At the end of the project call finish.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Object Lifecycle", "protocol=URI", "src=https://mongoc.org/libmongoc/current/lifecycle.html#"

class
	MONGODB_CONTEXT

feature

	start
			-- Initialyze the underlaying MongoDB C driver.
			-- Call it exactly once at the beginning of you application.
			--| It's responsible for initializing global state such use process counter,
			--| SSL and threading primitives.
		note
			EIS: "name=init", "protocol=URI", "src=https://mongoc.org/libmongoc/current/mongoc_init.html"
		do
			{MONGODB_EXTERNALS}.c_mongoc_init
		end


	finish
			-- Call it exactlyt once at the end of your program to release all memory and resources allocated by the
			-- driver.
		note
			EIS: "name=cleanup", "protocol=URI", "src=https://mongoc.org/libmongoc/current/mongoc_cleanup.html"
		do
			{MONGODB_EXTERNALS}.c_mongoc_cleanup
		end
end
