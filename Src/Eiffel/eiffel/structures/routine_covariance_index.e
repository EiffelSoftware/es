indexing
	description:
		"[
			Information about covariant features. This datastructure allows to ask if a feature is
			covariantly redefined in any descendant starting from a class id.

			The data structure works as follows:
			  * The hashtable `data' holds a list of class id's per routine id.
			  * Only class ids which covariantly redefine the routine (identified by the routine id)
			    are in this list. Empty lists are not stored.
			That means:
			  * If a routine id has no associated list, then there are no covariant redefinitions for
			    this routine at all
			  * If a routine id has an associated list, then you can check if any of the class ids which
			    are in the list conform to the given class id:
			      * If yes, then this subclass covariantly redefines the feature
			      * If no, then no subclass covariantly redefine the feature
			
			Todo: The data structure for the list of class ids could be changed to a heap. It should have
			      better performance than an arrayed list
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	ROUTINE_COVARIANCE_INDEX

inherit
	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make is
			-- Initialize empty index.
		do
			create data.make (300)
		end

feature -- Status report

	is_covariantly_redefined (a_routine_id: INTEGER; a_class: CLASS_C): BOOLEAN is
			-- Is the routine with id `a_routine_id' covariantly redefined in any
			-- proper descendant of class `a_class'?
		local
			l_class_list: ARRAYED_LIST [INTEGER]
			l_class_id: INTEGER
			l_possible_descendant_id: INTEGER
		do
				-- Check if a class list exists
			data.search (a_routine_id)
			if data.found then
					-- If yes, loop through class ids
				l_class_list := data.found_item
				from
					l_class_list.start
					l_class_id := a_class.class_id
				until
					l_class_list.after or Result
				loop
					l_possible_descendant_id := l_class_list.item
						-- Descendants need to have a bigger class id.
						-- We exclude the same class because we are only interested
						-- in proper descendants
					if l_possible_descendant_id > l_class_id then
							-- Check if the class conforms to the class in question
						Result := system.class_of_id (l_possible_descendant_id).conform_to (a_class)
					end
					l_class_list.forth
				end
			end
		end

--	is_covariantly_redefined_set (a_routine_id_set: ROUT_ID_SET; a_class: CLASS_C): BOOLEAN is
--			-- Is any of the routines in the routine id set `a_routine_id_set' covariantly redefined
--			-- in any proper descendant of class `a_class'?
--		local
--			i, l_count: INTEGER
--		do
--			from
--				i := 1
--				l_count := a_routine_id_set.count
--			until
--				i > l_count or Result
--			loop
--				Result := is_covariantly_redefined (a_routine_id_set.item (i), a_class)
--				i := i + 1
--			end
--		end

	is_covariantly_redefined_by_class_id (a_routine_id, a_class_id: INTEGER): BOOLEAN is
			-- Is the routine with id `a_routine_id' covariantly redefined in any
			-- proper descendant of class with `a_class_id'?
		do
			Result := is_covariantly_redefined (a_routine_id, system.class_of_id (a_class_id))
		end

	is_covariantly_redefined_in_class (a_routine_id: INTEGER; a_class: CLASS_C): BOOLEAN is
			-- Is the routine with id `a_routine_id' covariantly redefined in exactly class `a_class'?
		require
			a_class_not_void: a_class /= Void
		do
				-- Check if a class list exists
			data.search (a_routine_id)
			if data.found then
					-- Check if class id is in list. Then this class covariantly redfines the feature.
				Result := data.found_item.has (a_class.class_id)
			end
		end

	is_covariantly_redefined_set_in_class (a_routine_id_set: ROUT_ID_SET; a_class: CLASS_C): BOOLEAN is
			-- Is any of the routines in the routine id set `a_routine_id_set' covariantly redefined
			-- in any proper descendant of class `a_class'?
		local
			i, l_count: INTEGER
		do
			from
				i := 1
				l_count := a_routine_id_set.count
			until
				i > l_count or Result
			loop
				Result := is_covariantly_redefined_in_class (a_routine_id_set.item (i), a_class)
				i := i + 1
			end
		end

feature -- Element change

	add_class (a_routine_id_set: ROUT_ID_SET; a_class: CLASS_C) is
			-- Insert class `a_class' for routine ids in `a_routine_id_set'.
		require
			a_routine_id_set_not_void: a_routine_id_set /= Void
			a_class_not_void: a_class /= Void
		do
			add_class_id (a_routine_id_set, a_class.class_id)
		ensure
			added: is_covariantly_redefined (a_routine_id_set.first, a_class)
		end

	add_class_id (a_routine_id_set: ROUT_ID_SET; a_class_id: INTEGER) is
			-- Insert class with id `a_class_id' for routine ids in `a_routine_id_set'.
		require
			a_routine_id_set_not_void: a_routine_id_set /= Void
		local
			i, l_count, l_routine_id: INTEGER
			l_class_list: ARRAYED_LIST [INTEGER]
		do
			from
				i := 1
				l_count := a_routine_id_set.count
			until
				i > l_count
			loop
				l_routine_id := a_routine_id_set.item (i)
				data.search (l_routine_id)
				if data.found then
					l_class_list := data.found_item
					if not l_class_list.has (a_class_id) then
						l_class_list.extend (a_class_id)
					end
				else
					create l_class_list.make (3)
					data.put (l_class_list, l_routine_id)
					l_class_list.extend (a_class_id)
				end
				i := i + 1
			end
		ensure
			added: is_covariantly_redefined_by_class_id (a_routine_id_set.first, a_class_id)
		end

	remove_class (a_routine_id_set: ROUT_ID_SET; a_class: CLASS_C) is
			-- Remove class `a_class' for routines ids in `a_routine_id_set'.
		require
			a_routine_id_set_not_void: a_routine_id_set /= Void
			a_class_not_void: a_class /= Void
		do
			remove_class_id (a_routine_id_set, a_class.class_id)
		ensure
			-- No guarantees can be made. A descendant can still covariantly redefine the feature
		end

	remove_class_id (a_routine_id_set: ROUT_ID_SET; a_class_id: INTEGER) is
			-- Remove class with id `a_class_id' for routines ids in `a_routine_id_set'.
		require
			a_routine_id_set_not_void: a_routine_id_set /= Void
		local
			i, l_count, l_routine_id: INTEGER
			l_class_list: ARRAYED_LIST [INTEGER]
		do
			from
				i := 1
				l_count := a_routine_id_set.count
			until
				i > l_count
			loop
				l_routine_id := a_routine_id_set.item (i)
				data.search (l_routine_id)
				if data.found then
					l_class_list := data.found_item
					if l_class_list.has (a_class_id) then
						l_class_list.start
						l_class_list.prune (a_class_id)
					end
					if l_class_list.is_empty then
						data.remove (l_routine_id)
					end
				end
				i := i + 1
			end
		ensure
			-- No guarantees can be made. A descendant can still covariantly redefine the feature
		end

feature -- Support

	dump_to_io is
			-- Dump data of structure to standard output.
		local
			l_routine_id: INTEGER
			l_class_id_list: ARRAYED_LIST [INTEGER]
			l_class, l_origin_class: CLASS_C
			l_feature: FEATURE_I
			l_feature_name_printed: BOOLEAN
		do
			from
				data.start
			until
				data.after
			loop
				l_routine_id := data.key_for_iteration
				l_class_id_list := data.item_for_iteration

				from
					l_class_id_list.start
					l_feature_name_printed := False
				until
					l_class_id_list.after
				loop
					l_class := system.class_of_id (l_class_id_list.item)
					if not l_feature_name_printed then
						l_feature := l_class.feature_of_rout_id (l_routine_id)
						io.put_string ("Feature: " + l_feature.feature_name + "%N")
						io.put_string ("Covariantly redefined in classes: ")
						l_feature_name_printed := True
					end
					io.put_string (l_class.name + ", ")
					l_class_id_list.forth
				end
				io.put_string ("%N%N")

				data.forth
			end
		end


feature {NONE} -- Implementation

	frozen data: HASH_TABLE [ARRAYED_LIST [INTEGER], INTEGER]
			-- Data storage:
			--  The hashtable holds a list of class ids indexed by routine ids

end
