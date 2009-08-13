note
	description: "[
		Represents an error response page
	]"
	legal: "See notice at end of class."
	status: "Prototyping phase"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	X_ERROR_RESPONSE

inherit
	X_RESPONSE

feature -- Access

	title: STRING
			-- The type (title) of the Response
		do
			Result := "Error Report"
		end

	deco_color: STRING
			-- The color of the decoration
		do
			Result := "#F15922"
		end
end
