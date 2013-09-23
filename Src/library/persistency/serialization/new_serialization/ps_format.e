note
	description: "Objects that represent generic persistence formats."
	author: "Marco Piccioni, Adrian Schmidmeister"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	PS_FORMAT

feature -- Access

	version: INTEGER

	format_code: INTEGER -- format identifier

	l_int: INTERNAL

	rebuilt_objects: ARRAYED_LIST [ANY]

	visited_objects: ARRAYED_LIST [ANY]
			--	header: STRING
			--			
			-- Meta-information about the serialization format. At deserialization
			--			
			-- time it is processed before reading the actual stored data to see if
			--			
			-- a mismatch has to be triggered.		
			--	body: STRING
			--			
			-- Main serialization content.
			--	footer: STRING
			--			
			-- Information about the serialization and deserialization process after
			--			
			-- its end.
			--	annotator: REFACTORING_HELPER
			-- Thing to be fixed or implemented.

feature -- Status setting
			--	set_header (a_header: STRING)
			--			
			-- Set header for serialization.
			--		do
			--			header := a_header
			--		ensure
			--			header_set: header = a_header
			--		end
			--	set_body (a_body: attached STRING)
			--			
			-- Set body for serialization.
			--		do
			--			body := a_body
			--		ensure
			--			body_set: body = a_body
			--		end
			--	set_footer (a_footer: attached STRING)
			--			
			-- Set footer for serialization.
			--		do
			--			footer := a_footer
			--		ensure
			--			footer_set: footer = a_footer
			--		end

feature -- Basic features

	write_header (a_medium: IO_MEDIUM)
		require
			a_medium_is_set: a_medium /= Void
			a_medium_is_writable: a_medium.is_writable and a_medium.is_open_write
		deferred
		end

	correct_header (a_medium: IO_MEDIUM): BOOLEAN
		require
			a_medium_is_set: a_medium /= Void
			a_medium_readable: a_medium.is_readable and a_medium.is_open_read
		deferred
		end

	unmark_all
		require
			visited_objects: visited_objects /= Void
		do
			from
				visited_objects.start
			until
				visited_objects.off
			loop
				if l_int.is_marked (visited_objects.item) then
					l_int.unmark (visited_objects.item)
				end
				visited_objects.forth
			end
		end

	encode_object (a_field: detachable ANY; l_index: INTEGER; a_medium: IO_MEDIUM)
		require
			a_medium_is_set: a_medium /= Void
			a_medium_writable: a_medium.is_writable and a_medium.is_open_write
		deferred
		end

	extract_object (a_medium: IO_MEDIUM): ANY
		require
			a_medium_is_set: a_medium /= Void
			a_medium_readable: a_medium.is_readable and a_medium.is_open_read
		deferred
		end

end
