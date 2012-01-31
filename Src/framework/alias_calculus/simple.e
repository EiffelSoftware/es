note
	description: "Summary description for {SIMPLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SIMPLE
inherit
	INSTRUCTION

feature
		is_indenting: BOOLEAN
			-- Should sub-components be indented one more level?
			-- Here no.
		do
			Result := False
		end

end
