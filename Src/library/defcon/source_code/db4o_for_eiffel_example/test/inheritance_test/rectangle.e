indexing
	description: "Two-dimensional rectangles"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"

class
	RECTANGLE

inherit
	PARALLELOGRAM
		rename
			height1 as width,
			height2 as height
		end

create
	make


end
