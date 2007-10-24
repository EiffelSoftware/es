indexing
	description: "Downward conversion of model types with one generic parameter"
	version: "$Id$"
	author: "Bernd Schoeller"
	copyright: "see License.txt"

class
	MML_CONVERSION[G]

inherit
	MML_USER

feature -- Conversion Checks

	is_valid_sequence (subject: MML_SET[MML_PAIR[INTEGER,G]]): BOOLEAN is
			-- Is `subject' a valid sequence ?
		require
			subject_not_void: subject /= Void
		local
			subject_relation: MML_RELATION[INTEGER,G]
			i: INTEGER
			subject_domain: MML_SET[INTEGER]
		do
			subject_relation := converter_integer_g.as_relation (subject)
			if subject_relation.is_function then
				subject_domain := subject_relation.domain
				from
					i := 1
					Result := true
				until
					i > subject_relation.count or not Result
				loop
					Result := subject_domain.contains (i)
					i := i + 1
				end
			else
				Result := false
			end
		ensure
			sequences_are_functions: Result implies converter_integer_g.as_relation(subject).is_function
			domain_is_prefix: Result implies
				equal_value(converter_integer_g.as_relation(subject).domain,
					create {MML_RANGE_SET}.make_from_range(1,subject.count))
		end

	is_valid_bag (subject: MML_SET[MML_PAIR[G,INTEGER]]): BOOLEAN is
			-- Is `subject' a valid bag ?
		require
			subject_not_void: subject /= Void
		local
			subject_relation: MML_RELATION[G,INTEGER]
			a: ARRAY[MML_PAIR[G,INTEGER]]
			i: INTEGER
		do
			subject_relation := converter_g_integer.as_relation(subject)
			Result := subject_relation.is_function
			if Result then
				from
					a := subject_relation.as_array
					i := 1
				until
					i > subject_relation.count or not Result
				loop
					Result := a.item(i).second >= 1
					i := i + 1
				end
			end
		end

feature -- Conversion

	as_bag (subject: MML_SET[MML_PAIR[G,INTEGER]]): MML_BAG[G] is
			-- `subject', converted to MML_ENDORELATION
		require
			subject_not_void: subject /= Void
			subject_is_bag: is_valid_bag(subject)
		do
			Result ?= subject
			if Result = Void then
				create {MML_DEFAULT_BAG [G]} Result.make_from_array (subject.as_array)
			end
		ensure
			converted_not_void: Result /= Void
			converted_equivalent: equal_value (Result,subject)
		end

	as_endorelation (subject: MML_SET[MML_PAIR[G,G]]): MML_ENDORELATION[G] is
			-- `subject', converted to MML_ENDORELATION
		require
			subject_not_void: subject /= Void
		do
			Result ?= subject
			if Result = Void then
				create {MML_DEFAULT_ENDORELATION [G]} Result.make_from_array (subject.as_array)
			end
		ensure
			converted_not_void: Result /= Void
			converted_equivalent: equal_value (Result,subject)
		end

	as_powerset (subject: MML_SET[MML_SET[G]]): MML_POWERSET[G] is
			-- `subject', converted to MML_POWERSET
		require
			subject_not_void: subject /= Void
		do
			Result ?= subject
			if Result = Void then
				create {MML_DEFAULT_POWERSET[G]}Result.make_from_array (subject.as_array)
			end
		ensure
			converted_not_void: Result /= Void
			converted_equivalent: equal_value (Result,subject)
		end

	as_sequence (subject: MML_SET[MML_PAIR[INTEGER,G]]): MML_SEQUENCE[G] is
			-- `subject', converted to MML_SEQUENCE
		require
			subject_not_void: subject /= Void
			subject_is_sequence: is_valid_sequence(subject)
		local
			new_array:ARRAY[G]
			subject_relation: MML_RELATION[INTEGER,G]
			i:INTEGER
		do
			Result ?= subject
			if Result = Void then
				subject_relation := converter_integer_g.as_relation(subject)
				create new_array.make(1,subject_relation.count)
				from
					i := 1
				until
					i > subject_relation.count
				loop
					new_array.put(subject_relation.item(i),i)
					i := i + 1
				end
			end
			create {MML_DEFAULT_SEQUENCE[G]}Result.make_from_array(new_array)
		ensure
			converted_not_void: Result /= Void
			converted_equivalent: equal_value (Result,subject)
		end

feature{NONE} -- Implementation

	converter_integer_g: MML_CONVERSION_2[INTEGER,G] is
			-- Converter to MML_RELATION[INTEGER,G]
		do
			create Result
		end

	converter_g_integer: MML_CONVERSION_2[G,INTEGER] is
			-- Converter to MML_RELATION[INTEGER,G]
		do
			create Result
		end

end
