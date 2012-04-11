indexing
	description: "Objects that return consecutive integers, that can be used as id"
	author: "Marco Piccioni, Peizhu Li"
	date: "$Date$"
	revision: "$0.6$"

class
	ID_GENERATOR

feature -- Access

	generate_next_id
			--generates the next id in the sequence
		do
			id:=id+1
		ensure
			id_increased: id = old id+1
		end

	id:NATURAL_64

	invariant id_is_consistent:id >=0
end
