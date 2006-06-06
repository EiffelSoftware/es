indexing
	description: "Structure containing all information of a area which can be folded"
	author: "bherlig"
	date: "$06/06/06$"
	revision: "$0.1$"

class
	EB_FOLDING_AREA

create
	make_with_element

feature {NONE} -- Initialization

	make_with_element(e: like element) is
			-- Initialize `Current'.
		require
			element_exists: e /= Void
		do
			start_line := e.start_location.line
			end_line := e.end_location.line
			element := e
		ensure
			correctly_assigned: start_line = e.start_location.line
			correctly_assigned: end_line = e.end_location.line
			correctly_assigned: element = e
		end

feature -- Access
	start_line: INTEGER
		-- line on which the area starts
	end_line: INTEGER
		-- line on which the area ends
	element: FEATURE_AS
		-- associated element of 'current' in the text

feature -- Measurement

feature -- Status report

feature -- Status setting

feature -- Cursor movement

feature -- Element change

feature -- Removal

feature -- Resizing

feature -- Transformation

feature -- Conversion

feature -- Duplication

feature -- Miscellaneous

feature -- Basic operations

feature -- Obsolete

feature -- Inapplicable

feature {NONE} -- Implementation

feature -- Debug

	trace is
			-- console-output of current
		do
			io.put_string(element.feature_name.out)
			io.put_string("%N%Tstart: " + start_line.out)
			io.put_string("%N%Tend:   " + end_line.out + "%N")
		end


invariant
	invariant_clause: True -- Your invariant here

end
