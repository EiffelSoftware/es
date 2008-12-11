indexing
	description: "Summary description for {VARIOUS}."
	date: "$Date$"
	revision: "$Revision$"

class
	VARIOUS

feature

	skipped_feature: INTEGER
		indexing
			verify: False
		do
			Result := 7
		ensure
			Result = 0
		end

	initialized_locals
		local
			integer: INTEGER
			boolean: BOOLEAN
			detached: ANY
			attached: !ANY
		do
			check integer = 0 end
			check boolean = False end
			check detached = Void end
			check attached /= Void end
		end

	object_creation
		local
			any: ANY
		do
			create any
			check any /= Void end
		end

	arithmetic (switch: BOOLEAN; a, b: INTEGER): INTEGER
		require
			a > b
		do
			if switch then
				Result := b - a
			else
				Result := -(a - b)
			end
		ensure
			Result < 0
		end

	infix_features (a, b: VARIOUS): BOOLEAN
		require
			a /= Void
			b /= Void
		do
			Result := a @ b
		end

	infix "@" (other: VARIOUS): BOOLEAN
		require
			other_not_void: other /= Void
		do
			Result := True
		ensure
			Result
		end

end
