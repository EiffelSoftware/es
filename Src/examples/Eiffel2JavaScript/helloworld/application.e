note
	description : "Hello World example"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

inherit
	JS_OBJECT

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_div: JS_HTML_DIV_ELEMENT
			l_foo: JS_NODE
		do
			--| Add your code here
			-- To see the console output:
			-- * in Chrome: open Developer Tools (Ctrl+Shift+I)
			-- * in Firefox: open Web Console (Ctrl+Shit+K)
			-- * in IE: open Developer Tools (F12)
			console.info ("Hello Eiffel World!")

			-- Add a div with some text in it
			create l_div.make
			l_foo := l_div.append_child (window.document.create_text_node ("Hello World!"))
			l_foo := body.append_child (l_div)
		end

end
