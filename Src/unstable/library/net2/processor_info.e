note
	description: "{PROCESSOR_INFO} reports information on the processor it residing."
	author: "Mischael Schill"
	date: "$Date$"
	revision: "$Revision$"

class
	PROCESSOR_INFO

feature -- Access
	processor_id: INTEGER
		do
			Result := ext_pid (Current)
		end

feature {NONE} -- Externals
	ext_pid (a_any: ANY): INTEGER
		external
			"C inline"
		alias
			"return RTS_PID (eif_access($a_any));"
		end


end
