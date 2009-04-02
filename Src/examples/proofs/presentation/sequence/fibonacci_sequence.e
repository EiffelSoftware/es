indexing
	description: "Summary description for {FIBONACCI_SEQUENCE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	FIBONACCI_SEQUENCE

inherit
	INTEGER_SEQUENCE

create
	make

feature

	make
		do
			last_item := 0
			item := 1
		ensure
			last_item = 0
			item = 1
		end

	last_item: INTEGER

	forth
		local
			l_temp: INTEGER
		do
			l_temp := item
			item := item + last_item
			last_item := l_temp
		ensure then
			item = old item + old last_item
			last_item = old item
		end

end
