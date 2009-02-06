indexing
	description: "Summary description for {PERSON}."
	date: "$Date$"
	revision: "$Revision$"

class
	PERSON

create
	make

feature {NONE} -- Initialization

	make
		do
			spouse := Void
		ensure
			spouse = Void
		end

feature -- Access

	spouse: PERSON

feature -- Basic operations

	marry (a_other: !PERSON)
		require
			a_other /= Current
			a_other.spouse = Void
			spouse = Void
		do
			spouse := a_other
			a_other.set_spouse (Current)
		ensure
			spouse = a_other
			a_other.spouse = Current
		end

	divorce
		require
			spouse /= Void
		do
			spouse.set_spouse (Void)
			spouse := Void
		ensure
			spouse = Void
			(old spouse).spouse = Void
		end

feature {PERSON} -- Implementation

	set_spouse (a_person: PERSON)
		indexing
			proof: False	-- Breaks invariant
		do
			spouse := a_person
		ensure
			spouse = a_person
		end

invariant
	spouse /= Current
	spouse /= Void implies spouse.spouse = Current

end
