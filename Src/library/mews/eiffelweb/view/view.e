indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	VIEW

feature
	make is
			--
		do
			create content_footer.make
			create content_header.make
			create content_left.make
			create content_middle.make
			create content_right.make
		end

	put_title(s:STRING) is
			--
		do
			title := s
		end

feature -- Page elements
	content_header : BLOCK_ELEMENT
	content_left: BLOCK_ELEMENT
	content_middle:BLOCK_ELEMENT
	content_right:BLOCK_ELEMENT
	content_footer:BLOCK_ELEMENT

feature {NONE} -- More Page elements
	title : STRING



end
