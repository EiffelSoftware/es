indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_INSTRUMENT_CONFIG_READER

feature --

	read_config (a_file_name: STRING) is
			-- Read instrument config from `a_file_name',
			-- and store result in `last_config'.
		require
			a_file_name_attached: a_file_name /= Void
		local
			l_file: PLAIN_TEXT_FILE
			l_config: like last_config
		do
			create l_file.make_open_read (a_file_name)
			create {LINKED_LIST [SAT_INSTRUMENT_CLASS_CONFIG]} last_config.make
			from
				l_config := last_config
				l_file.read_line
			until
				l_file.end_of_file
			loop
				if not l_file.last_string.is_empty then
					l_config.extend (class_config_from_line (l_file.last_string))
				end
				l_file.read_line
			end
			l_file.close
		end

	class_config_from_line (a_line: STRING): SAT_INSTRUMENT_CLASS_CONFIG is
			-- Class config from line `a_line'
		require
			a_line_attached: a_line /= Void
		local
			l_sections: LIST [STRING]
			l_class_name: STRING
			l_is_excluded: BOOLEAN
		do
			l_sections := a_line.split (';')
			l_class_name := l_sections.first
			if l_class_name.item (1) = '-' then
				l_is_excluded := True
				l_class_name := l_class_name.substring (2, l_class_name.count)
			end

			create Result.make (l_class_name)
			Result.set_is_excluded (l_is_excluded)
			if l_sections.count > 1 then
				Result.set_is_proper_ancestor_included (l_sections.i_th (2).is_equal ("proper_ancestor"))
			end
		end

feature -- Access

	last_config: LIST [SAT_INSTRUMENT_CLASS_CONFIG]
			-- List of config for classes.

end
