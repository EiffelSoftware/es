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
			out, out_short, type_name, make
		end

create
	make

feature -- Initialisation

	make is
			-- create commit workitem
		do
			precursor
			type := Workitem_type_blog
			title := ""
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Blog"
		end

	title: STRING
			-- title of blog entry

feature -- Element Change

	set_title (a_title: like title) is
			-- set `title'
		require
			not_void: a_title /= Void
		do
			title := a_title.out
		ensure
			set:  title.is_equal (a_title)
		end

feature -- Output

	out_short: STRING is
			-- redefine
		do
			Result := "New blog entry: " + title
		end

	out: STRING is
			-- redefine
		do
			Result := Precursor
		end

invariant
	title_not_void: title /= Void
end
