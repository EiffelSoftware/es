note
	description: "Iterate over AST to collect strings for spell check."
	date: "$Date$"
	revision: "$Revision$"

class
	ES_SPELL_CHECK_AST_VISITOR

inherit

	AST_ROUNDTRIP_ITERATOR
		redefine
			process_break_as,
			process_string_as,
			process_verbatim_string_as,
			process_class_as,
			process_formal_dec_as,
			process_rename_as,
			process_feature_as,
			process_type_dec_as,
			process_indexing_clause_as,
			process_tagged_as,
			process_iteration_as,
			process_object_test_as
		end

	SC_LANGUAGE_UTILITY
		export
			{NONE} all
		end

	SHARED_SERVER
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Create empty collection.
		do
			create {LINKED_LIST [STRING_32]} words.make
			create {LINKED_LIST [LOCATION_AS]} bases.make
		ensure
			empty: words.is_empty and bases.is_empty
		end

feature -- Collection

	reset_with_root (root: CLASS_AS)
			-- Prepare for another visit with class `root' as context
			-- and reset all collected information.
		require
			root_exists: root /= Void
		do
				-- Information not in AST like comments needed.
			setup (root, match_list_server.item (root.class_id), True, True)
			words.wipe_out
			bases.wipe_out
		ensure
			empty: words.is_empty and bases.is_empty
		end

	count: INTEGER
			-- Number of collected words. They do not need to be unique.
		do
			Result := words.count
		ensure
			correct: Result = words.count
		end

	words: LIST [READABLE_STRING_32]
			-- Collection of words so far.

	bases: LIST [LOCATION_AS]
			-- Places in source code corresponding to words.

feature {NONE} -- Implementation

	Word_length_limit: INTEGER = 3
			-- Words shorter than this are not collected.

	collect_text (text: READABLE_STRING_32; origin: LOCATION_AS)
			-- Remember words of `text' rooted at `origin'.
		require
			text_exists: text /= Void
			origin_exists: origin /= Void
		local
			length, base: INTEGER
			word: STRING_32
			word_base: LOCATION_AS
		do
			across
				words_of_text (text) as limit
			loop
				length := limit.item.length
				if length >= Word_length_limit then
					base := limit.item.base
					word := text.substring (base, base + length - 1)
					words.extend (word)
						-- Assuming on one line only. TODO.
					create word_base.make (origin.line, origin.column + base - 1, origin.position + base - 1, length)
					bases.extend (word_base)
				end
			end
		ensure
			count_monotone: count >= old count
		end

	collect_identifier (identifier: READABLE_STRING_32; origin: LOCATION_AS)
			-- Remember language `identifier' rooted at `origin'.
		require
			identifier_exists: identifier /= Void
			origin_exists: origin /= Void
		do
				-- Assuming recommended Eiffel style for identifiers
				-- with underscore separating parts.
			collect_text (identifier, origin)
		ensure
			count_monotone: count >= old count
		end

feature {NONE} -- Collecting

	process_break_as (node: BREAK_AS)
			-- <Precursor>
		local
			origin: LOCATION_AS
		do
				-- Collect comments. Hence roundtrip.
			across
				node.extract_comment as comment_line
			loop
				if attached comment_line.item as comment and then attached comment.content_32 as string then
					create origin.make (comment.line, comment.column, comment.position, string.count)
					collect_text (string, origin)
				end
			end
			Precursor (node)
		end

	process_string_as (node: STRING_AS)
			-- <Precursor>
		local
			origin: LOCATION_AS
		do
			origin := node.start_location
				-- Skip string delimiter.
			create origin.make (origin.line, origin.column + 1, origin.position, origin.location_count)
			collect_text (node.value_32, origin)
			Precursor (node)
		end

	process_verbatim_string_as (node: VERBATIM_STRING_AS)
			-- <Precursor>
		local
			origin: LOCATION_AS
		do
			origin := node.start_location
				-- Again, skip string delimiter.
			create origin.make (origin.line, origin.column + 2, origin.position, origin.location_count)
			collect_text (node.value_32, origin)
			Precursor (node)
		end

	process_class_as (node: CLASS_AS)
			-- <Precursor>
		do
			if attached node.class_name as name then
				collect_identifier (name.name_32, name.start_location)
			end
			Precursor (node)
		end

	process_formal_dec_as (node: FORMAL_DEC_AS)
			-- <Precursor>
		do
				-- Check name of formal generic type.
			if attached node.name as name then
				collect_identifier (name.name_32, name.start_location)
			end
			Precursor (node)
		end

	process_rename_as (node: RENAME_AS)
			-- <Precursor>
		do
				-- Check renamed feature.
			if attached node.new_name as name then
				collect_identifier (name.visual_name_32, name.start_location)
			end
			Precursor (node)
		end

	process_feature_as (node: FEATURE_AS)
			-- <Precursor>
		do
				-- Find all synomyms.
			across
				node.feature_names as name
			loop
				collect_identifier (name.item.visual_name_32, name.item.start_location)
			end
			Precursor (node)
		end

	process_type_dec_as (node: TYPE_DEC_AS)
			-- <Precursor>
		do
			across
				node.id_list as identity
			loop
					-- TODO: find exact place of each individual name.
				collect_identifier (node.names_heap.item_32 (identity.item), node.start_location)
			end
			Precursor (node)
		end

	process_indexing_clause_as (node: INDEXING_CLAUSE_AS)
			-- <Precursor>
		do
			across
				node as index
			loop
				if attached index.item.tag as tag then
					collect_identifier (tag.name_32, tag.start_location)
				end
			end
			Precursor (node)
		end

	process_tagged_as (node: TAGGED_AS)
			-- <Precursor>
		do
			if attached node.tag as tag then
				collect_identifier (tag.name_32, tag.start_location)
			end
			Precursor (node)
		end

	process_iteration_as (node: ITERATION_AS)
			-- <Precursor>
		do
				-- Check identifier introduced by across loop in Eiffel.
				-- Both expression and instruction kind of loop is visited.
			collect_identifier (node.identifier.name_32, node.identifier.start_location)
			Precursor (node)
		end

	process_object_test_as (node: OBJECT_TEST_AS)
			-- <Precursor>
		do
				-- Check identifier introduced by test for attached.
			if attached node.name as name then
				collect_identifier (name.name_32, name.start_location)
			end
			Precursor (node)
		end

invariant
	counts_equal: words.count = bases.count
	word_limit_satisfied: across words as word all word.item.count >= Word_length_limit end

note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
