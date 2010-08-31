note
	description: "Objects that represent locations in a program"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	EPA_PROGRAM_LOCATION

inherit
	EPA_HASH_CALCULATOR

feature -- Access

	class_: attached CLASS_C
			-- Associated class of the location.
		deferred
		end

	feature_: attached FEATURE_I
			-- Feature associated with the location.
		deferred
		end

	line_number: INTEGER
			-- Line number of the location in the stop-point view.
		deferred
		ensure
			Result_positive: Result > 0
		end

feature -- Hash

	key_to_hash: DS_LINEAR [INTEGER]
			-- <Precursor>
		local
			l_keys: DS_ARRAYED_LIST [INTEGER]
		do
			create l_keys.make (3)
			l_keys.force_last (class_.class_id)
			l_keys.force_last (feature_.feature_id)
			l_keys.force_last (line_number)

			Result := l_keys
		end


end
