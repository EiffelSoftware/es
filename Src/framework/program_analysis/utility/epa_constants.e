note
	description: "Summary description for {AFX_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_CONSTANTS

inherit
	ITP_SHARED_CONSTANTS

feature -- Access

	equation_separator: STRING
			-- Separator between the expression and the value in an equation
		do
			Result := query_value_separator
		end

	nonsensical: STRING
			-- Nonsensical value
		do
			Result := nonsensical_value
		end

end
