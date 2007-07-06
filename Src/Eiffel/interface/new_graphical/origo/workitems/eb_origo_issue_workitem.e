indexing
	description: "Origo issue workitem"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_ISSUE_WORKITEM

inherit
	EB_ORIGO_WORKITEM
		redefine
			out, out_short, type_name
		end

create
	make

feature -- Initialisation

	make is
			-- create commit workitem
		do
			type := Workitem_type_issue
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Issue"
		end

feature -- Output		

	out_short: STRING is
			-- redefine
		do
			Result := "Issue Workitem"
		end

	out: STRING is
			-- redefine
		do
			Result := Precursor
		end
end
