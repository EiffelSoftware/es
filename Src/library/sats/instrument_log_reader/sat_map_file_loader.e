indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SAT_MAP_FILE_LOADER

create
	load

feature{NONE} -- Initialization

	load (a_location: STRING) is
			-- Initialize Current loader to find map file in location `a_location'.
		require
			a_location_attached: a_location /= Void
		local
			l_matcher: RX_PCRE_REGULAR_EXPRESSION
			l_files: LIST [STRING]
		do
				-- Search for map file.
			create file_searcher.make (a_location)
			l_matcher := file_searcher.regular_expression_matcher (map_file_name, False, True)
			file_searcher.set_is_search_recursive (True)
			file_searcher.set_veto_file_function (agent is_file_matched (?, l_matcher))
			file_searcher.search

				
			l_files := file_searcher.last_found_files
			if l_files /= Void and then not l_files.is_empty then

			end
		end

feature{NONE} -- Implementation

	file_searcher: SAT_FILE_SEARCHER
			-- File searcher used to find map files.

	map_file_name: STRING is "sat_map.txt"
			-- Name of the map file

	is_file_matched (a_file_path: STRING; a_matcher: RX_PCRE_REGULAR_EXPRESSION): BOOLEAN is
			-- Does `a_file_path' match `a_matcher'?
		require
			a_file_path_attached: a_file_path /= Void
			a_matcher_attached: a_matcher /= Void
		do
			a_matcher.match (a_file_path)
			Result := a_matcher.has_matched
		end

invariant
	file_searcher_attached: file_searcher /= Void
end
