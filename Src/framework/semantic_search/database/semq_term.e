note
	description: "Class that represents a term in SQL-implementation of the semantic search system"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SEMQ_TERM

inherit
	HASHABLE

	EPA_UTILITY

	SHARED_TYPES

	DEBUG_OUTPUT

	SEM_CONSTANTS

	SEMQ_MYSQL_UTILITY

feature -- Access

	queryable: SEM_QUERYABLE
			-- Queryable whose property Current term is describing

	entity: EXPR_AS
			-- Entity inside Current term
			-- This can be an expression described a searched criterion (in this case,
			-- the expression must evaluates to boolean type); or an expression describing
			-- the information to return.
		deferred
		end

	type: TYPE_A
			-- Type of `entity'
		deferred
		end

	text: STRING
			-- Text representation of Current term
		deferred
		end

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := text
		end

	return_config: detachable SEMQ_TERM_RETURN_CONFIG
			-- Configuration to decide how current term is to be returned.
			-- Void if current term is not to be returned.			

	ordering_config: detachable SEMQ_TERM_ORDERING_CONFIG
			-- Configuration to decide how current term is to be ordered.
			-- Void if current term does not participart in ordering.

	columns_in_result (a_start_column: INTEGER): INTEGER_INTERVAL
			-- 1-based column ranges in the resulting SQL table starting from `a_start_column'
		require
			is_required: is_required
			a_start_column_valid: a_start_column >= 1
		deferred
		ensure
			good_result: not Result.is_empty and then Result.lower >= 1
		end

	column_types_in_result (a_start_column: INTEGER): HASH_TABLE [INTEGER, INTEGER]
			-- Types of columns in the resulting SQL table starting from `a_start_column'
			-- Result is a hash-table where keys are columns in the returned SQL table,
			-- and keys are mysql type ids (see `mysql_boolean_type', `mysql_integer_type', `mysql_real_type', and `mysql_string_type').
		require
			is_required: is_required
			a_start_column_valid: a_start_column >= 1
		deferred
		ensure
			good_result: across columns_in_result (a_start_column) as l_columns all Result.has (l_columns.item) end
		end

	column_count_in_result: INTEGER
			-- The number of columns that current term occupies in the resulting SQL table
		do
			if is_required then
				Result := columns_in_result (1).count
			end
		ensure
			good_result:
				(is_required implies Result > 0) and
				(not is_required implies Result = 0)
		end

feature -- Status report

	is_searched: BOOLEAN
			-- Does Current term specify some searched criterion of
			-- the containing query?
			-- If a term is used to constrain the result, for example,
			-- "l.has (a) = True", then `is_searched' is True.

	is_required: BOOLEAN
			-- Should the value of the entity specified in Current term
			-- be returned in the result.
			-- For some of the entities, we don't want to search them, but we want to have
			-- their values in the result set, `is_required' is devise for this purpose.
			-- For example, We want to search for a list which is not empty by specifying
			-- "not l.is_empty", and we also want to return the length of that list,
			-- we can provide a term for "l.count", whose `is_searched' is False,
			-- and whose `is_required' is True.
		do
			Result := attached return_config
		end

	is_value_grouped_by: BOOLEAN
			-- Is the value of Current term used in "GROUP BY" in the SQL statement?
			-- Default: False

feature -- Status report

	is_contract: BOOLEAN
			-- Is Current a contract term?
		do
			Result := is_precondition or is_postcondition
		end

	is_precondition: BOOLEAN
			-- Is Current a precondition term?
		do
		end

	is_postcondition: BOOLEAN
			-- Is Current a postcondition term?
		do
		end

	is_human_written: BOOLEAN
			-- Is Current a contract term and that contract is human-written?
		do
		end

	is_property: BOOLEAN
			-- Is Current a property term (for objects)?
		do
		end

	is_variable: BOOLEAN
			-- Is Current a variable term?
		do
		end

	is_meta: BOOLEAN
			-- Is Current a meta term?
		do
		end

	is_absolute_change: BOOLEAN
			-- Is Current an absolute change term?
		do
		end

	is_relative_change: BOOLEAN
			-- Is Current an relative change term?
		do
		end

feature -- Setting

	set_is_searched (b: BOOLEAN)
			-- Set `is_searched' with `b'.
		do
			is_searched := b
		ensure
			is_searched_set: is_searched = b
		end

	set_return_config (a_config: like return_config)
			-- Set `return_config' with `a_config'.
		do
			return_config := a_config
		ensure
			return_config_set: return_config = a_config
		end

	set_ordering_config (a_config: like ordering_config)
			-- Set `ordering_config' with `a_config'.
		do
			ordering_config := a_config
		ensure
			ordering_config_set: ordering_config = a_config
		end

	set_is_value_grouped_by (b: BOOLEAN)
			-- Set `is_value_grouped_by' with `b'.
		do
			is_value_grouped_by := b
		ensure
			is_value_grouped_by_set: is_value_grouped_by = b
		end

feature -- Process

	process (a_visitor: SEMQ_TERM_VISITOR)
			-- Visit Current using `a_visitor'.
		deferred
		end

invariant
	queryable_attached: queryable /= Void

end
