class 
	TEST

inherit
	IDENTIFIED

creation
	make

feature

	object: IDENTIFIED
	id: INTEGER
	
	make
		do
			create object
			id := object.object_id
			
			if attached id_object(id) as l_object and then l_object = object then
				{RT_CAPTURE_REPLAY}.print_string ("retrieved%N")
			end

			object.free_id

			if not attached id_object(id) then
				{RT_CAPTURE_REPLAY}.print_string ("freed%N")
			end
		end
end

