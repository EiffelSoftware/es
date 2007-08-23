indexing
	description: "Origo commit workitem"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_COMMIT_WORKITEM

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
			type := Workitem_type_commit
			log := ""
			diff := ""
		end

feature -- Access

	type_name: STRING is
			-- redefine
		do
			Result := "Commit"
		end

	revision: INTEGER
			-- revision

	log: STRING
			-- commit log

	diff: STRING
			-- commit diff

feature -- Element change

	set_revision (a_revision: INTEGER)
			-- set `revision'
		do
			revision := a_revision
		ensure
			set: revision = a_revision
		end

	set_log (a_log: STRING)
			-- set `log'
		require
			a_log_not_void: a_log /= Void
		do
			log := a_log
		ensure
			set: log.is_equal (a_log)
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
			Result := "r: " + revision.out
			Result.append (" log: ")
			Result.append (log)
			Result.replace_substring_all ("%R", "")
			Result.replace_substring_all ("%N", ";")
		end

	label_text: STRING is
			-- redefine
		do
			Result := precursor + "%N%N"
			Result.append ("Revision: " + revision.out + "%N")
			Result.append ("Log:%N" + log + "%N")
			Result.append ("%NDiff:")
		end

	text_field_text: STRING is
			-- redefine
		do
			Result := diff.out
		end

invariant
	log_not_void: log /= Void
	diff_not_void: diff /= Void
end
