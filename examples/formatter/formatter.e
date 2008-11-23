indexing
	description: "Formatter to align paragraphs"
	date: "$Date$"
	revision: "$Revision$"

class FORMATTER

feature

	align_left (a_paragraph: PARAGRAPH)
			-- Left-align `a_paragraph'.
		require
			a_paragraph /= Void
			not_left_aligned: not a_paragraph.is_left_aligned
		do
			a_paragraph.align_left
		ensure
			is_left_aligned: a_paragraph.is_left_aligned
		end

	align_right (a_paragraph: PARAGRAPH)
			-- Right-align `a_paragraph'.
		require
			a_paragraph /= Void
			left_aligned: a_paragraph.is_left_aligned
		do
			a_paragraph.align_right
		ensure
			not_is_left_aligned: not a_paragraph.is_left_aligned
		end

end
