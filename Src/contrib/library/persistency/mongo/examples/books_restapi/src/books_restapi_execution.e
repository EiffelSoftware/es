note
	description: "[
				application execution
			]"
	date: "$Date: 2016-10-21 10:45:18 -0700 (Fri, 21 Oct 2016) $"
	revision: "$Revision: 99331 $"

class
	BOOKS_RESTAPI_EXECUTION

inherit

	WSF_ROUTED_EXECUTION
		redefine
			initialize
		end

	WSF_URI_HELPER_FOR_ROUTED_EXECUTION

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_EXECUTION

	WSF_RESOURCE_HANDLER_HELPER

create
	make

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			initialize_router
			create mongodb_connection
		end

 	setup_router
 			--  Setup `router'
 		local
 			fhdl: WSF_FILE_SYSTEM_HANDLER
 		do
 				 -- uri/uri templates.
 			map_uri_agent ("/", agent handle_home_page, router.methods_GET)
 			map_uri_agent ("/books", agent handle_collection, router.methods_get_post)
 			map_uri_template_agent ("/books/{id}", agent handle_item, router.methods_get_put_delete)

 			create fhdl.make_hidden ("www")
 			fhdl.set_directory_index (<<"index.html">>)
 			router.handle ("/", fhdl, router.methods_GET)
 		end

	mongodb_connection: detachable MONGODB_CONNECTION

 feature  -- Handle HTML pages

 	handle_home_page (req: WSF_REQUEST; res: WSF_RESPONSE)
 		local
			l_books_mgr: BOOKS_MANAGER
			b: BOOK
			html: STRING_8
			p: WSF_HTML_PAGE_RESPONSE
 		do
 			create l_books_mgr.make (mongodb_client)
 			create html.make_empty
 			if
 				attached l_books_mgr.find_documents as docs and then
 				docs.is_empty
 			then
 				create b.make ("Eiffel MongoDB", "Tutorial: how to use MongoDB with Eiffel", "https://www.eiffel.org/theme/responsive-eiffel-org/images/logo.png")
 				l_books_mgr.insert_document (b)
	 			html.append ("Initialization: added one new book")
 			end
			html.append ("<ul>")
			html.append ("<li><a href=%"/books%">List of books</a></li>")
			html.append ("</ul>")

 			create p.make
 			p.set_body (html)
 			p.set_title ("Eiffel MongoDB Books example")
 			res.send (p)
 		end

	handle_collection (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_books_mgr: BOOKS_MANAGER
			jobj: JSON_OBJECT
			jlinks: JSON_OBJECT
		do
			if attached req.http_host as l_host then
				if req.is_get_request_method then
					create l_books_mgr.make (mongodb_client)
					create jobj.make_with_capacity (2)
					if attached l_books_mgr.find_documents as docs then
						jobj.put (l_books_mgr.find_documents, "items")
						create jlinks.make_with_capacity (docs.count)
						across
							docs as ic
						loop
							if attached {JSON_STRING} (ic.item / "_id") as j_book_id then
								jlinks.put (create {JSON_STRING}.make_from_string_general (req.absolute_script_url ("/books/"+ j_book_id.unescaped_string_8)), "book#" + j_book_id.unescaped_string_8)
							end
						end
						jobj.put (jlinks, "links")
					end
					compute_response_get_json (req, res, jobj.representation)
				elseif req.is_post_request_method  then
					if attached {BOOK} extract_data_from_json (req) as l_book then
							-- TODO handle errors.
						create l_books_mgr.make (mongodb_client)
						l_books_mgr.insert_document (l_book)
						if l_books_mgr.has_error then
							handle_internal_server_error ("{%"error%":%"Database Server Error:[" + l_books_mgr.error_message +"] %"}", req, res)
						else
							compute_response_post_json (req, res, l_book.to_json_string)
						end
					else
						handle_bad_request_response ("{%"error%":%"Error with form data: JSON form with the following pattern:%N { %"name%":%"...%", %"description%":%"...%",  %"image%":%"...%" }%"", req, res)
					end
				else
					handle_method_not_allowed_response ("{%"error%":%"The method [" + req.request_method + "] is not allowed%"}" , req, res)
				end
 			else
 				handle_internal_server_error ("{%"error%":%"Internal Server Error: host not found%"}", req, res)
 			end
 		end

	handle_item (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_books_mgr: BOOKS_MANAGER
		do
			if attached req.http_host as l_host then
					-- Get a document
				if req.is_get_request_method then
					if attached {WSF_STRING}  req.path_parameter ("id") as l_id then
						create l_books_mgr.make (mongodb_client)
						if attached l_books_mgr.find_document_by_id (l_id.value) as l_result then
							compute_response_get_json (req, res, l_result.representation)
						else
							handle_resource_not_found_response ("{%"error%":%"The document id [" + l_id.value +"] does not exist%"}", req, res)
						end
					end
					-- Delete a document
				elseif req.is_delete_request_method then
					if attached {WSF_STRING}  req.path_parameter ("id") as l_id then
						create l_books_mgr.make (mongodb_client)
						if  attached l_books_mgr.find_document_by_id (l_id.value)  then
							l_books_mgr.delete_by_id (l_id.value)
							if l_books_mgr.has_error then
								handle_internal_server_error ("{%"error%":%"Database Server Error:[" + l_books_mgr.error_message +"] %"}", req, res)
							else
								compute_response_get_json (req, res, "{ %"result%":%"success%" }")
							end
						else
							handle_resource_not_found_response ("{ %"error%":%"The document id does not exist%", %"_id%": %"" + l_id.value +"%"}"  , req, res)
						end
					else
						handle_internal_server_error ("{%"error%":%"Internal Server Error: host not found%"}", req, res)
					end
				elseif req.is_put_request_method then
					if attached {WSF_STRING}  req.path_parameter ("id") as l_id then
						create l_books_mgr.make (mongodb_client)
						if attached l_books_mgr.find_document_by_id (l_id.value) then
							if 	attached {BOOK} extract_data_from_json (req) as l_book then
								l_book.set_id (l_id.value)
								l_books_mgr.update_document (l_book)
								if l_books_mgr.has_error then
									handle_internal_server_error ("{%"error%":%"Database Server Error:[" + l_books_mgr.error_message +"] %"}", req, res)
								else
									compute_response_put_json (req, res, l_book.to_json_string)
								end
							else
								handle_bad_request_response ("{%"error%":%"Error with form data: JSON form with the following pattern:%N { %"_id%":%"..%", %"name%":%"...%", %"description%":%"...%",  %"image%":%"...%" }%"}", req, res)
							end
						else
							handle_resource_not_found_response ("{ %"error%":%"The document id does not exist%", %"_id%": %"" + l_id.value +"%"}"  , req, res)
						end
					else
					end
				end
			else
 				handle_internal_server_error ("{%"error%":%"Internal Server Error: host not found%"}", req, res)
 			end

		end

 feature -- Compute Response

 	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_text_html
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.ok)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

 	compute_response_get_json (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.ok)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

 	 compute_response_post_json (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.created)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

 	 compute_response_put_json (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.ok)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

feature -- MongoDB

	mongodb_client: MONGODB_CLIENT
		local
			uri: MONGODB_URI
		do
			create uri.make ("mongodb://127.0.0.1:27017")
			create Result.make_from_uri (uri)

				-- Register the application name so we can track it in the profile logs
				-- on the server. This can also be done from the URI (see other examples).
			Result.set_appname (app_name)
		end

	app_name: STRING = "books_restapi"

feature -- JSON

	extract_data_from_json (req: WSF_REQUEST): detachable BOOK
			-- Extract request form JSON data and build a object
			-- password view.
		local
			l_parser: JSON_PARSER
			l_name: STRING_32
			l_description: STRING_32
			l_image: STRING_32
		do
			create l_parser.make_with_string (retrieve_data (req))
			l_parser.parse_content
			if attached {JSON_OBJECT} l_parser.parsed_json_object as jv and then l_parser.is_parsed
			then
				if
					attached {JSON_STRING} jv.item ("name") as js_name and then
					attached {JSON_STRING} jv.item ("description") as js_description and then
					attached {JSON_STRING} jv.item ("image") as js_image
				then
		 			l_image := js_image.item
		 			l_name := js_name.item
		 			l_description := js_description.item
		 			if attached {JSON_STRING} jv.item ("_id") as l_id then
		 				create Result.make_with_id (l_id.item, l_name, l_description, l_image)
		 			else
						create Result.make (l_name, l_description, l_image)
					end
				end
			end
		end

end
