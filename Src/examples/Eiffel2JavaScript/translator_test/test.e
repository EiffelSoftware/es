note
	description : "Test the JavaScript compiler"
	author      : "Alexandru Dima <alex.dima@gmail.com>"
	copyright   : "Copyright (C) 2011, Alexandru Dima"
	date        : "$Date$"
	revision    : "$Revision$"

deferred class
	TEST

inherit
	JS_OBJECT

feature -- Access

feature {NONE} -- Implementation

	expects_exception: BOOLEAN
	current_test_failed: BOOLEAN
	current_test_name: STRING
	assertions: INTEGER

	invoke_test (a_test_name: attached STRING; a_test: attached PROCEDURE[ANY, attached TUPLE])
		local
			has_exception: BOOLEAN
			l_expects_exception: BOOLEAN
			l_current_test_failed: BOOLEAN
			l_assertions: INTEGER
		do
			assertions := l_assertions
			expects_exception := l_expects_exception
			current_test_failed := l_current_test_failed
			current_test_name := a_test_name

			if not has_exception then
				a_test.call([])
			end

			if has_exception and not expects_exception then
				fail ("An unexpected exception has been thrown")
			end
			if expects_exception and not has_exception then
				fail ("An exception was expected, but was not thrown")
			end
			if expects_exception and has_exception then
				assertions := assertions + 1
			end
--			if not expects_exception and not has_exception then
--				assertions := assertions + 1
--			end
			if not current_test_failed then
				succeed
			end
		rescue
			l_expects_exception := expects_exception
			l_current_test_failed := current_test_failed
			l_assertions := assertions
			has_exception := true
			retry
		end

	assert (a_expression: BOOLEAN)
		do
			if not a_expression then
				fail ("Assertion does not hold")
			else
				assertions := assertions + 1
			end
		end

	fail (a_reason: attached STRING)
		local
			l_div: JS_HTML_DIV_ELEMENT
			l_foo: JS_NODE
			l_current_test_name: STRING
		do
			l_current_test_name := current_test_name
			check l_current_test_name /= Void end

			current_test_failed	:= true
			create l_div.make
			l_div.style.background_color := "#f88"
			l_div.style.margin_top := "2px"
			l_foo := l_div.append_child (doc.create_text_node ("FAILED: " + class_name + "." + l_current_test_name + " - " + a_reason))
			l_foo := body.append_child (l_div)
			console.info ("FAILED: " + class_name + "." + l_current_test_name + " - " + a_reason)
		end

	succeed
		local
			l_div: JS_HTML_DIV_ELEMENT
			l_foo: JS_NODE
			l_current_test_name: STRING
		do
			l_current_test_name := current_test_name
			check l_current_test_name /= Void end

			create l_div.make
			l_div.style.background_color := "#8f8"
			l_div.style.margin_top := "2px"
			l_foo := l_div.append_child (doc.create_text_node ("PASSED: " + class_name + "." + l_current_test_name + " : " + assertions.out + " assertions"))
			l_foo := body.append_child (l_div)
		end

end
