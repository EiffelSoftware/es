note
	description: "Summary description for {PS_OBJECT_DISASSEMBLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_OBJECT_DISASSEMBLER

feature
	-- if possible, don't deal with primary keys yet. use poids instead.


	-- Intermezzo: What is required for a recursive function disassemble?
		-- The current object
		-- The current object graph depth
		-- The mode (Insert, Update, Delete)
	-- What is required at the class level
		-- A place to get POIDs
		-- The starting object graph depth for all modes (and maybe some special modes if inserts during update are treated differently)
		-- An internal store
		-- Maybe a place to get object metadata
		-- the COLLECTION_HANDLER objects

	disassemble (an_object:ANY) : detachable -- delete detachable later
		PS_ABSTRACT_DB_OPERATION
		-- Disassembles the object, returning an object graph of insert/update statements
		do
			-- ask if POID exists:
				 -- if "update_mode" and it exists, proceed
				 -- if "insert_mode" and it doesn't exist, register object and proceed
				 -- if "update_mode" and it doesn't exists, set to "insert_mode", register object and proceed (change back at end of function) (only if boolean flag for this behaviour is on)
				 -- if "insert_mode" and it exists, based on boolean flag, set to "update mode" or just return correct poid

			-- ask the internal store if the object is already disassembled (infinite recurion prevention)

				-- if yes, just return that object

			--else

				-- create the result based on mode and register it at internal store

				-- get all the basic values out

				-- handle reference types:
					-- if object_graph_depth not 1, call disassemble on referenced types and set the dependency in current Result
					-- else see if we still have to update the reference, or even update/insert the next object
					-- else set dependency to 0 / "don't care"


			-- TODO: How to handle collecions?
			-- Maybe have a special deferred class COLLECTION_HANDLER, and then before handling reference types, first ask all handlers if they can cope with the next reference
			-- This principle has to be done then throughout all layers.

		end


		insert_mode:BOOLEAN
			-- Are we in insert mode?

end
