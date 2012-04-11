indexing
	description: "Db4o ICONSTRAINT wrapper"
	author: "Ruihua Jin"
	date: "$Date: 2008/01/30 11:33:22$"
	revision: "$Revision: 1.0$"

class
	CONSTRAINT

create
	make

feature {NONE}  -- Initialization

	make (con: ICONSTRAINT) is
			-- Initialize with `con'.
		require
			con_not_void: con /= Void
		do
			constraint := con
		end

feature  -- Methods of ICONSTRAINT

	and_ (with: CONSTRAINT): CONSTRAINT is
			-- Link `Current' with `with' for AND evaluation,
			-- return a new `CONSTRAINT', that can be used for further calls
			-- to `and_' or `or_'.
		require
			with_not_void: with /= Void
		local
			dc: ICONSTRAINT
			dclist: LINKED_LIST[ICONSTRAINT]
		do
			create Result.make (constraint.and_ (with.constraint))
		end

	or_ (with: CONSTRAINT): CONSTRAINT is
			-- Link `Current' with `with' for OR evaluation,
			-- return a new `CONSTRAINT', that can be used for further calls
			-- to `and_' or `or_'.
		require
			with_not_void: with /= Void
		local
			dc: ICONSTRAINT
			dclist: LINKED_LIST[ICONSTRAINT]
		do
			create Result.make (constraint.or_ (with.constraint))
		end

	not_: CONSTRAINT is
			-- Turn on `not_' comparison,
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.not_
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.not_
					descendant_constraints.forth
				end
			end
			Result := Current
		end

	contains: CONSTRAINT is
			-- Set the evaluation mode to containment comparison,
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.contains
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.contains
					descendant_constraints.forth
				end
			end
			Result := Current
		end

	like_: CONSTRAINT is
			-- Set the evaluation mode to "like" comparison,
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.like_
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.like_
					descendant_constraints.forth
				end
			end
			Result := Current
		end


	starts_with (case_sensitive: BOOLEAN): CONSTRAINT is
			-- Set the evaluation mode to string starts_with comparison,
			-- comparison will be case sensitive if `case_sensitive' is true,
			-- case insensitive otherwise,
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.starts_with (case_sensitive)
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.starts_with (case_sensitive)
					descendant_constraints.forth
				end
			end
			Result := Current
		end


	ends_with (case_sensitive: BOOLEAN): CONSTRAINT is
			-- Set the evaluation mode to string ends_with comparison,
			-- comparison will be case sensitive if `case_sensitive' is true,
			-- case insensitive otherwise,
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.ends_with (case_sensitive)
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.ends_with (case_sensitive)
					descendant_constraints.forth
				end
			end
			Result := Current
		end

	equal_: CONSTRAINT is
			-- Used in conjunction with `CONSTRAINT.smaller' or `CONSTRAINT.greater'
			-- to create constraints like "smaller or equal", "greater or equal".
			-- Return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.equal
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.equal
					descendant_constraints.forth
				end
			end
			Result := Current
		end

	greater: CONSTRAINT is
			-- Set the evaluation mode to ">",
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.greater
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.greater
					descendant_constraints.forth
				end
			end
			Result := Current
		end

	smaller: CONSTRAINT is
			-- Set the evaluation mode to "<",
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.smaller
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.smaller
					descendant_constraints.forth
				end
			end
			Result := Current
		end

	identity: CONSTRAINT is
			-- Set the evaluation mode to identity comparison,
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.identity
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.identity
					descendant_constraints.forth
				end
			end
			Result := Current
		end

	get_object: SYSTEM_OBJECT is
			-- The `SYSTEM_OBJECT' the query graph was constrained with to create `Current'.
		do
			Result := constraint.get_object
		end

	by_example: CONSTRAINT is
			-- Set the evaluation mode to object comparison (query by example),
			-- return `Current' to allow the chaining of method calls.
		local
			c: ICONSTRAINT
			dc: ICONSTRAINT
		do
			c := constraint.by_example
			if (descendant_constraints /= Void and then descendant_constraints.count > 0) then
				from
					descendant_constraints.start
				until
					descendant_constraints.after
				loop
					dc := descendant_constraints.item
					c := dc.by_example
					descendant_constraints.forth
				end
			end
			Result := Current
		end

feature  -- Access	

	constraint: ICONSTRAINT
			-- The actual ICONSTRAINT object for SODA query


feature {CONSTRAINT, QUERY} -- Constraints for renamed attributes in descendant types

	descendant_constraints: LINKED_LIST[ICONSTRAINT]
			-- Constraints for new names in descendant types

	set_descendant_constraints (dc: LINKED_LIST[ICONSTRAINT]) is
			-- Set `descendant_constraints' to `dc'.
		do
			descendant_constraints := dc
		end


end
