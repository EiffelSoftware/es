indexing
	description: "Objects that represent a graphical view of some filter result"
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TEST_ROUTINES_VIEW

inherit

	EV_VERTICAL_BOX
		redefine
			initialize,
			destroy
		end

create
	make, make_with_tags

feature {NONE} -- Initialization

	make (a_test_suite: CDD_TEST_SUITE) is
			-- Initialize `Current' without predefined filter tags.
		require
			a_test_suite_not_void: a_test_suite /= Void
		do
			make_with_tags (a_test_suite, "")
		ensure
			filter_tags_empty: filter_tags.is_empty
		end

	make_with_tags (a_test_suite: CDD_TEST_SUITE; a_tag_list: STRING) is
			-- Initialize `Current' with `a_tag_list' as filter tags.
		require
			a_test_suite_not_void: a_test_suite /= Void
			a_tag_list_not_void: a_tag_list /= Void
		do
			default_create
			create filter.make (a_test_suite)
			parse_tags (a_tag_list)
			predefined_tag_count := filter_tags.count
			filter.enable_observing
		ensure
			valid_filter_tags: filter_tags.for_all (agent a_tag_list.has_substring (?))
		end

	initialize is
			-- Initialize widgets
		do
			Precursor

			create text_field
			extend (text_field)

			create grid
			extend (grid)
		end

feature -- Access

	filter_tags: DS_LINEAR [STRING] is
			-- Tags used in the filter
		do
			Result := filter.filters
		ensure
			tags_of_filter: Result = filter.filters
			valid_count: Result.count >= predefined_tag_count
		end

feature {NONE} -- Implementation

	predefined_tag_count: INTEGER
			-- Number of hard coded tags in `filter_tags'

	filter: CDD_FILTERED_VIEW
			-- Filter for evaluating `test_field' input

	text_field: EV_TEXT_FIELD
			-- Text field for entering filter query

	grid: EV_GRID
			-- Grid for displaying `filter' results

	update_filter is
			-- Update filter tags of `filter' corresponding
			-- to `test_field' and rebuild filter.
		local
			l_tags_cursor: DS_LIST_CURSOR [STRING]
		do
			l_tags_cursor := filter.filters.new_cursor
			from
				l_tags_cursor.go_i_th (predefined_tag_count)
			until
				l_tags_cursor.after
			loop
				l_tags_cursor.remove
			end
			parse_tags (text_field.text)
		end

	parse_tags (a_tag_list: STRING) is
			-- Parse `a_tag_list' for filter tags an add them to `filter_tags'.
		require
			a_tag_list_not_void: a_tag_list /= Void
		local
			l_tags_cursor: DS_LIST_CURSOR [STRING]
			l_start, l_end: INTEGER
		do
			l_tags_cursor := filter.filters.new_cursor
			from
				l_tags_cursor.go_after
				l_start := 1
				l_end := 0
			until
				l_start > a_tag_list.count
			loop
				if l_end > l_start then
					if a_tag_list.item (l_end).is_space then
						l_tags_cursor.put_left (a_tag_list.substring (l_start, l_end - 1))
						l_tags_cursor.go_after
						l_start := l_end
					else
						l_end := l_end + 1
					end
				elseif a_tag_list.item (l_start).is_space then
					l_start := l_start + 1
				else
					l_end := l_start + 1
				end
			end
		end


feature {NONE} -- Destruction

	destroy is
			-- Tell `filter' to no longer observer test suite.
		do
			Precursor
			filter.disable_observing
		end

invariant


	filter_not_void: filter /= Void
	predefined_tag_count_not_negative: predefined_tag_count >= 0

	text_field_not_void: text_field /= Void
	current_is_parent_of_text_field: text_field.parent = Current
	grid_not_void: grid /= Void
	current_is_parent_of_grid: grid.parent = Current

end
