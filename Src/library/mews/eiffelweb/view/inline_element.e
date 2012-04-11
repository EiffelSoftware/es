indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	INLINE_ELEMENT
inherit
	ANY
		undefine
			out
		end

feature -- body
	link_to(link:STRING; text:STRING):STRING is
			-- return a link
		do
			Result := "<a href=%""+link+"%">"+text+"</a>"
		end

	emphasize(s:STRING):STRING is
			-- surround a string with <em>
		do
			Result := "<em>"+s+"</em>"
		end

	image(src:STRING; alt:STRING):STRING is
			-- return a <img> tag with src
		do
			Result := "<img src=%""+src+"%" alt=%""+alt+"%" />"
		end

	strong(s:STRING):STRING is
			-- surround a string with <strong>
		do
			Result := "<strong>"+s+"</strong>"
		end



end
