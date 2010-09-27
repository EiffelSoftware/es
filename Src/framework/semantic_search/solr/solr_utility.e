note
	description: "Utilities for solr"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SOLR_UTILITY

inherit
	SEM_CONSTANTS

	SEM_UTILITY

feature -- Access

	xml_element_for_field (a_field: SEM_DOCUMENT_FIELD): STRING
			-- String representing XML element for `a_field'
		do
			create Result.make (a_field.value.count + a_field.name.count + 64)
			Result.append (once "<field name=%"")
			Result.append (escaped_field_string (a_field.name))
			Result.append (once "%" boost=%"")
			Result.append (a_field.boost.out)
			Result.append (once "%">")
			Result.append (a_field.value)
			Result.append (once "</field>")
		end

	escaped_field_string (a_name: STRING): STRING
			-- Escaped `a_name'
		do
			create Result.make (a_name.count + 10)
			Result.append (a_name)
			Result.replace_substring_all (once " ", once "%%20")
			Result.replace_substring_all (once "[", once "%%5B")
			Result.replace_substring_all (once "]", once "%%5D")
			Result.replace_substring_all (once "{", once "%%7B")
			Result.replace_substring_all (once "}", once "%%7D")
			Result.replace_substring_all (once "<", once "%%3C")
			Result.replace_substring_all (once ">", once "%%3E")
			Result.replace_substring_all (once "/", once "%%2F")
			Result.replace_substring_all (once "+", once "%%2B")
			Result.replace_substring_all (once "-", once "%%2D")
			Result.replace_substring_all (once "~", once "%%7E")
		end

end
