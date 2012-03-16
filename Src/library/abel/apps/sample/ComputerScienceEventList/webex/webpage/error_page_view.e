indexing
	description: "Build a simple error page tells the problem encounted (based on a given template or the default by updating TITLE and CONTENT smart tags)"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "22.12.2007"
	revision: "$0.6$"

class
	ERROR_PAGE_VIEW
inherit
	HTML_TEMPLATE_VIEW

create
	make, make_default_error_page, build_default_not_found_page, build_default_not_enough_permission_page, build_default_database_not_connected, build_default_database_problem

feature -- Access

	make_default_error_page(title, content: STRING) is
			-- generate a simple error page with specified 'title' and 'content'
		do
			make_default
			set_error_title_and_content(title, content)
		end

	build_default_not_found_page  is
			-- generate a simple error page for 404 error
		local
		do
			make_default
			set_error_title_and_content("404 Not Found", "The URL you request is not found.")
		end

	build_default_not_enough_permission_page  is
			-- generate a simple error page for 403 error
		local
		do
			make_default
			set_error_title_and_content("403 Forbidden", "You are not authorized to access the requested URL.")
		end

	build_default_database_not_connected  is
			-- generate a simple error page for database connection failed
		local
		do
			make_default
			set_error_title_and_content("417 Expectation Failed", "Failed to connect to database.")
		end

	build_default_database_problem  is
			-- generate a simple error page for database problems
		local
		do
			make_default
			set_error_title_and_content("417 Expectation Failed", "Database problem encounted")
		end

	set_error_title_and_content(title, content: STRING) is
			-- replace TITLE, BODY smart tag with given text
		do
			replace_marker_with_string("TITLE", title)
			replace_marker_with_string("BODY", content)
		end

feature {NONE} -- Implementation
	make_default is
			-- template for the error page
		do
			image := "<html>%N%T<head>%N%T%T<title>{#TITLE#}</title>%N%T</head>%N%T<body>%N%T%T<h1>{#TITLE#}</h1>%N%T%T</p>{#BODY#}<p>%N%T</body>%N</html>"
		end

invariant
	invariant_clause: True -- Your invariant here
end
