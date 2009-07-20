indexing
	description: "Summary description for {JS_LOGIC_AND_ABSTRACTION_LOCATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	JS_LOGIC_AND_ABSTRACTION_LOCATOR

inherit
	JS_HELPER_ROUTINES
	export {NONE} all end

	DOCUMENTATION_EXPORT

	KL_SHARED_FILE_SYSTEM
	export {NONE} all end

create
	default_create

feature

	process_class (a_class: !CLASS_C)
		local
			l_file_name: STRING
		do
			logic_file_name := file_name (a_class, "JS_LOGIC")
			abstraction_file_name := file_name (a_class, "JS_ABSTRACTION")
		end

	logic_file_name: STRING

	abstraction_file_name: STRING

feature {NONE} -- Implementation

	file_name (a_class: !CLASS_C; a_tag_name: STRING): STRING
		local
			l_file_name_from_top_clause: STRING
			l_file_name_from_bottom_clause: STRING
		do
			l_file_name_from_top_clause := file_name_from_indexing_clause (a_class, a_tag_name, a_class.ast.top_indexes)
			l_file_name_from_bottom_clause := file_name_from_indexing_clause (a_class, a_tag_name, a_class.ast.bottom_indexes)
			if l_file_name_from_top_clause /= Void and l_file_name_from_bottom_clause /= Void then
				error (a_tag_name + " defined more than once in " + a_class.name)
			elseif l_file_name_from_top_clause /= Void then
				Result := l_file_name_from_top_clause
			elseif l_file_name_from_bottom_clause /= Void then
				Result := l_file_name_from_bottom_clause
			else
				error (a_tag_name + " should be defined in " + a_class.name)
			end
		end

	file_name_from_indexing_clause (a_class: !CLASS_C; a_tag_name: STRING; a_indexing_clause: INDEXING_CLAUSE_AS): STRING
		local
			l_content: STRING
		do
			Result := Void

			if a_indexing_clause /= Void then
				from
					a_indexing_clause.start
				until
					a_indexing_clause.off
				loop
					if
						{l_index_as: !INDEX_AS} a_indexing_clause.item and then
						equal (l_index_as.tag.name.as_upper, a_tag_name)
					then
						if Result = Void then
							-- No definition has been encountered yet.
							l_content := l_index_as.content_as_string
							Result := get_full_file_name (a_class, l_content.substring (2, l_content.count - 1))
						else
							error (a_tag_name + " defined more than once in " + a_class.name)
						end
					end
					a_indexing_clause.forth
				end
			end
		end

	get_full_file_name (a_class: !CLASS_C; a_file_name: STRING): STRING
		local
			directory: STRING
		do
			directory := file_system.dirname (a_class.file_name)
			Result := file_system.pathname (directory, a_file_name)
			if not file_system.file_exists (Result) then
				error (Result + " does not exist")
			end
		end

end
