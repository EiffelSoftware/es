note
	description: "Facilities for direct building SVG content."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	keywords: "svg, vector, root, window, visual, top"
	date: "$Date$"
	revision: "$Revision$"
	warning: "This is work in progress, for now mostly implemented to export EiffelStudio diagram tool to svg file"

class
	ES_DRAWABLE_TO_SVG

inherit
	EV_DRAWABLE
		redefine
			implementation
		end

create
	make

feature {NONE} -- Initialization

	make (a_output: FILE; w, h: INTEGER)
		do
			output := a_output
			default_create
			internal_width := w
			internal_height := h
		end

feature -- Access

	output: FILE

	generate_header
		local
			o: like output
		do
			o := output
			o.put_string ("<?xml version=%"1.0%" encoding=%"UTF-8%"?>%N")
			o.put_string ("<svg")
			o.put_string (" width=%"")
			o.put_string (width.out)
			o.put_string ("%"")
			o.put_string (" height=%"")
			o.put_string (height.out)
			o.put_string ("%"")
			o.put_string (" viewbox=%"0 0 ")
			o.put_string (width.out)
			o.put_character (' ')
			o.put_string (height.out)
			o.put_string ("%"")
			o.put_string ("%N%T version=%"1.1%"%N")
			o.put_string ("%Txmlns=%"http://www.w3.org/2000/svg%"%N")
			o.put_string ("%Txmlns:xlink=%"http://www.w3.org/1999/xlink%"%N")
			o.put_string (">%N")
		end

	generate_footer
		do
			output.put_string ("</svg>%N")
		end

feature -- Measurement

	width: INTEGER
			-- Horizontal size in pixels.
		do
			Result := implementation.width
		ensure then
			bridge_ok: Result = implementation.width
			positive: Result > 0
		end

	height: INTEGER
			-- Vertical size in pixels.
		do
			Result := implementation.height
		ensure then
			bridge_ok: Result = implementation.height
			positive: Result > 0
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	internal_width: INTEGER
	internal_height: INTEGER

	implementation: ES_DRAWABLE_TO_SVG_I
			-- Responsible for interaction with native graphics toolkit.

feature {NONE} -- Implementation

	create_interface_objects
			-- <Precursor>
		do

		end

	create_implementation
			-- See `{EV_ANY}.create_implementation'.
		do
			create {ES_DRAWABLE_TO_SVG_I} implementation.make
		end

note
	copyright:	"Copyright (c) 1984-2025, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
