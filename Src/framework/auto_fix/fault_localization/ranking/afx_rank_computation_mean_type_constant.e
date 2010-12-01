note
	description: "Summary description for {AFX_RANK_COMPUTATION_MEAN_TYPE_CONSTANT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	AFX_RANK_COMPUTATION_MEAN_TYPE_CONSTANT

inherit
	ANY
		undefine
			is_equal,
			copy
		end
		
feature -- Status report

	is_valid_mean_type (a_mean_type: INTEGER): BOOLEAN
			-- Is `a_mean_type' a valid mean type?
		do
			Result := a_mean_type = Mean_type_arithmetic or else a_mean_type = Mean_type_geometric or else a_mean_type = Mean_type_harmonic
		end

feature -- Constant

	Mean_type_arithmetic: INTEGER = 1
	Mean_type_geometric: INTEGER = 2
	Mean_type_harmonic: INTEGER = 3

end
