indexing
	description: "Objects that represent a tool widget for displaying test routines and outcomes"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TOOL

inherit

	EB_TOOL
		rename
			title_for_pre as title
		end

create
	make

feature {NONE} -- Initialization

	build_interface is
			-- Initialize all widgets for `Current'.
		do
			widget := create {EV_HORIZONTAL_BOX}
		end

feature -- Access

	title: STRING is "Testing"
			-- Title describing `Current'

	widget: EV_WIDGET
			-- Main widget for visualizing `Current'

end
