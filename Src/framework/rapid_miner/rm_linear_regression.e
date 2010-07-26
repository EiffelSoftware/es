note
	description: "Class that rerpresent linear regression of some dependent variable"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_LINEAR_REGRESSION

feature -- Access

	dependent_variable: STRING
			-- Name of the dependent variable

	regressors: HASH_TABLE [DOUBLE, STRING]
			-- Table of regressors and their coefficients
			-- Key is name of a regressor variable, value
			-- is the coefficient of that regressor variable.

feature -- Access

	last_regression: DOUBLE
			-- Last regression of `dependent_variable' calculated by `regress'

feature -- Constants

	constant_regressor: STRING = ""
			-- Name of the constant regressor

feature -- Status report

	is_all_regressor_coefficient_integer: BOOLEAN
			-- Are all the coefficients of `regressors' integers?
		do
		end

feature -- Basic operation

	regress (a_regressor_values: HASH_TABLE [DOUBLE, STRING])
			-- Calculate the value of `dependent_variable' based on the values
			-- of regressor variables given by `a_regressor_values', and store
			-- result in `last_regression'.
		require
			a_regressor_values_valid:
				across a_regressor_values as l_regressors  all
					l_regressors.key /~ constant_regressor and then
					regressors.has (l_regressors.key)
				end
		do
		end

end
