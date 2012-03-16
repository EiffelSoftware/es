note
	description: "Summary description for {PS_TEST_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TEST_DATA

create
	make


feature
	people:LIST[PERSON]

	flat_class: FLAT_CLASS_1

	data_structures_1: DATA_STRUCTURES_CLASS_1



feature {NONE} -- Initialization


	make
			-- Initialization for `Current'.
		do
			fill_people
			create flat_class.make
			create data_structures_1.make
		end





	fill_people
			-- Populate an in-memory database.
		local
			pe:PERSON
		do
			create {ARRAYED_LIST [PERSON] } people.make (4)
			create pe.make ("Albo", "Bitossi", 3)
			people.extend (pe)
			create pe.make ("Berno", "Citrini", 5)
			people.extend (pe)
			create pe.make ("Crispo", "Danesi", 3)
			people.extend (pe)
			create pe.make ("Dumbo", "Ermini", 2)
			people.extend (pe)
		end

end
