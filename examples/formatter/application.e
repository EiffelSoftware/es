indexing
	description : "Formatter example to show agent verification"
	date        : "$Date$"
	revision    : "$Revision$"

class APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
		end

	apply_align_left (a_formatter: !FORMATTER; a_paragraph: !PARAGRAPH)
			-- Use `a_formatter' to left-align `a_paragraph'.
		require
			 not a_paragraph.is_left_aligned
		do
			a_paragraph.format (agent a_formatter.align_left)
		ensure
			a_paragraph.is_left_aligned
		end

	apply_align_right (a_formatter: !FORMATTER; a_paragraph: !PARAGRAPH)
			-- Use `a_formatter' to right-align `a_paragraph'.
		require
			a_paragraph.is_left_aligned
		do
			a_paragraph.format (agent a_formatter.align_right)
		ensure
			not a_paragraph.is_left_aligned
		end

end
