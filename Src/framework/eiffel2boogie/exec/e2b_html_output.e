note
	description: "HTML output of verification."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_HTML_OUTPUT

inherit

	OUTPUT_WINDOW
		redefine
			add_class,
			add_feature,
			add_manifest_string
		end

feature

	print_verification_result (r: E2B_RESULT)
			-- Print `r' in HTML format.
		do
			if r.has_execution_errors then
				add ("Boogie verification failed!")
				add_new_line
				add_new_line
				across r.execution_errors as i loop
					add (i.item.title)
					add (": ")
					add (i.item.message)
				end
			else
				open_style ("table", table_style)
				open ("thead")
				open_style ("tr", tr_header_style)
				open ("th")
				add ("Feature")
				close ("th")
				open ("th")
				add ("Result")
				close ("th")
				close ("tr")
				close ("thead")
				open ("tbody")
				across r.procedure_results as i loop
					if attached {E2B_SUCCESSFUL_VERIFICATION} i.item as l_success then
						if l_success.original_errors /= Void and then not l_success.original_errors.is_empty then
							open_style ("tr", tr_twostep_style)
						else
							open_style ("tr", tr_success_style)
						end
						print_successful_verification (l_success)
					elseif attached {E2B_FAILED_VERIFICATION} i.item as l_failure then
						open_style ("tr", tr_failed_style)
						print_failed_verification (l_failure)
					else
						check False end
					end
					close ("tr")
				end
				close ("tbody")
				close ("table")
			end
		end

	print_successful_verification (a_success: E2B_SUCCESSFUL_VERIFICATION)
			-- Print successful verification information.
		do
			print_feature_information (a_success)
			open_style ("td", td_info_style)
			if a_success.original_errors = Void or else a_success.original_errors.is_empty then
				add ("Successfully verified.")
				add_new_line
			else
					-- Two-step verification result
				add ("Successfully verified after inlining.")
				add_new_line
				if a_success.suggestion /= Void then
					add (a_success.suggestion)
					add_new_line
				end
				add ("Original errors:")
				add_new_line
				across a_success.original_errors as i loop
					if i.cursor_index = 1 then
						add_new_line
					else
						add ("--------------------------------------")
						add_new_line
					end
					i.item.multi_line_message (Current)
					add_new_line
				end
			end
			close ("td")
		end

	print_failed_verification (a_failure: E2B_FAILED_VERIFICATION)
			-- Print failed verifcation information.
		do
			print_feature_information (a_failure)
			open_style ("td", td_info_style)
			across a_failure.errors as i loop
				if i.cursor_index = 1 then
				else
					add ("--------------------------------------")
					add_new_line
				end
				i.item.multi_line_message (Current)
				add_new_line
			end
			close ("td")
		end

	print_feature_information (a_proc: E2B_PROCEDURE_RESULT)
			-- Print feature information.
		do
			open_style ("td", td_name_style)
			open ("strong")
			add_class (a_proc.eiffel_class.original_class)
			add (".")
			add_feature (a_proc.eiffel_feature.e_feature, a_proc.eiffel_feature.feature_name_32)
			close ("strong")
			close ("td")
		end

	put_new_line
			-- <Precursor>
		do
			io.put_string ("<br/>")
			io.put_new_line
		end

	put_string (s: READABLE_STRING_GENERAL)
			-- <Precursor>
		local
			t: UTF_CONVERTER
			s8: STRING_8
		do
			s8 := t.string_32_to_utf_8_string_8 (s.as_string_32)
			s8.replace_substring_all ("<", "&lt;")
			s8.replace_substring_all (">", "&gt;")
			s8.replace_substring_all ("%"", "&quot;")
			io.put_string (s8)
		end

	put_string_no_encoding (s: STRING)
		do
			io.put_string (s)
		end

	open (a_tag: STRING)
			-- Open `a_tag'.
		do
			put_string_no_encoding ("<" + a_tag + ">")
		end

	open_style (a_tag: STRING; a_style: STRING)
			-- Open `a_tag'.
		do
			put_string_no_encoding ("<" + a_tag + " style=%"" + a_style + "%">")
		end

	close (a_tag: STRING)
			-- Close `a_tag'.
		do
			put_string_no_encoding ("</" + a_tag + ">")
		end

	add_class (class_i: CLASS_I)
		do
			open_style ("span", "color:blue")
			put_string (class_i.name.as_upper)
			close ("span")
		end

	add_feature (feat: E_FEATURE; str: READABLE_STRING_GENERAL)
		do
			open_style ("span", "color:green")
			put_string (str)
			close ("span")
		end

	add_manifest_string (s: READABLE_STRING_GENERAL)
		do
			open_style ("span", "color:orange")
			put_string (s)
			close("span")
		end

feature -- Styles

	table_style: STRING = "width:100%%"
	tr_header_style: STRING = "background-color:black;color:white"
	tr_success_style: STRING = "background-color: #dfd"
	tr_twostep_style: STRING = "background-color:#fe6"
	tr_failed_style: STRING = "background-color:#fdd"
	td_name_style: STRING = "padding: 5px; padding-right:15px"
	td_info_style: STRING = "width: 100%%"


end
