indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	CALLER
feature -- Basic operations

call (target: ANY; feature_name: STRING; arguments: LIST[ANY]) is
		-- Call `target'.`feature_name'(`arguments')
	deferred end

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
