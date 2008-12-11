indexing
	description: "Paragraph with alignment"
	date: "$Date$"
	revision: "$Revision$"

class PARAGRAPH

feature

	is_left_aligned: BOOLEAN
			-- Is the paragraph left aligned?

	align_left
			-- Align the paragraph left.
		do
			is_left_aligned := True
		ensure
			is_left_aligned
		end

	align_right
			-- Align the paragraph right.
		do
			is_left_aligned := False
		ensure
			not is_left_aligned
		end

	format (proc: PROCEDURE [FORMATTER, TUPLE [PARAGRAPH]])
			-- Format the paragraph with the given formatter.
		require
			proc /= Void
			proc.precondition ([Current])
		do
			proc.call ([Current])
		ensure
			proc.postcondition ([Current])
		end

end
