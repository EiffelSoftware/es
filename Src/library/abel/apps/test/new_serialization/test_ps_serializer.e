note
	description: "Summary description for {TEST_PS_SERIALIZER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_PS_SERIALIZER

create
	make

feature -- Access

	serializer: PS_BINARY_SERIALIZER

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		local
			file: RAW_FILE
			obj: ARRAYED_LIST [TEST_OBJECT]
			i, n: INTEGER
		do
			create file.make_open_append ("file_13.bin")
			create serializer.make (file)
			n := 100
			create obj.make (n)
			from
				i := 0
			until
				i = n
			loop
				obj.extend (create {TEST_OBJECT}.make)
				i := i + 1
			end
			serializer.store (obj)
			file.close
			create file.make_open_read ("file_13.bin")
			serializer.make (file)
			serializer.retrieve
			file.close
			--print (obj.out)
			--print ("%N")
			--print (serializer.retrieved_items.first.out)
		end

end
