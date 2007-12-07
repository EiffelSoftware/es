indexing
	description: "Parser for filter patterns; creates objects of type CDD_FILTER_PATTERN_PARSER."
	author: "fivaa"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_TAG_PARSER

feature -- Access

	last_tag: CDD_TAG
			-- Last tag parsed; Void if there was an error.

	parse (a_string: STRING) is
			-- Parse `a_string' as a filter pattern. If `a_string' is
			-- a correct tag, make the resulting pattern
			-- available via `last_tag', otherwise set `last_tag'
			-- to Void.
	local
		l: LIST [STRING]
	do
		last_tag := Void
		l := a_string.split ('.')
		create last_tag.make
		-- TODO: Prefix parsing
		last_tag.set_prefix_code (last_tag.other_prefix_code)
		from
			l.start
		until
			l.off
		loop
			if l.isfirst then
				l.item.prune_all_leading ('"')
			elseif l.islast then
				l.item.prune_all_trailing ('"')
			end
			-- TODO: Parse '+' and '-'
			last_tag.tokens.force_last (l.item)
			l.forth
		end
	end

end
