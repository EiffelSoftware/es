indexing
	description: "Origo blog workitem"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_BLOG_WORKITEM

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
			type := Workitem_type_blog
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Blog"
		end

feature -- Output		

	out_short: STRING is
			-- redefine
		do
			Result := "Blog Workitem"
		end

	out: STRING is
			-- redefine
		do
			Result := Precursor
		end
end
