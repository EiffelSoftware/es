indexing
	description: "Objects that display a test case within a grid structure"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_GRID_TEST_CASE_LINE

inherit
	CDD_GRID_LINE [CDD_TEST_CASE]
		rename
			row_data as test_case
		redefine
			make_with_row,
			unattach
		end

	EV_STOCK_COLORS
		export
			{NONE}
		end

create
	make_with_row

feature {NONE} -- Initialization

	make_with_row (a_row: like grid_row; a_test_case: like test_case) is
			-- Set `grid_row' to `a_row' and `test_case' to `a_test_case'.
			-- Define first item of `grid_row' for displaying `test_case'.
		local
			l_stone: CLASSI_STONE
			l_cname, l_num: STRING
			l_tool: CDD_TOOL
		do
			Precursor (a_row, a_test_case)
			internal_update_agent := agent update_status
			test_case.update_status_actions.extend (internal_update_agent)

			l_tool := grid.tool
			grid_row.select_actions.extend (agent l_tool.select_test_case (a_test_case))
			grid_row.deselect_actions.extend (agent l_tool.deselect_test_case)

			l_cname := test_case.tester_class.name
			l_num := l_cname.substring (l_cname.count - 1, l_cname.count)
			name_item.set_text ("Test case #" + l_num)
			create l_stone.make (test_case.tester_class)
			name_item.token_at_position (1).set_pebble (l_stone)
			update_status
		end

feature -- Element change

	add_test_case (a_tc: CDD_TEST_CASE) is
			-- Add `a_tc' to grid.
		do
			-- NOTE: nothing to do since test case is displayed by `Current'
		end

	remove_test_case (a_tc: CDD_TEST_CASE) is
			-- Remove `a_tc' from grid.
		do
			-- NOTE: nothing to do since test case is displayed by `Current'
		end

	unattach is
			-- Set `grid_row' to Void and prune agents from test case.
		do
			test_case.update_status_actions.prune (internal_update_agent)
			Precursor
		end

feature {NONE} -- Implementation

	internal_update_agent: PROCEDURE [ANY, TUPLE]
			-- Procedure instancs used for extending and removing.

	status_item: EV_GRID_LABEL_ITEM is
			-- Item of `grid_row' showing the test case status
		do
			Result ?= grid_row.item (2)
			if Result = Void then
				create Result
				grid_row.set_item (2, Result)
			end
		end

	update_status is
			-- Update status item of `grid_row'.
		local
			l_status, l_tooltip: STRING
		do
			create l_status.make_empty
			create l_tooltip.make_empty
			if not test_case.is_tested then
				status_item.set_foreground_color (black)
				l_status.append ("?")
			else
				if test_case.passes then
					status_item.set_foreground_color (green)
					l_status.append ("PASS")
				elseif test_case.status = test_case.invalid_code then
					status_item.set_foreground_color (gray)
					l_status.append ("INV")
				else
					status_item.set_foreground_color (red)
					l_status.append ("FAIL")
					if test_case.last_exception_tag /= Void then
						l_tooltip.append ("Exception: " + test_case.last_exception_tag)
					end
				end
			end
			if not test_case.is_verified then
				l_status.append_character ('*')
			end
			status_item.set_text (l_status)
			name_item.set_tooltip (l_tooltip)
			status_item.set_tooltip (l_tooltip)
		end

invariant
	internal_update_agent_not_void: internal_update_agent /= Void
	valid_status_item: status_item /= Void and then grid_row.item (2) = status_item

end -- Class CDD_GRID_TEST_CASE_LINE
