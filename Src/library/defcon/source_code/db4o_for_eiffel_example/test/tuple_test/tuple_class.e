indexing
	description: "Objects that contain different kinds of tuples"
	author: "Ruihua Jin"
	date: "$Date$"
	revision: "$Revision$"


class
	TUPLE_CLASS

create
	make

feature
	make is
			-- Initialization
		local
			glint: GLIST[INTEGER]
			gsubint: GSUBLIST[INTEGER]
		do
			value_tuple := [True, -123, 'a']
			value_tuple2 := [False, 345]
			expanded_tuple := [create {POINT}.make_with_x_y (23, 68)]
			object_tuple := [create {RECTANGLE}.make (10, 20), "an eiffel string"]
			tuple_tuple := [[674, create {POINT}.make_with_x_y (48, 47)], "a string in tuple_tuple"]
			create glint
			glint.put (234)
			generic_tuple1 := [glint, create {POINT}.make_with_x_y (1,2)]
			create gsubint
			gsubint.put (345)
			generic_tuple2 := [gsubint, create {POINT}.make_with_x_y (3,4)]
			create glist_tuple1
			glist_tuple1.put ([456])
			create glist_tuple2
			glist_tuple2.put ([567, create {POINT}.make_with_x_y (5, 6)])
		end

feature
	value_tuple: TUPLE[BOOLEAN, INTEGER, CHARACTER]
	value_tuple2: TUPLE[BOOLEAN, INTEGER]
	expanded_tuple: TUPLE[POINT]
	object_tuple: TUPLE[RECTANGLE, STRING]
	tuple_tuple: TUPLE[TUPLE[INTEGER, POINT], STRING]
	generic_tuple1: TUPLE[GLIST[INTEGER], POINT]
	generic_tuple2: TUPLE[GSUBLIST[INTEGER], POINT]
	glist_tuple1: GLIST[TUPLE[INTEGER]]
	glist_tuple2: GSUBLIST[TUPLE[INTEGER, POINT]]
end
