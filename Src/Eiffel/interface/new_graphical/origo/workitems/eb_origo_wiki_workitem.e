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
			out, type_name, make, label_text, text_field_text
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
			diff := ""
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Wiki"
		end

	title: STRING
			-- title of wiki page

	revision: INTEGER
			-- new revision

	old_revision: INTEGER
			-- old revision

	diff: STRING
			-- diff

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

	set_revision (a_revision: like revision) is
			-- set `revision'
		require
			positive: a_revision >= 0
		do
			revision := a_revision
		ensure
			set: revision = a_revision
		end

	set_old_revision (a_old_revision: like old_revision) is
			-- set `old_revision'
		require
			positive: a_old_revision >= 0
		do
			old_revision := a_old_revision
		ensure
			set: old_revision = a_old_revision
		end

	set_diff (a_diff: like diff) is
			-- set `diff'
		require
			not_void: a_diff /= Void
		do
			diff := a_diff.out
		ensure
			set:  diff.is_equal (a_diff)
		end

feature -- Output		

	out: STRING is
			-- redefine
		do
			Result := "Wiki page: " + title
		end

	label_text: STRING is
			-- redefine
		do
			Result := precursor + "%N%N"
			Result.append ("Title: " + title + "%N")
			Result.append ("Revisions: " + old_revision.out + " -> " + revision.out + "%N")
			Result.append ("%NDiff:")
		end

	text_field_text: STRING is
			-- redefine
		do
			Result := diff.out
		end

invariant
	title_not_void: title /= Void
	diff_not_void: diff /= Void
end
