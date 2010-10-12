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

	xml_element_for_field (a_field: IR_FIELD): STRING
			-- String representing XML element for `a_field'
		do
			create Result.make (a_field.value.text.count + a_field.name.count + 64)
			Result.append (once "<field name=%"")
			Result.append (encoded_field_string (a_field.name))
			Result.append (once "%" boost=%"")
			Result.append (a_field.boost.out)
			Result.append (once "%">")
			Result.append (a_field.value.text)
			Result.append (once "</field>")
		end

	encoded_field_string (a_name: STRING): STRING
			-- Encoded `a_name'
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
			Result.replace_substring_all (once "(", once "%%28")
			Result.replace_substring_all (once ")", once "%%29")
			Result.replace_substring_all (once "%"", once "%%22")
			Result.replace_substring_all (once ",", once "%%2C")
			Result.replace_substring_all (once "!", once "%%21")
		end

	decoded_field_string (a_name: STRING): STRING
			-- Decoded `a_name'
		do
			create Result.make (a_name.count + 10)
			Result.append (a_name)
			Result.replace_substring_all (once "%%20", once " ")
			Result.replace_substring_all (once "%%5B", once "[")
			Result.replace_substring_all (once "%%5D", once "]")
			Result.replace_substring_all (once "%%7B", once "{")
			Result.replace_substring_all (once "%%7D", once "}")
			Result.replace_substring_all (once "%%3C", once "<")
			Result.replace_substring_all (once "%%3E", once ">")
			Result.replace_substring_all (once "%%2F", once "/")
			Result.replace_substring_all (once "%%2B", once "+")
			Result.replace_substring_all (once "%%2D", once "-")
			Result.replace_substring_all (once "%%7E", once "~")
			Result.replace_substring_all (once "%%28", once "(")
			Result.replace_substring_all (once "%%29", once ")")
			Result.replace_substring_all (once "%%22", once "%"")
			Result.replace_substring_all (once "%%2C", once ",")
			Result.replace_substring_all (once "%%21", once "!")
		end

end
