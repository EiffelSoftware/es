note
	description: "Objects that represent generic persistence formats."
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_FORMAT

feature -- Access

	header: STRING
			-- Meta-information about the serialization format. At deserialization
			-- time it is processed before reading the actual stored data to see if
			-- a mismatch has to be triggered.		

	body: STRING
			-- Main serialization content.

	footer: STRING
			-- Information about the serialization and deserialization process after
			-- its end.

	annotator: REFACTORING_HELPER
			-- Thing to be fixed or implemented.

feature -- Status setting

	set_header (a_header: STRING)
			-- Set header for serialization.
		do
			header := a_header
		ensure
			header_set: header = a_header
		end

	set_body (a_body: attached STRING)
			-- Set body for serialization.
		do
			body := a_body
		ensure
			body_set: body = a_body
		end

	set_footer (a_footer: attached STRING)
			-- Set footer for serialization.
		do
			footer := a_footer
		ensure
			footer_set: footer = a_footer
		end

feature -- Basic features

	compute_representation (an_obj: ANY)
			-- Compute `an_obj' representation in current format.
		deferred
		end

end
