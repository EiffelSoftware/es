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
			out, out_short, type_name, make
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

feature -- Output		

	out_short: STRING is
			-- redefine
		do
			Result := "r: " + revision.out
			Result.append (" log: ")
			Result.append (log)
			Result.replace_substring_all ("%R", "")
			Result.replace_substring_all ("%N", ";")
		end

	out: STRING is
			-- redefine
		do
			Result := Precursor + "%N"
			Result.append ("Revision: " + revision.out + "%N")
			Result.append ("Log:%N")
			Result.append (log)
		end

invariant
	log_not_void: log /= Void
end
