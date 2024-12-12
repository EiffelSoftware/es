note
	description: "[
			String expander facility for the CMS.
			
			-- Supporting:
			-- 	${VARNAME}          -> value of VAR
			-- 	${VARNAME:-default} -> value of VAR if set and non-empty, otherwise default
			-- 	${VARNAME-default}  -> value of VAR if set, otherwise default
		]"
	date: "$Date$"
	revision: "$Revision$"

class
	CMS_STRING_EXPANDER [G -> READABLE_STRING_GENERAL]

create
	make

feature {NONE} -- Initialization

	make (r: like resolver)
		do
			resolver := r
		end

feature -- Access

	has_error: BOOLEAN
		do
			Result := attached error_handler as h and then h.has_error
		end

	reset_error
		do
			if attached error_handler as h then
				h.reset
			end
		end

	error_handler: detachable ERROR_HANDLER

feature -- Conversion

	expand_string (a_text: STRING_GENERAL)
		do
			if attached {STRING_32} a_text as t32 then
				expand_string_32 (t32)
			elseif attached {STRING_8} a_text as t8 then
				expand_string_8 (t8)
			else
				check known_string: False end
			end
		end

	expand_string_8 (a_text: STRING_8)
		local
			vn: STRING_8
			i,j,n,k,m: INTEGER
			c, prev: CHARACTER_8
		do
			reset_error
			from
				i := 1
				n := a_text.count
			until
				i > n
			loop
				c := a_text [i]
				if c = '$' and prev /= '\' and i < n then
					if a_text [i + 1] = '{' then
						j := a_text.index_of ('}', i + 2)
						if j > i then
							vn := a_text.substring (i + 2, j - 1)
							if attached resolved_string_8_item (vn) as v then
								m := vn.count + 3 -- Include ${  and }
								if v.count > m then
									from
										k := 1
									until
										k > m
									loop
										a_text.put (v [k], i + k - 1)
										k := k + 1
									end
									a_text.insert_string (v.substring (k, v.count), i + k - 1)
									i := i + v.count
								else
									from
										k := 1
									until
										k > v.count
									loop
										a_text.put (v [k], i + k - 1)
										k := k + 1
									end
									a_text.remove_substring (i + k - 1, j)
									i := i + v.count
								end
								n := n + v.count - m
							else
								-- Skip
								i := j
							end
						else
							-- Nothing to do
						end
					end
				else
				end
				i := i + 1
				prev := c
			end
		end

	expand_string_32 (a_text: STRING_32)
		local
			vn: STRING_32
			i,j,n,k,m: INTEGER
			c, prev: CHARACTER_32
		do
			reset_error
			from
				i := 1
				n := a_text.count
			until
				i > n
			loop
				c := a_text [i]
				if c = '$' and prev /= '\' and i < n then
					if a_text [i + 1] = '{' then
						j := a_text.index_of ('}', i + 2)
						if j > i then
							vn := a_text.substring (i + 2, j - 1)
							if attached resolved_string_32_item (vn) as v then
								m := vn.count + 3 -- Include ${  and }
								if v.count > m then
									from
										k := 1
									until
										k > m
									loop
										a_text.put (v [k], i + k - 1)
										k := k + 1
									end
									a_text.insert_string (v.substring (k, v.count), i + k - 1)
									i := i + v.count
								else
									from
										k := 1
									until
										k > v.count
									loop
										a_text.put (v [k], i + k - 1)
										k := k + 1
									end
									a_text.remove_substring (i + k - 1, j)
									i := i + v.count
								end
								n := n + v.count - m
							else
								-- Skip
								i := j
							end
						else
							-- Nothing to do
						end
					end
				else
				end
				i := i + 1
				prev := c
			end
		end

feature {NONE} -- Internal

	resolver: CMS_STRING_RESOLVER [G]

	value (n: READABLE_STRING_GENERAL): detachable G
		do
			Result := resolver.value (n)
		end

	resolved_string_8_item (a_expr: STRING_8): detachable STRING_8
			-- Expand `a_expr`
			-- Supporting:
			-- 	${VARNAME}          -> value of VAR
			-- 	${VARNAME:-default} -> value of VAR if set and non-empty, otherwise default
			-- 	${VARNAME-default}  -> value of VAR if set, otherwise default
		local
			i,j: INTEGER
			vn: STRING_8
			dft: detachable STRING_8
			c: CHARACTER_32
			l_is_set_and_non_empty: BOOLEAN
			err: BOOLEAN
		do
			dft := Void
			vn := a_expr

			i := a_expr.index_of (':', 1)
			if i > 1 then
				l_is_set_and_non_empty := True
				c := a_expr [i + 1]
				vn := a_expr.substring (1, i - 1)
				dft := a_expr.substring (i + 2, a_expr.count)
				err := c /= '-'
			else
				j := a_expr.index_of ('-', 1)
				if j > 0 then
					vn := a_expr.substring (1, j - 1)
					dft := a_expr.substring (j + 1, a_expr.count)
				end
			end
			if err then
					-- TODO: handle error ...
			elseif attached value (vn) as v then
				if l_is_set_and_non_empty and v.is_empty then
					Result := dft
				else
					Result := value_to_string_8 (v)
				end
			else
				Result := dft
			end
		end

	resolved_string_32_item (a_expr: STRING_32): detachable STRING_32
			-- Expand `a_expr`
			-- Supporting:
			-- 	${VARNAME}          -> value of VAR
			-- 	${VARNAME:-default} -> value of VAR if set and non-empty, otherwise default
			-- 	${VARNAME-default}  -> value of VAR if set, otherwise default
		local
			i,j: INTEGER
			vn: STRING_32
			dft: detachable STRING_32
			c: CHARACTER_32
			l_is_set_and_non_empty: BOOLEAN
			err: BOOLEAN
		do
			dft := Void
			vn := a_expr

			i := a_expr.index_of (':', 1)
			if i > 1 then
				l_is_set_and_non_empty := True
				c := a_expr [i + 1]
				vn := a_expr.substring (1, i - 1)
				dft := a_expr.substring (i + 2, a_expr.count)
				err := c /= '-'
			else
				j := a_expr.index_of ('-', 1)
				if j > 0 then
					vn := a_expr.substring (1, j - 1)
					dft := a_expr.substring (j + 1, a_expr.count)
				end
			end
			if err then
					-- TODO: handle error ...
			elseif attached value (vn) as v then
				if l_is_set_and_non_empty and v.is_empty then
					Result := dft
				else
					Result := v.to_string_32
				end
			else
				Result := dft
			end
		end

feature {NONE} -- Implementation

	value_to_string_8 (s: G): STRING_8
		local
			utf: expanded UTF_CONVERTER
		do
			if attached {READABLE_STRING_8} s as s8 then
				Result := s8.to_string_8
			else
				Result := utf.utf_32_string_to_utf_8_string_8 (s)
			end
		end

	report_error (m: detachable READABLE_STRING_GENERAL)
		local
			h: like error_handler
		do
			h := error_handler
			if h = Void then
				create h.make
				error_handler := h
			end
			h.add_custom_error (-1, "string expander error", m)
		end

;note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
