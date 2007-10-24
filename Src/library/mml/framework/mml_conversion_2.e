indexing
	description: "Downward conversion of model types with two generic parameters"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_CONVERSION_2[G,H]

inherit
	MML_USER

feature -- Conversion

	as_relation (subject: MML_SET[MML_PAIR[G,H]]): MML_RELATION[G,H] is
			-- `subject', converted to MML_RELATION
		require
			subject_not_void: subject /= Void
		do
			create {MML_DEFAULT_RELATION[G,H]}Result.make_from_array (subject.as_array)
		ensure
			converted_not_void: Result /= Void
			converted_equivalent: equal_value (Result,subject)
		end

end
