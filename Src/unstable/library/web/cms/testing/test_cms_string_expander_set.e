note
	description: "Summary description for {TEST_SECURITY_HTML_FILTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TEST_CMS_STRING_EXPANDER_SET

inherit
	EQA_TEST_SET

	SHARED_EXECUTION_ENVIRONMENT
		undefine
			default_create
		end

feature -- Test routines

	test_env
		local
			exp: CMS_STRING_EXPANDER [STRING_32]
			text: STRING
		do
			create exp.make (create {CMS_STRING_ENVIRONMENT_RESOLVER})

			execution_environment.put ("bar", "FOO")

			text := "foo=${FOO-nothing}"
			exp.expand_string (text)
			assert ("foo", text.same_string ("foo=bar"))

			text := "user=${USER-anonymous}"
			exp.expand_string (text)
			assert ("user", not text.same_string ("user=anonymous"))

		end

	test_simple
		local
			exp: CMS_STRING_EXPANDER [STRING_8]
			text: STRING
		do
			create exp.make (table_resolver)

			text := "value=${TWO}"
			exp.expand_string (text)
			assert ("two", text.same_string ("value=2"))

			text := "value=${SMALLER}"
			exp.expand_string (text)
			assert ("smaller", text.same_string ("value=foo"))

			text := "value=${BIGGER}"
			exp.expand_string (text)
			assert ("bigger", text.same_string ("value=f-o-o-b-a-r"))

			text := "value=${TWO} and ${SMALLER} then ${BIGGER} ."
			exp.expand_string (text)
			assert ("two smaller bigger", text.same_string ("value=2 and foo then f-o-o-b-a-r ."))
		end

	test_default
		local
			exp: CMS_STRING_EXPANDER [STRING_8]
			text: STRING
		do
			create exp.make (table_resolver)

			text := "value=${TWO-two}"
			exp.expand_string (text)
			assert ("two", text.same_string ("value=2"))

			text := "value=${ONE-one}"
			exp.expand_string (text)
			assert ("one", text.same_string ("value=one"))

			text := "value=${ONE-one}"
			exp.expand_string (text)
			assert ("smaller", text.same_string ("value=one"))

			text := "value=${EMPTY:-empty}"
			exp.expand_string (text)
			assert ("empty", text.same_string ("value=empty"))


			text := "value=${nonEMPTY:-empty}"
			exp.expand_string (text)
			assert ("non empty", text.same_string ("value=..."))
		end

	test_syntax_error
		local
			exp: CMS_STRING_EXPANDER [STRING_8]
			text: STRING
		do
			create exp.make (table_resolver)

			text := "value=${TWO_"
			exp.expand_string (text)
			assert ("two", text.same_string ("value=${TWO_"))

			text := "value=$ {SMALLER}"
			exp.expand_string (text)
			assert ("smaller", text.same_string ("value=$ {SMALLER}"))

			text := "value=\${ESC}"
			exp.expand_string (text)
			assert ("bigger", text.same_string ("value=\${ESC}"))
		end

	test_unicode_simple
		local
			exp: CMS_STRING_EXPANDER [STRING_32]
			text: STRING_32
		do
			create exp.make (unicode_table_resolver)

			text := {STRING_32} "value=${TWO}"
			exp.expand_string (text)
			assert ("two", text.same_string ({STRING_32} "value=⏰⌛"))

			text := {STRING_32} "value=${SMALLER}"
			exp.expand_string (text)
			assert ("smaller", text.same_string ({STRING_32} "value=▣▣▣"))

			text := {STRING_32} "value=${BIGGER}"
			exp.expand_string (text)
			assert ("bigger", text.same_string ({STRING_32} "value=◉-◉-◉-◉-◉-◉"))

			text := {STRING_32} "value=${TWO} and ${SMALLER} then ${BIGGER} ."
			exp.expand_string (text)
			assert ("two smaller bigger", text.same_string ({STRING_32} "value=⏰⌛ and ▣▣▣ then ◉-◉-◉-◉-◉-◉ ."))
		end

	test_unicode_default
		local
			exp: CMS_STRING_EXPANDER [STRING_32]
			text: STRING_32
		do
			create exp.make (unicode_table_resolver)

			text := {STRING_32} "value=${TWO-two}"
			exp.expand_string (text)
			assert ("two", text.same_string ({STRING_32} "value=⏰⌛"))

			text := {STRING_32} "value=${ONE-▣▣▣}"
			exp.expand_string (text)
			assert ("one", text.same_string ({STRING_32} "value=▣▣▣"))

			text := {STRING_32} "value=${ONE-◉}"
			exp.expand_string (text)
			assert ("smaller", text.same_string ({STRING_32} "value=◉"))

			text := {STRING_32} "value=${EMPTY:-empty}"
			exp.expand_string (text)
			assert ("empty", text.same_string ({STRING_32} "value=empty"))


			text := {STRING_32} "value=${nonEMPTY:-empty}"
			exp.expand_string (text)
			assert ("non empty", text.same_string ({STRING_32} "value=..."))
		end

	test_unicode_syntax_error
		local
			exp: CMS_STRING_EXPANDER [STRING_32]
			text: STRING
			expected_text: STRING
		do
			create exp.make (unicode_table_resolver)

			text := {STRING_32} "value=${TWO_"
			exp.expand_string (text)
			assert ("two", text.same_string ({STRING_32} "value=${TWO_"))

			text := {STRING_32} "value=$ {SMALLER}"
			exp.expand_string (text)
			assert ("smaller", text.same_string ({STRING_32} "value=$ {SMALLER}"))

			text := {STRING_32} "value=\${ESC}"
			exp.expand_string (text)
			assert ("bigger", text.same_string ({STRING_32} "value=\${ESC}"))
		end

	test_mixed_simple
		local
			exp: CMS_STRING_EXPANDER [STRING_32]
			text: STRING_32
			t8: STRING_8
		do
			create exp.make (unicode_table_resolver)

			text := {STRING_32} "value=${TWO}"
			exp.expand_string (text)
			assert ("two", text.same_string ({STRING_32} "value=⏰⌛"))

			t8 := {STRING_32} "value=${TWO}"
			exp.expand_string (t8)
			assert ("two", t8.same_string ({UTF_CONVERTER}.utf_32_string_to_utf_8_string_8 ({STRING_32} "value=⏰⌛")))
		end

	table_resolver: CMS_STRING_TABLE_RESOLVER [STRING_8]
		once
			create Result.make (5)
			Result.force ({STRING_32} "2", "TWO")
			Result.force ({STRING_32} "foo", "SMALLER")
			Result.force ({STRING_32} "f-o-o-b-a-r", "BIGGER")
			Result.force ("", "EMPTY")
			Result.force ("...", "nonEMPTY")
		end

	unicode_table_resolver: CMS_STRING_TABLE_RESOLVER [STRING_32]
		once
			create Result.make (5)
			Result.force ({STRING_32} "⏰⌛", "TWO")
			Result.force ({STRING_32} "▣▣▣", "SMALLER")
			Result.force ({STRING_32} "◉-◉-◉-◉-◉-◉", "BIGGER")
			Result.force ({STRING_32} "", "EMPTY")
			Result.force ({STRING_32} "...", "nonEMPTY")
		end

note
	copyright: "2011-2024, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
