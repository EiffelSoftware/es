note
	description: "Summary description for {AFX_BEHAVIOR_CONSTRUCTOR_CONFIG_EQUALITY_TESTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_BEHAVIOR_CONSTRUCTOR_CONFIG_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [AFX_BEHAVIOR_CONSTRUCTOR_CONFIG]
		redefine
			test
		end

create
	default_create

feature -- Equality

	test (u, v: detachable AFX_BEHAVIOR_CONSTRUCTOR_CONFIG): BOOLEAN
			-- <Precursor>
		do
		    if u = v then
		        Result := True
		    elseif u = Void or v = Void then
		        Result := False
		    elseif u.is_equal (v) then
		        Result := True
		    else
		        Result := False
		    end
		end
end
