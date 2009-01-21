indexing
	description : "calculate_total_fault application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_paths: LIST [STRING]
			l_class_analyzer: CLASS_ANALYZER
			l_stack: ARRAYED_STACK [STRING]
		do
			classes := class_paths ("e:\jasonw\sats\360\finished")
			from
				classes.start
			until
				classes.after
			loop
				create l_class_analyzer.make (classes.item)
				l_class_analyzer.analyze
				classes.forth
			end
		end

feature -- Access

	classes: LIST [STRING]
			-- Path of classes to analyze.

feature{NONE} -- Implementation

	class_paths (a_base_directory: STRING): LIST [STRING] is
			-- List of paths for classes starting from `a_base_directory'
		require
			a_base_directory_attached: a_base_directory /= Void
		local
			l_file_searcher: SAT_FILE_SEARCHER
		do
			create l_file_searcher.make_with_pattern ("*")
			l_file_searcher.set_is_dir_matched (True)
			l_file_searcher.locations.extend (a_base_directory)
			l_file_searcher.search
			Result := l_file_searcher.last_found_files.twin
		ensure
			result_attached: Result /= Void
		end



end
