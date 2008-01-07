indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GRID_OUTCOME_ITEM

inherit

	EV_GRID_DRAWABLE_ITEM
		redefine
			initialize
		end

create
	make, make_with_outcome

feature {NONE} -- Initialization

	make is
			-- Initialize `Current' without outcome.
		do
			default_create
		ensure
			no_outcome: outcome = Void
		end

	make_with_outcome (an_outcome: like outcome) is
			-- Initialize `Current' with `an_outcome'.
		require
			an_outcome_not_void: an_outcome /= Void
		do
			default_create
			outcome := an_outcome
		ensure
			outcome_set: outcome = an_outcome
		end

	initialize is
			--
		do
			Precursor
			expose_actions.extend (agent perform_redraw)
		end

feature -- Access

	outcome: CDD_TEST_EXECUTION_RESPONSE

feature {NONE} -- Implementation

	perform_redraw (a_drawable: EV_DRAWABLE) is
			--
		require
			a_drawable /= Void
		do
			if is_selected then
				if parent.has_focus then
					a_drawable.set_foreground_color (parent.focused_selection_color)
				else
					a_drawable.set_foreground_color (parent.non_focused_selection_color)
				end
			else
				a_drawable.set_foreground_color (parent.background_color)
			end
			a_drawable.fill_rectangle (0, 0, width, height)
			if outcome = Void then
				a_drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (0.7, 0.7, 0.7))
				a_drawable.draw_text_top_left (0, 2, "not testet yet")
			elseif outcome.is_fail then
				a_drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (0.9, 0, 0.1))
				a_drawable.draw_text_top_left (0, 2, "FAIL")
			elseif outcome.is_pass then
				a_drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (0, 0.9, 0.1))
				a_drawable.draw_text_top_left (0, 2, "PASS")
			else
				a_drawable.set_foreground_color (create {EV_COLOR}.make_with_rgb (0.5, 0.5, 0))
				a_drawable.draw_text_top_left (0, 2, "UNRESOLVED")
			end
		end

end
