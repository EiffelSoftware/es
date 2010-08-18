note
	description: "Class that rerpresent linear regression of some dependent variable"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RM_LINEAR_REGRESSION

create
	make

feature{NONE} -- Creation

	make (a_dependent_variable: STRING)
			-- `a_dependent_variable' the name of the dependent variable.
		do
			dependent_variable := a_dependent_variable.twin
			create regressors.make (10)
		end

feature -- Setting

	set_dependent_variable (a_dependent_variable: STRING)
			-- Set `dependent_variable' with `a_dependent_variable'.
		do
			dependent_variable := a_dependent_variable.twin
		ensure
			dependent_var_is_set: dependent_variable = a_dependent_variable
		end

feature -- Interface	

	add_regressor (a_name: STRING; a_value: DOUBLE)
			-- Adds a regressor to this linear regression formula.
			-- `a_name' is the name of the regressor and `a_value' is the value of its coefficient.
		do
			regressors.force (a_value, a_name)
		end

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
			Result := True
			from regressors.start until regressors.after loop
				Result := Result and (regressors.item_for_iteration.floor = regressors.item_for_iteration)
				regressors.forth
			end
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
			last_regression := 0
			from regressors.start until regressors.after loop
				if regressors.key_for_iteration ~ constant_regressor then
					last_regression := last_regression + regressors.item_for_iteration
				else
					last_regression := last_regression + ( regressors.item_for_iteration * a_regressor_values.item (regressors.key_for_iteration) )
				end

				regressors.forth
			end
		end

end
