note
	description: "PRINT_JSON_VISITOR Generates the JSON-String for a JSON_VALUE"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_COLLECTED_RUNTIME_DATA_PRINT_VISITOR

inherit
	PRINT_JSON_VISITOR
		redefine
			visit_json_array,
			visit_json_object
		end

create
	make

feature -- Visitor Pattern

	visit_json_array (a_json_array: JSON_ARRAY)
			-- Visit `a_json_array'.
		do
			Precursor (a_json_array)
			to_json.append_character ('%N')
		end

	visit_json_object (a_json_object: JSON_OBJECT)
			-- Visit `a_json_object'.
		do
			Precursor (a_json_object)
			to_json.append_character ('%N')
		end

end
