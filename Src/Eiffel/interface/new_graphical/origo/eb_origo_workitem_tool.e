indexing
	description: "Origo Workitem Tool"
	author: "Rafael Bischof <rafael@xanis.ch>"
	date: "$Date$"
	revision: "$Revision$"

class
	EB_ORIGO_WORKITEM_TOOL

inherit
	EB_TOOL

create
	make

feature{NONE} -- Initialisation

	build_interface is
			-- redefine
		do
			create widget
			widget.expose_actions.extend (agent on_expose)
		end


feature -- Access

	title: STRING_GENERAL is
			-- title displayed
		do
			Result := "Origo workitem display"
		ensure then
			Result_not_void: Result /= Void
		end

feature {NONE} -- Implementation

	on_expose (a_x: INTEGER_32; a_y: INTEGER_32; a_width: INTEGER_32; a_height: INTEGER_32) is
			-- Handle `widget' expose actions
		do
			widget.clear
			widget.draw_text_top_left (0, 0, "Moo");
		end


	title_for_pre: STRING is "Origo workitem display"
			-- Redefine

	widget: EV_DRAWING_AREA
			-- Key Widget

end
