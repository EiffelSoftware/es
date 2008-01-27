indexing
	description: "[
			Help controlling CDD breakpoints (hidden)
			and still allow normal user breakpoints)
		]"
	author: "Jocelyn Fiat"
	date: "$Date$"
	revision: "$Revision$"

class
	CDD_BREAKPOINTS_LIST

inherit
	HASH_TABLE [BREAKPOINT_KEY, BREAKPOINT_KEY]
		rename
			make as ht_make
		export
			{NONE} all
			{ANY} wipe_out, count
		redefine
			wipe_out
		end

create
	make

feature {NONE} -- Creation

	make (bpm: like manager; nb: INTEGER) is
		do
			manager := bpm
			ht_make (nb)
			compare_objects
		end

	manager: BREAKPOINTS_MANAGER
			-- Breakpoints manager.

feature -- Access

	do_all (action: PROCEDURE [ANY, TUPLE [BREAKPOINT_KEY]]) is
		require
			action_not_void: action /= Void
		local
			bpk: BREAKPOINT_KEY
		do
			from
				start
			until
				after
			loop
				bpk := item_for_iteration
				if bpk /= Void then
					action.call ([bpk])
				end
				forth
			end
		end

	new_cdd_key (f: E_FEATURE; i: INTEGER): BREAKPOINT_KEY is
			-- New key for Current.
		do
			create Result.make (f, i)
		end

	new_breakpoint (f: E_FEATURE; i: INTEGER): BREAKPOINT is
			-- New breakpoint for `f' and `i'.
		do
			create Result.make (f, i)
		end


feature -- Status

	has_cdd_breakpoint (f: E_FEATURE): BOOLEAN is
			-- Has CDD breakpoint associated to `f' ?
			-- if found set the value to `found_item'.
		require
			f_valid: f /= Void
		local
			i: like item_for_iteration
		do
--			Result := has_breakpoint (new_cdd_key (f, f.first_breakpoint_slot_index))
			from
				start
			until
				Result or after
			loop
				i := item_for_iteration
				if i.routine.is_equal (f) then
					Result := True
					found_item := i
				end
				forth
			end
		end

feature -- Change

	wipe_out is
			-- Wipe out cdd breakpoints
			-- in cae this is done during debugging session
			-- we have to remove one by one, to be sure they will be unset from application
		do
			from
				start
			until
				after
			loop
				remove_cdd_breakpoint (item_for_iteration.routine)
				forth
			end
			Precursor
		end

	update is
			-- Be sure CDD breakpoints are up to date
			-- this should not be used since CDD breakpoints are added
			-- just before launching the application
		local
			f_lst: ARRAYED_LIST [E_FEATURE]
			k: BREAKPOINT_KEY
			f: E_FEATURE
			i: INTEGER
		do
			if not is_empty then
				from
					create f_lst.make (count)
					start
				until
					after
				loop
					k := item_for_iteration
					f := k.routine
					i := f.first_breakpoint_slot_index
					if i /= k.breakable_line_number then
							--| We need to update this index
						remove (key_for_iteration)
						f_lst.force (item_for_iteration.routine)
					else
						forth
					end
				end
				f_lst.do_all (agent add_cdd_breakpoint)
			end
		end

	add_cdd_breakpoint (f: E_FEATURE) is
			-- Add CDD breakpoint for feature `f'
		require
			f_valid: f /= Void
		local
			k: like new_cdd_key
			l: INTEGER
		do
if False then
	--| If were are sure, we add those CDD breakpoints
	--| only just before launching the application
	--| (i.e: the compilation's data won't change, and thus the breakable index won't change too
			k := new_cdd_key (f, l)
			if not has (k) then
				force (k, k)
			end
else
	--| Safe solution, we always check if associated bp (if exist) is up to date.
			l := f.first_breakpoint_slot_index
			if has_cdd_breakpoint (f) then
				check found_item_not_void: found_item /= Void end
				if found_item.breakable_line_number /= l then
					remove_cdd_breakpoint (f)
					k := new_cdd_key (f, l)
					force (k, k)
				else
					--| Already there, and up to date.
				end
			else
				k := new_cdd_key (f, l)
				force (k, k)
			end
end

		ensure
			has_cdd_breakpoint: has_cdd_breakpoint (f)
		end

	remove_cdd_breakpoint (f: E_FEATURE) is
			-- Remove CDD breakpoint for feature `f'	
		require
			has_cdd_breakpoint: has_cdd_breakpoint (f)
		local
			k: BREAKPOINT_KEY
			i: INTEGER
			bp: BREAKPOINT
		do
--			remove_breakpoint (new_cdd_key (f, f.first_breakpoint_slot_index))
			from
				start
			until
				after
			loop
				if item_for_iteration.routine.is_equal (f) then
					remove (key_for_iteration)
						--| Make sure it will also be removed (if needed) from application.
					k := item_for_iteration
					check k.routine.is_equal (f) end
					i := k.breakable_line_number
					if manager.is_breakpoint_set (f, i) then
						--| Already managed by user breakpoints
					else -- Then we create a fake breakpoint, and unset it
						bp := new_breakpoint (f, i)
						bp.disable
						manager.breakpoints.add_breakpoint (bp)
						bp.discard
					end
				else
					forth
				end
			end
		end

end
