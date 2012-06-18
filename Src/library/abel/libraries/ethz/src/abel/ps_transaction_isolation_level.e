note
	description: "Summary description for {PS_TRANSACTION_ISOLATION_LEVEL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

frozen class
	PS_TRANSACTION_ISOLATION_LEVEL

inherit COMPARABLE

feature

	Read_uncommitted: PS_TRANSACTION_ISOLATION_LEVEL
		once
			create Result
		end

	Read_committed: PS_TRANSACTION_ISOLATION_LEVEL
		once
			create Result
		end

	Repeatable_read: PS_TRANSACTION_ISOLATION_LEVEL
		once
			create Result
		end

	Serializable: PS_TRANSACTION_ISOLATION_LEVEL
		once
			create Result
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		local
			valid_levels: LINKED_LIST[PS_TRANSACTION_ISOLATION_LEVEL]
		do
			create valid_levels.make
			valid_levels.extend (Serializable)
			if Current = Repeatable_read and valid_levels.has (other) then
				Result:= True
			else
				valid_levels.extend (Repeatable_read)
				if Current = Read_committed and valid_levels.has (other) then
					Result:= True
				else
					valid_levels.extend (Read_committed)
					if Current = Read_uncommitted and valid_levels.has (other) then
						Result := True
					else
						Result:=False
					end
				end
			end
		end

end
