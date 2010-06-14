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
			-- Initialize person.
		do
			spouse := Void
		ensure
			spouse = Void
		end

feature -- Access

	spouse: PERSON
			-- Spouse of person

feature -- Basic operations

	marry (a_other: !PERSON)
			-- Marry person `a_other'.
		require
			other_not_current: a_other /= Current
			other_not_married: a_other.spouse = Void
			current_not_married: spouse = Void
		do
			spouse := a_other
			a_other.set_spouse (Current)
		ensure
			married_to_other: spouse = a_other
			married_to_current: a_other.spouse = Current
		end

	divorce
			-- Divorce from `spouse'.
		require
			married: spouse /= Void
		do
			spouse.set_spouse (Void)
			spouse := Void
		ensure
			not_married: spouse = Void
			spouse_not_married: (old spouse).spouse = Void
		end

feature {PERSON} -- Implementation

	set_spouse (a_person: PERSON)
			-- Set `spouse' to `a_person'.
		require
			person_not_current: a_person /= Current
		do
			spouse := a_person
		ensure
			spouse_set: spouse = a_person
		end

invariant
	not_married_to_self: spouse /= Current
	marriage_symmetric: spouse /= Void implies spouse.spouse = Current

end
