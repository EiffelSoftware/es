indexing
	description: "Sequential composition of two relations into a third"
	author: "Bernd Schoeller"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_COMPOSITION [X,Y,Z]

inherit
	MML_USER

feature -- Composition

	composed (a: MML_RELATION[X,Y]; b: MML_RELATION[Y,Z]): MML_RELATION[X,Z] is
			-- Compose relations `a' and `b'
		local
			rel_seq_a: MML_SEQUENCE[MML_PAIR[X,Y]]
			rel_seq_b: MML_SEQUENCE[MML_PAIR[Y,Z]]
			i: INTEGER
			j: INTEGER
		do
			create {MML_DEFAULT_RELATION[X,Z]}Result.make_empty
			from
				rel_seq_a := a.randomly_ordered
				i := 1
			until
				i > rel_seq_a.count
			loop
				from
					rel_seq_b := b.randomly_ordered
					j := 1
				until
					j > rel_seq_b.count
				loop
					if equal_value(rel_seq_a.item(i).second,rel_seq_b.item(j).first) then
						Result := Result.extended
							(create {MML_DEFAULT_PAIR[X,Z]}.make_from (rel_seq_a.item(i).first,rel_seq_b.item(j).second))
					end
					j := j + 1
				end
				i := i + 1
			end
		end

end
