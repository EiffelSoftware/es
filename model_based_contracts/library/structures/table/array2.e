indexing

	description:
		"Two-dimensional arrays"
	legal: "See notice at end of class."

	status: "See notice at end of class."
	names: array2, matrix, table;
	representation: array;
	access: index, row_and_column, membership;
	size: resizable;
	contents: generic;
	model: matrix, additional_space, resizable, extendible, prunable, object_comparison;
	date: "$Date$"
	revision: "$Revision$"

class ARRAY2 [G] inherit

	ARRAY [G]
		rename
			make as array_make,
			item as array_item,
			put as array_put,
			force as array_force,
			resize as array_resize,
			wipe_out as array_wipe_out,
			relation as sequence
		export
			{NONE}
				array_make, array_force,
				array_resize, array_wipe_out
			{ARRAY2}
				array_put, array_item
			{ANY}
				copy, is_equal, area, to_c
		redefine
			sequence
		end

create

	make

feature -- Initialization

	make (nb_rows, nb_columns: INTEGER) is
			-- Create a two dimensional array which has `nb_rows'
			-- rows and `nb_columns' columns,
			-- with lower bounds starting at 1.
		require
			not_flat: nb_rows > 0
			not_thin: nb_columns > 0
		do
			height := nb_rows
			width := nb_columns
			array_make (1, height * width)
		ensure
			new_count: count = height * width
		-- ensure: model
			matrix_height_effect: matrix.count = nb_rows
			matrix_width_effect: matrix.any_element.count = nb_columns
			matrix_range_effect: matrix.for_all (agent {MML_SEQUENCE [G]}.for_all (agent is_default))
			additional_space_effect: additional_space = ((nb_rows * nb_columns) // 2).max (minimal_increase)
			resizable_effect: resizable = True
			extendible_effect: extendible = False
			prunable_effect: prunable = False
			object_comparison_effect: object_comparison = False
		end

	initialize (v: G) is
			-- Make each entry have value `v'.
		local
			row, column: INTEGER
		do
			from
				row := 1
			until
				row > height
			loop
				from
					column := 1
				until
					column > width
				loop
					put (v, row, column)
					column := column + 1
				end
				row := row + 1
			end
		ensure
		-- ensure: model
			matrix_effect: matrix.for_all (agent {MML_SEQUENCE [G]}.for_all (agent equal_elements (v, ?)))
		end

feature -- Access

	item alias "[]" (row, column: INTEGER): G assign put is
			-- Entry at coordinates (`row', `column')
		require
			valid_row: (1 <= row) and (row <= height)
			valid_column: (1 <= column) and (column <= width)
		do
			Result := array_item ((row - 1) * width + column)
		ensure
		-- ensure: model
			definition: Result = matrix.item (row).item (column)
		end

feature -- Measurement

	height: INTEGER
			-- Number of rows
		attribute
		ensure
		-- ensure: model
			definition: Result = matrix.count
		end

	width: INTEGER
			-- Number of columns
		attribute
		ensure
		-- ensure: model
			definition: Result = matrix.any_element.count
		end

feature -- Element change

	put (v: like item; row, column: INTEGER) is
			-- Assign item `v' at coordinates (`row', `column').
		require
			valid_row: 1 <= row and row <= height
			valid_column: 1 <= column and column <= width
		do
			array_put (v, (row - 1) * width + column)
		ensure
		-- ensure: model
			matrix_effect: matrix |=| old (matrix.replaced_at (matrix.item (row).replaced_at (v, column), row))
		end

	force (v: like item; row, column: INTEGER) is
			-- Assign item `v' at coordinates (`row', `column').
			-- Resize if necessary.
		require
			row_large_enough: 1 <= row
			column_large_enough: 1 <= column
		do
			resize (row, column)
			put (v, row, column)
		ensure
		-- ensure: model
			matrix_count_effect: matrix.count |=| row.max (old matrix.count)
			row_count_effect: matrix.any_element.count |=| column.max (transposed (old matrix).count)
			matrix_i_j_effect: matrix.item (row).item (column) = v
			matrix_old_rows_effect: transposed (matrix.domain_restricted (old matrix.domain).domain_anti_restricted_by (row)).domain_restricted (transposed (old matrix).domain) |=| transposed (old (matrix.domain_anti_restricted_by (row)))
			matrix_old_columns_effect: row <= old matrix.count implies matrix.item (row).domain_anti_restricted_by (column) |=| (old matrix).item (row).domain_anti_restricted_by (column)
			matrix_new_i_row_effect: matrix.item (row).domain_anti_restricted (transposed (old matrix).domain).domain_anti_restricted_by (column).range.for_all (agent is_default)
			matrix_new_j_column_effect: matrix.domain_anti_restricted_by (row).domain_anti_restricted (old matrix.domain).range.for_all (agent (s: MML_SEQUENCE [G]; c: INTEGER): BOOLEAN do Result := is_default (s.item (c)) end (?, column))
			matrix_new_rows_effect: matrix.domain_anti_restricted (old matrix.domain).domain_anti_restricted_by (row).range.for_all (agent {MML_SEQUENCE [G]}.for_all (agent is_default))
			matrix_new_columns_effect: matrix.domain_anti_restricted_by (row).range.for_all (agent (s: MML_SEQUENCE [G]; d: MML_SET [INTEGER]): BOOLEAN do Result := s.domain_anti_restricted (d).range.for_all (agent is_default) end (?, transposed (old matrix).domain))
		end

feature -- Removal

	wipe_out is
			-- Remove all items.
		do
			height := 0
			width := 0
			lower := 1
			upper := 0
			discard_items
		ensure
		-- ensure: model
			matrix_effect: matrix.is_empty
		end

feature -- Resizing

	resize (nb_rows, nb_columns: INTEGER) is
			-- Rearrange array so that it can accommodate
			-- `nb_rows' rows and `nb_columns' columns,
			-- without losing any previously
			-- entered items, nor changing their coordinates;
			-- do nothing if not possible.
		require
			valid_row: nb_rows >= 1
			valid_column: nb_columns >= 1
		local
			i, new_height: INTEGER
			in_new, in_old: INTEGER
			new: like Current
		do
			if nb_rows > height then
				new_height := nb_rows
			else
				new_height := height
			end
			if nb_columns > width then
				create new.make (new_height, nb_columns)
				from
					in_old := 1
					in_new := 1
				until
					i = height
				loop
					i := i + 1
					transfer (new, in_old, in_new, width)
					in_new := in_new + nb_columns
					in_old := in_old + width
				end
				width := nb_columns
				height := new_height
				upper := width * height
				area := new.area
			elseif new_height > height then
				create new.make (new_height, width)
				transfer (new, 1, 1, width * height)
				height := new_height
				upper := width * height
				area := new.area
			end
		end

feature {NONE} -- Implementation

	transfer (new: like Current; in_old, in_new, nb: INTEGER) is
			-- Copy `nb' items, starting from `in_old',
			-- to `new', starting from `in_new'.
			-- Do not copy out_of_bounds items.
		local
			i, j: INTEGER
		do
			from
				i := in_old
				j := in_new
			until
				i = in_old + nb
			loop
				new.array_put (array_item (i), j)
				i := i + 1
				j := j + 1
			end
		end

feature -- Model
	matrix: MML_SEQUENCE [MML_SEQUENCE [G]] is
			-- Matrix representing container contents
		local
			i, j: INTEGER
			s: MML_SEQUENCE [G]
		do
			create {MML_DEFAULT_SEQUENCE [MML_SEQUENCE [G]]} Result
			from
				i := 1
			until
				i > height
			loop
				create {MML_DEFAULT_SEQUENCE [G]} s
				from
					j := 1
				until
					j > width
				loop
					s := s.extended (item (i, j))
					j := j + 1
				end
				Result := Result.extended (s)
				i := i + 1
			end
		end

	sequence: MML_SEQUENCE [G] is
			-- Sequential representation of `Current'
		local
			i, j: INTEGER
		do
			create {MML_DEFAULT_SEQUENCE [G]} Result
			from
				i := 1
			until
				i > count
			loop
				Result := Result.extended (array_item (i))
				i := i + 1
			end
		end

	transposed (m: MML_RELATION [INTEGER, MML_RELATION [INTEGER, G]]): MML_RELATION [INTEGER, MML_RELATION [INTEGER, G]] is
			-- Transposed version of `m'
		require
			m.is_function
			not m.is_empty implies m.any_item.second.is_function
		local
			i, j: INTEGER
			rows, cols: MML_SEQUENCE [INTEGER]
			column: MML_RELATION [INTEGER, G]
		do
			create {MML_DEFAULT_RELATION [INTEGER, MML_RELATION [INTEGER, G]]} Result
			if not m.is_empty then
				rows := m.domain.randomly_ordered
				cols := m.any_item.second.domain.randomly_ordered
				from
					j := 1
				until
					j > cols.count
				loop
					create {MML_DEFAULT_RELATION [INTEGER, G]} column
					from
						i := 1
					until
						i > rows.count
					loop
						column := column.extended (create {MML_DEFAULT_PAIR [INTEGER, G]}.make_from (rows.item (i), m.image_of (rows.item (i)).any_item.image_of (cols.item (j)).any_item))
						i := i + 1
					end
					Result := Result.extended (create {MML_DEFAULT_PAIR [INTEGER, MML_RELATION [INTEGER, G]]}.make_from (cols.item (j), column))
					j := j + 1
				end
			end
		ensure
			domain_definition_empty: m.is_empty implies Result.is_empty
			domain_definition_not_empty: not m.is_empty implies Result.domain |=| m.any_item.second.domain
			range_domain_definition_not_empty: not m.is_empty implies Result.range.for_all (agent (s: MML_RELATION [INTEGER, G]): BOOLEAN do Result := (s.domain |=| matrix.first.domain) end)
			range_range_definition_not_empty: not m.is_empty implies Result.for_all (
				agent (p1: MML_PAIR [INTEGER, MML_RELATION [INTEGER, G]]; m1: MML_RELATION [INTEGER, MML_RELATION [INTEGER, G]]): BOOLEAN
					do
						Result := p1.second.for_all (
							agent (p2: MML_PAIR [INTEGER, G]; m2: MML_RELATION [INTEGER, MML_RELATION [INTEGER, G]]; j2: INTEGER): BOOLEAN
								do
									Result := p2.second = m2.image_of (p2.first).any_item.image_of (j2).any_item
								end (?, m1, p1.first)
							)
					end (?, m)
			)
		end
invariant

	items_number: count = width * height

-- invariant: model
	is_matrix: matrix.for_all (agent (s: MML_SEQUENCE [G]): BOOLEAN do Result := (s.count = matrix.first.count) end)
	matrix_sequence_constraint: sequence.set_for_all (
		agent (p: MML_PAIR [INTEGER, G]): BOOLEAN
			do
				Result := p.second = matrix.item ((p.first - 1) // matrix.any_element.count + 1).item ((p.first - 1) \\ matrix.any_element.count + 1)
			end
		)

indexing
	library:	"EiffelBase: Library of reusable components for Eiffel."
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"







end -- class ARRAY2



