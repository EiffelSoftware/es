note
	description: "Summary description for {SVN_CLIENT_FOLDER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SVN_CLIENT_FOLDER

inherit
	SVN_CLIENT_ITEM
		redefine
			make_with_name,
			is_folder
		end

	LINKED_LIST[SVN_CLIENT_ITEM]
		undefine
			is_equal,
			copy
		end

create
	make_with_name

feature {NONE} -- Initialization

	make_with_name (a_name: STRING_32)
		do
			make
			Precursor (a_name)
		end

feature -- Element change

	recursively_add_items (a_items: LINKED_LIST[STRING_8])
		require
			a_items_not_void: a_items /= Void
		local
			l_svn_folder: SVN_CLIENT_FOLDER
			l_svn_file: SVN_CLIENT_FILE
			l_folder, l_item: STRING_8
			l_items_in_folder: LINKED_LIST[STRING_8]
			l_split_item: LIST[STRING_8]
			is_next_folder: BOOLEAN
		do
			from a_items.start
			until a_items.after
			loop
				l_item := a_items.item_for_iteration
				l_split_item := l_item.split ('/')
--				l_split_item.do_if (agent l_split_item.prune, agent (s: STRING_8): BOOLEAN do Result := s.count = 0 end)
				l_split_item.finish; l_split_item.remove -- Remove last item, because it is empty

				if l_split_item.count >= 1 then

					l_folder := l_split_item.i_th (1)
					create l_svn_folder.make_with_name(l_folder)

					-- Recursively create hierarchy into folder
					create l_items_in_folder.make
					from a_items.forth
					-- Pay attention to the evaluation order of the loop conditions
					until a_items.after or is_next_folder
					loop
						if a_items.item_for_iteration.starts_with (l_folder) then
							l_items_in_folder.extend (a_items.item_for_iteration.substring (l_folder.count + 2, a_items.item_for_iteration.count))
							a_items.forth
						else
							is_next_folder := True
						end
					end
					is_next_folder := False
					l_svn_folder.recursively_add_items (l_items_in_folder)
					extend (l_svn_folder)
				else
					create l_svn_file.make_with_name(a_items.item_for_iteration)
					extend (l_svn_file)
				end

				a_items.forth
			end
		end

feature -- Access

	is_folder: BOOLEAN
		do
			Result := True
		end

end
