class
	VAR

create
	make

feature {NONE}
	make (a_max: INTEGER)
		do
			max := a_max
		end

	max: INTEGER
	occupants: INTEGER
	done: INTEGER

feature
	inc
		do
			occupants := occupants + 1
		end

	set_done
		do
			done := done + 1
			if done = max then
				occupants := 0
				done := 0
			end
		end

	is_full: BOOLEAN
		do
			Result := max = occupants
		end
end
