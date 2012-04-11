indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BLOCK_ELEMENT
		inherit ANY
			redefine
				out
			end

create
	make

feature -- Access
	make is
			--
		do
			create body.make
		end

feature -- Status report
	out:STRING is
			-- get the output of this element
		do
			Result := body.out
		end

feature -- Element change
	put_h1(s:STRING) is
			-- add a title <h1>
		do
			body.put_basic ("%N")
			body.put_header1(s)
		end

	put_h2(s:STRING) is
			-- add a title <h2>
		do
			body.put_basic ("%N")
			body.put_header2(s)
		end

	put_h3(s:STRING) is
			-- add a title <h3>
		do
			body.put_basic ("%N")
			body.put_header3(s)
		end

	put_h4(s:STRING) is
			-- add a title <h4>
		do
			body.put_basic ("%N")
			body.put_header3(s)
		end

	put_h5(s:STRING) is
			-- add a title <h5>
		do
			body.put_basic ("%N")
			body.put_header3(s)
		end

	put_h6(s:STRING) is
			-- add a title <h6>
		do
			body.put_basic ("%N")
			body.put_header3(s)
		end

	put_paragraph(s:STRING) is
			-- add a paragraph <p>
		do
			body.put_basic ("%N")
			body.put_paragraph_start
			body.put_basic(s)
			body.put_paragraph_end
		end

	put_pre(s:STRING) is
			-- add preformatted text <pre>
		do
			body.put_basic ("%N")
			body.put_preformatted(s)
		end

	put_line is
			-- add a horizontal line <hr>
		do
			body.put_horizontal_rule
		end


	put_html(s:STRING) is
			-- add custom html
		do
			body.put_basic (s)
		end

	put_list(l:LIST[INTEGER]) is
			--
		do
			body.put_unordered_list_start

			from l.start
			until
				l.after
			loop
				body.put_list_item_start
				body.put_basic (l.item.out)
				body.put_list_item_end
				l.forth
			end

			body.put_unordered_list_end
		end

feature -- Removal
	wipe_out is
			-- remove all the content
		do
			body.wipe_out
		end


feature {NONE} -- Implementation
	body : HTML_TEXT

invariant
	invariant_clause: True -- Your invariant here

end
