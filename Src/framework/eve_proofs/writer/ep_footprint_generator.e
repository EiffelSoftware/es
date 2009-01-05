indexing
	description:
		"[
			TODO
		]"
	date: "$Date$"
	revision: "$Revision$"

class EP_FOOTPRINT_GENERATOR

inherit

	EP_VISITOR
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make
			-- TODO
		do

		end

feature -- Access

	footprints: HASH_TABLE [ANY, INTEGER]
			-- TODO

end
