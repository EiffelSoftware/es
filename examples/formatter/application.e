indexing
	description: "Formatter example to show agent verification"
	date: "$Date$"
	revision: "$Revision$"

class APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
		end

	apply_align_left (a_formatter: !FORMATTER; a_paragraph: !PARAGRAPH; a_paragraph2: !PARAGRAPH)
			-- Use `a_formatter' to left-align `a_paragraph'.
		require
			 not a_paragraph.is_left_aligned
			 not a_paragraph2.is_left_aligned
			 a_paragraph /= a_paragraph2
		local
			l_agent: PROCEDURE [FORMATTER, TUPLE [PARAGRAPH]]
		do
			l_agent := agent a_formatter.align_left
			a_paragraph.format (l_agent)
			check not a_paragraph2.is_left_aligned end
		ensure
			a_paragraph.is_left_aligned
		end

	apply_align_right (a_formatter: !FORMATTER; a_paragraph: !PARAGRAPH)
			-- Use `a_formatter' to right-align `a_paragraph'.
		require
			a_paragraph.is_left_aligned
		local
			l_agent: PROCEDURE [FORMATTER, TUPLE [PARAGRAPH]]
		do
			l_agent := agent a_formatter.align_right
			a_paragraph.format (l_agent)

		ensure
			not a_paragraph.is_left_aligned
		end

end
