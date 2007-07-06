indexing
	description: "Origo release workitem"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_RELEASE_WORKITEM

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
			type := Workitem_type_release
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Release"
		end

feature -- Output		

	out_short: STRING is
			-- redefine
		do
			Result := "Release Workitem"
		end

	out: STRING is
			-- redefine
		do
			Result := Precursor
		end
end
