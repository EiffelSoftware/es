note
	description: "Mechanisms for building programs for alias computation."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	BUILDER

feature -- Status report

	has_outer: BOOLEAN
			-- Is current block nested in another?
		do
			if attached {COMPOUND} scope as cp then
				Result := (cp.outer /= Void)
			end
		end

	then_nesting: INTEGER
			-- Number of Then_parts enclosing current block.

	else_nesting: INTEGER
			-- Number of Else_parts enclosing current block.

feature -- Access

	scope: CONSTRUCT
			-- Program element at the current level of nesting.

	snapshots: HASH_TABLE [SNAP, STRING]
			-- Snap instructions, indexed by their labels.
		once
			create Result.make (1)
		end

feature -- Program construction

	set (e: VARIABLE; f: EXPRESSION)
			-- Add at end of current block
			-- the assignment `e' := `f'.
		require
			in_block: attached {COMPOUND} scope
		local
			sa: SIMPLE_ASSIGNMENT
		do
			create sa.make (e, f)
			extend (sa)
		ensure
			in_block: attached {COMPOUND} scope
					-- Unchanged from precondition
		end

	creator (e: VARIABLE)
			-- Add at end of current block
			-- the creation instruction `create e'.
		require
			in_block: attached {COMPOUND} scope
		local
			cr: CREATOR
		do
			create cr.make (e)
			extend (cr)
		ensure
			in_block: attached {COMPOUND} scope
					-- Unchanged from precondition
		end

	forget (e: VARIABLE)
			-- Add at end of current block
			-- the forgetting instruction `forget e'.
		require
			in_block: attached {COMPOUND} scope
		local
			fo: FORGET
		do
			create fo.make (e)
			extend (fo)
		ensure
			in_block: attached {COMPOUND} scope
					-- Unchanged from precondition
		end

	cut (e, f: EXPRESSION)
			-- Add at end of current block
			-- the sever instruction `cut e, f'.
		require
			in_block: attached {COMPOUND} scope
		local
			se: CUT
		do
			create se.make (e, f)
			extend (se)
		ensure
			in_block: attached {COMPOUND} scope
					-- Unchanged from precondition
		end

	snap (l: STRING)
			-- Add at end of current block
			-- a snap instruction with label `l'.
		require
			in_block: attached {COMPOUND} scope
			label_exists: l /= Void
			label_not_empty: not l.is_empty
			label_not_taken: (snapshots /= Void) implies not snapshots.has (l)
		local
			sn: SNAP
		do
			create sn.make (l)
			snapshots.put (sn, l)
			extend (sn)
		ensure
			in_block: attached {COMPOUND} scope
					-- Unchanged from precondition
			recorded: snapshots.has (l)
		end


	printout (tag: STRING)
			-- Add at end of current block
			-- the instruction `printout' which prints the current relation.
		require
			in_block: attached {COMPOUND} scope
			tag_exists: tag /= Void
		local
			po: PRINTOUT
		do
			create po.make (tag)
			extend (po)
		ensure
			in_block: attached {COMPOUND} scope
					-- Unchanged from precondition
		end

	printsnap (l: STRING)
			-- Add at end of current block
			-- an instruction that prints the snap instruction of label `l'.
		require
			in_block: attached {COMPOUND} scope
			label_exists: l /= Void
			label_not_empty: not l.is_empty
			snap_exists: snapshots.has (l)
		local
			pn: PRINTSNAP
		do
			check attached snapshots.item (l) as s then
				create pn.make (s)
				extend (pn)
			end
		ensure
			in_block: attached {COMPOUND} scope
					-- Unchanged from precondition
		end

	start_then
			-- Start new conditional instruction with Then_part.
		local
			co: CONDITIONAL
		do
			then_nesting := then_nesting + 1
			create co.make
			co.outer := scope
			scope := co
			start_block
		ensure
			more_then: then_nesting = old then_nesting + 1
			in_block: attached {COMPOUND} scope
			in_conditional: attached {CONDITIONAL} scope.outer
		end

	start_else
			-- Continue conditional instruction with Else_part.
		require
			in_then: then_nesting > 0
			is_block: attached {COMPOUND} scope
			in_conditional: attached {CONDITIONAL} scope.outer
		do
			then_nesting := then_nesting - 1
			else_nesting := else_nesting + 1
			if attached {CONDITIONAL} scope.outer as co
				and attached {COMPOUND} scope as pr
			then
				co.then_part := pr
			end
			end_block
			start_block
		ensure
			less_then: then_nesting = old then_nesting - 1
			more_else: else_nesting = old else_nesting + 1
			in_block: attached {COMPOUND} scope
			in_conditional: attached {CONDITIONAL} scope.outer
		end

	end_if
			-- Close conditional instruction.
		require
			in_else: else_nesting > 0
			in_block: attached {COMPOUND} scope
			in_conditional: attached {CONDITIONAL} scope.outer
		do
			else_nesting := else_nesting - 1
			if attached {CONDITIONAL} scope.outer as co
				and attached {COMPOUND} scope as pr
			then
				co.else_part := pr
				end_block
				check attached {CONDITIONAL} scope end
				if attached scope.outer as o then
					scope := o
					check attached {COMPOUND} scope end
					if attached {COMPOUND} scope as outermost then
						outermost.extend (co)
					end
				end
			end
		ensure
			less_else: else_nesting = old else_nesting - 1
			in_block: attached {COMPOUND} scope	-- Unchanged from precondition
		end

	start_loop
			-- Start new loop.
		local
			lo: LOOP1
		do
			create lo
			lo.outer := scope
			scope := lo
			start_block
		ensure
			in_block: attached {COMPOUND} scope
			in_loop: attached {LOOP1} scope.outer
		end

	end_loop
			-- Close loop.
		require
			in_block: attached {COMPOUND} scope
			in_loop: attached {LOOP1} scope.outer
		do
			if attached {LOOP1} scope.outer as lo
				and attached {COMPOUND} scope as pr
			then
				lo.body := pr
				end_block
				check attached {LOOP1} scope end
				if attached scope.outer as o then
					scope := o
					check attached {COMPOUND} scope end
					if attached {COMPOUND} scope as outermost then
						outermost.extend (lo)
					end
				end
			end
		ensure
			in_block: attached {COMPOUND} scope
		end

	start_iter (n: INTEGER)
			-- Start new iteration, with count `n'.
		local
			it: ITER
		do
			create it.make (n)
			it.outer := scope
			scope := it
			start_block
		ensure
			in_block: attached {COMPOUND} scope
			in_loop: attached {ITER} scope.outer
		end

	end_iter
			-- Close iteration.
		require
			in_block: attached {COMPOUND} scope
			in_loop: attached {ITER} scope.outer
		do
			if attached {ITER} scope.outer as it
				and attached {COMPOUND} scope as pr
			then
				it.body := pr
				end_block
				check attached {ITER} scope end
				if attached scope.outer as o then
					scope := o
					check attached {COMPOUND} scope end
					if attached {COMPOUND} scope as outermost then
						outermost.extend (it)
					end
				end
			end
		ensure
			in_block: attached {COMPOUND} scope
		end

	call (pn: STRING)
			-- Add at end of current block
			-- a call to procedure of name `pn'.
		require
				name_exists: pn /= Void
				name_non_empty: not pn.is_empty
		local
			c: CALL_UNQUALIFIED
			enclosing: detachable CONSTRUCT
		do
			from
				enclosing:= scope
			until
				enclosing = Void or else attached {PROGRAM} enclosing
			loop
				enclosing := enclosing.outer
			end
			check attached {PROGRAM} enclosing as pr then
				create c.make (pn, pr)
			end
			extend (c)
		ensure
			in_block: attached {COMPOUND} scope
		end

	qualified (v: VARIABLE; pn: STRING)
			-- Add at end of current block a call `v.p'
			-- where `p' is the procedure of name `pn'.
		require
				name_exists: pn /= Void
				name_non_empty: not pn.is_empty
		local
			cq: CALL_QUALIFIED
			enclosing: detachable CONSTRUCT
		do
			from
				enclosing:= scope
			until
				enclosing = Void or else attached {PROGRAM} enclosing
			loop
				enclosing := enclosing.outer
			end
			check attached {PROGRAM} enclosing as pr then
				create cq.make (v, pn, pr)
			end
			extend (cq)
		ensure
			in_block: attached {COMPOUND} scope
		end


	start_procedure (n: STRING)
			-- Start new procedure declaration of name `n'.
		require
				name_exists: n /= Void
				name_non_empty: not n.is_empty
		local
			pd: PROCEDURE1
		do
			create pd.make (n)
			pd.outer := scope
			scope := pd
			start_block
		ensure
			in_block: attached {COMPOUND} scope
			in_proocedure: attached {PROCEDURE1} scope.outer
		end

	end_procedure
			-- Close procedure declaration.
		require
			in_block: attached {COMPOUND} scope
			in_procedure: attached {PROCEDURE1} scope.outer
		local
			procname: STRING
		do
			if attached {PROCEDURE1} scope.outer as pd
				and attached {COMPOUND} scope as pr
			then
				pd.body := pr
				procname := pd.name
					check procname /= Void and then not procname.is_empty end
				end_block
				check attached {PROCEDURE1} scope end
				if attached scope.outer as o then
					scope := o
					check attached {PROGRAM} scope end
					if attached {PROGRAM} scope as outermost then
						outermost.force (pd, procname)
					end
				end
			end
		ensure
			in_procedure1: attached {PROGRAM} scope
		end

	start_program (n: STRING)
			-- Start program, expecting main procedure of name `n'.
		require
				name_exists: n /= Void
				name_non_empty: not n.is_empty
		local
			pr: PROGRAM
		do
			create pr.make (n)
			scope := pr
		ensure
			in_program: attached {PROGRAM} scope

		end

feature {NONE} -- Implementation

	extend (i: INSTRUCTION)
				-- Nest `i' at end of current compound.
			require
				attached {COMPOUND} scope
			do
				i.outer := scope
				if attached {COMPOUND} scope as pr then
						pr.extend (i)
				end
			end

	start_block
			-- Start inner block.
		local
			new: COMPOUND
		do
			create new.make
			new.outer := scope
			scope := new
		ensure
			is_nested: has_outer
		end

	end_block
			-- Return to outer block.
		require
			is_nested: has_outer
			is_block: attached {COMPOUND} scope
			in_control:
				attached {CONTROL} scope.outer or
				attached {PROCEDURE1} scope.outer
		do
			check
				from_precondition: attached scope.outer as o
			then
				scope := o
			end
		end

end
