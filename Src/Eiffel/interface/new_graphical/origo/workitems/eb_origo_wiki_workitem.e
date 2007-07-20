indexing
	description: "Origo wiki workitem"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_WIKI_WORKITEM

inherit
	EB_ORIGO_WORKITEM
		redefine
			out, out_short, type_name, make
		end

create
	make

feature -- Initialisation

	make is
			-- create commit workitem
		do
			precursor
			type := Workitem_type_wiki
			title := ""
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Wiki"
		end

	title: STRING
			-- title of wiki page

feature -- Element Change

	set_title (a_title: like title) is
			-- set `title'
		require
			not_void: a_title /= Void
		do
			title := a_title.out
		ensure
			set: title.is_equal (a_title)
		end

feature -- Output		

	out_short: STRING is
			-- redefine
		do
			Result := "Wiki page: " + title
		end

	out: STRING is
			-- redefine
		do
			Result := Precursor
		end

invariant
	title_not_void: title /= Void
end
