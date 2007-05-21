indexing
	description: "[
					Object that's able to call features by name on a given target.
				 ]"
	author: "Stefan Sieber"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CALLER

feature -- Basic operations

call (target: ANY; feature_name: STRING; arguments: LIST[ANY]) is
		-- Call `target'.`feature_name'(`arguments')
	deferred end

invariant
	invariant_clause: True -- Your invariant here

end
