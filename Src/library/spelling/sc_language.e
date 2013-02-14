note
	description: "Language with its code as defined by subset of IETF language tags."

class
	SC_LANGUAGE

inherit

	ANY
		redefine
			is_equal,
			out
		end

create
	make, make_with_region

feature {NONE} -- Initialization

	make (a_primary_language: READABLE_STRING_8)
			-- Make just with primary language subtag in ASCII.
		require
			primary_language_nonempty: not a_primary_language.is_empty
		do
			primary_language := a_primary_language.deep_twin
			region := ""
		ensure
			primary_language_set: primary_language ~ a_primary_language
			region_empty: region.is_empty
		end

	make_with_region (a_primary_language, a_region: READABLE_STRING_8)
			-- Make with primary language and region subtag in ASCII.
		require
			primary_language_nonempty: not a_primary_language.is_empty
			region_nonempty: not a_region.is_empty
		do
			primary_language := a_primary_language.deep_twin
			region := a_region.deep_twin
		ensure
			primary_language_set: primary_language ~ a_primary_language
			region_set: region ~ a_region
		end

feature -- Access

	is_equal (other: SC_LANGUAGE): BOOLEAN
		do
			Result := primary_language ~ other.primary_language and region ~ other.region
		end

	out: STRING_8
			-- Whole IETF language tag in ASCII.
		do
			Result := simplified_code
		ensure then
			nonempty: not Result.is_empty
		end

	simplified_code: READABLE_STRING_8
			-- Simplified IETF language tag in ASCII only with primary language subtag
			-- and region subtag if present. Examples: "en", "en-GB", "pt-BR".
		local
			code: STRING_8
		do
			create code.make_from_string (primary_language)
			if not region.is_empty then
				code.append (Subtag_separator)
				code.append (region)
			end
			Result := code
		ensure
			nonempty: not Result.is_empty
		end

feature {SC_LANGUAGE} -- Language subtags

	primary_language: STRING_8
			-- Two or three letter language code as in ISO 639 standards.
		attribute
		ensure
			nonempty: not Result.is_empty
		end

	region: STRING_8
			-- Two letter country code from ISO 3166-1 alpha-2 or
			-- three digit code from UN M.49 for geographical regions.

feature {NONE} -- Implementation

	Subtag_separator: STRING_8 = "-"
			-- Separator between subtags of whole language tag.

end
