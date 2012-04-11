indexing
	legal: "See notice at end of class."
	status: "See notice at end of class."
class
	HTML

inherit
	ANY
		undefine
			out
		end

create
	make

feature

	make is
		do
			create elements.make
			create body_attributes.make
			create stylesheet.make_create_read_write ("styles.css")
		end

feature -- Routines out

	out: STRING is
		do
			Result := "<HTML"
			Result.append (attributes_out)
			Result.append (">")
			Result.append ("%N")
			Result.append (head_out)
			Result.append ("%N")
			Result.append (body_out)
			Result.append ("%N</HTML>")

		end;

	body_out: STRING is
		do
			Result := ""
			Result.append ("%N<BODY")
			Result.append (body_attributes_out)
			Result.append (">")
			from
				elements.start
			until
				elements.after
			loop
				Result.append (elements.item)
				Result.append ("%N")
				elements.forth
			end;
			Result.append ("%N</BODY>")
		end;

	attributes_out, body_attributes_out: STRING is
		do
			Result := ""
		end

	head_out: STRING is
		do
			Result := ""
			Result.append ("<HEAD><TITLE>")
			if has_value (title_value) then
				Result.append (title_value)
			end
			Result.append ("</TITLE>")
			Result.append ("%N")
			Result.append ("<link href=%"styles.css%" rel=%"stylesheet%" type=%"text/css%" media=%"all%">")
			Result.append ("<META name=%"keywords%" content=%"")
			if has_value (keywords) then
				Result.append (keywords)
			end
			Result.append ("%">")
			Result.append("</HEAD>")
			Result.append ("%N")
		end;

feature -- Wipe out

	wipe_out is
		do
			elements.wipe_out
		end

feature -- Set

	set_title (s: STRING) is
		do
			if s /= Void then
				title_value := s.twin
			else
				title_value := Void
			end
		end

	set_keywords(k:STRING) is
			-- set keywords
		require
			k/=Void
		do
			keywords:=k
		end


feature -- Styles

	set_bgcolor(bg:STRING) is
			-- set the background color
		require
			bg/=Void
		do
			body_attributes.extend ("background-color:"+ bg + ";")
		end

	set_text_color(te:STRING) is
			-- set text color
		require
			te/=Void
		do
			body_attributes.extend ("color:"+te+";")
		end

--	set_link_color(li:STRING) is
--			-- set link color
--		require
--			li/=Void
--		do
--			body_attributes.extend (li)
--		end

--	set_vlink_color(vli:STRING) is
--			-- set vlink color
--		require
--			vli/=Void
--		do
--			body_attributes.extend (vli)
--		end

--	set_alink_color(ali:STRING) is
--			-- set alink color
--		require
--			ali/=Void
--		do
--			body_attributes.extend (ali)
--		end

feature {NONE} -- Stylesheet

	write_stylesheet is
			-- write stylesheet
		do
			stylesheet.put_string ("body {")
			stylesheet.put_new_line
			from
				body_attributes.start
			until
				body_attributes.after
			loop
				stylesheet.put_string (body_attributes.item)
				stylesheet.put_new_line
				body_attributes.forth
			end
		end


feature -- Add new elements

	add_element (an_element: STRING) is
		require
			an_element /= Void
		do
			elements.extend (an_element.twin)
		end

feature {NONE}

    has_value(s: STRING): BOOLEAN is
            -- Has the attribute 's' a value ?
        do
            if s = Void or else s.is_equal ("") then
                Result := False
            else
                Result := True
            end
        end

feature {NONE} -- Globals

	title_value: STRING
	keywords:STRING
	elements: LINKED_LIST [STRING]
	body_attributes: LINKED_LIST[STRING]
	stylesheet:PLAIN_TEXT_FILE;

indexing
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class HTML
