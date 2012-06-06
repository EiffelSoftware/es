note
	description: "Summary description for {PS_TEST_DATA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PS_TEST_DATA
inherit
	PS_EIFFELSTORE_EXPORT


create
	make


feature
	people:LIST[PERSON]

	flat_class: FLAT_CLASS_1

	data_structures_1: DATA_STRUCTURES_CLASS_1

	reference_1: REFERENCE_CLASS_1
		-- 1 references 2, 2 references 3, 3 references 1 and 2

	tuple_query: detachable PS_TUPLE_QUERY[ANY]


feature {NONE} -- Initialization


	make
			-- Initialization for `Current'.
		local
			ref2, ref3: REFERENCE_CLASS_1
		do
			fill_people
			create flat_class.make
			create data_structures_1.make

			create reference_1.make (1)
			create ref2.make (2)
			create ref3.make (3)

			reference_1.add_ref (ref2)
			ref2.add_ref (ref3)
			ref3.add_ref (reference_1)

			reference_1.references.extend (ref2)
			ref2.references.extend (ref3)
			ref3.references.extend (reference_1)
			ref3.references.extend (ref2)

--			reference_1.ref_arrays.grow (1)
--			reference_1.ref_arrays[1]:= ref2

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
