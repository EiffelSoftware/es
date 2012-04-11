indexing
	description: "The abstract class used to handle a specific group of user requests"
	author: "Peizhu Li, <lip@student.ethz.ch>"
	date: "12.12.2007"
	revision: "$0.6$"

deferred class
	REQUEST_HANDLER

feature -- attributes

	context: REQUEST_DISPATCHER
		-- all http environment variables

	session: SESSION
		-- reference to actual session object

	return_page: VIEW
		-- result html page

	processing_finished: BOOLEAN
		-- whether processing should be stopped (prematured)

feature --creation

	make is
			-- creation
		do
		end


	initialize(dispatcher: REQUEST_DISPATCHER) is
			-- initialize with parameters from dispatcher object
		do
			make

			-- initialize local references
			context := dispatcher
			session := dispatcher.session

			processing_finished := false
		end

feature {REQUEST_HANDLER} -- processing

	pre_processing is
			-- common tasks to be executed before starting process user request
		deferred
		end

	post_processing is
			-- common tasks to be executed after request processed
		deferred
		end

	handling_request is
			-- common tasks to be executed after request processed
		deferred
		end

	handler_redirection(type: STRING) is
			-- let another handler processing and generate
		local
			new_handler: REQUEST_HANDLER
		do
			new_handler ?= instantiate_handler(type)

			if new_handler /= void then
				return_page ?= new_handler.process_request
				processing_finished := true
			end
		end

	url_redirection(url: STRING; is_secure: BOOLEAN) is
			-- let another handler processing and generate
		do
			context.response_header.generate_http_redirection(url, is_secure)
			processing_finished := true
		end


feature -- form helper

	fill_form_with_submitted_values is
			-- trying to check all fields in request url and replace corresponding tags with their values if any
			-- valid only when return_page is an HTML_TEMPLATE_VIEW instance
		local
			a_template_based_page: HTML_TEMPLATE_VIEW
			i: INTEGER
			field_name, field_value: STRING
		do
			a_template_based_page ?= return_page
			if  a_template_based_page /= void then
				from
					i := 1
				until
					i > context.fields.count
				loop
					field_name := context.fields.item (i)
					field_value := context.text_field_value (field_name)
					if not field_name.is_empty then
						a_template_based_page.replace_marker_with_string (field_name, field_value)
					end
					i := i + 1
				end
			end
		end


feature -- main entry

	process_request: HTML_PAGE is
			--
		do
			pre_processing

			if not processing_finished then
				handling_request
			end

			if not processing_finished then
				post_processing
			end

			if context.session_enabled and not context.cookie_enabled then
				url_rewriting
			end

			Result := return_page
		ensure
			result_page_generated: Result /= void
		end

feature {NONE} -- implementation

	instantiate_handler(handler_type: STRING): REQUEST_HANDLER is
			-- based on initialized handler mapping table, lookup and initialize a handler for current request
		require
			handler_type_specified: handler_type /= void and not handler_type.is_empty
		local
			handler: INTERNAL
			type: INTEGER
		do

			create handler
			type := handler.dynamic_type_from_string (handler_type)

			Result ?= handler.new_instance_of(type)
			if Result /= void then

				-- initialize handler together with current dispatcher object as environment, while INTERNAL wont call the create procedure
				Result.initialize(context)
			end

		end

	url_rewriting is
			-- rewrite urls and forms, insert 'sid=session_id' to all url/form actions, so as to enable session support
			-- in certain cases post action url with field texts is not supported (z.B. on apache windows), one hidden input item will be inserted into forms
		local
			image, url, url_with_sid: STRING
			form_input_sid: STRING
			start_index, end_index, href_index, endhref_index, form_index, count: INTEGER
			result_view: VIEW
		do
			image := return_page.out

			-- rewrite all 'href' tag into lower cases
			image.replace_substring_all ("<A ", "<a ")
			image.replace_substring_all (" Href=%"", " href=%"")
			image.replace_substring_all (" HREF=%"", " href=%"")

			-- find and rewrite 'href' url links
			href_index := 1
			count := 0
			from start_index := 1
			until start_index = 0 or start_index >= image.count
			loop
				start_index := image.substring_index ("<a ", start_index)
				if start_index /= 0 then
					end_index := image.index_of ('>', start_index+2)
					if end_index /= 0 then -- '<a ...>' bound located
						href_index := image.substring_index_in_bounds (" href=%"", start_index, end_index)
						if href_index /= 0 then  -- 'href=' located
							endhref_index := image.index_of ('"', href_index+7)
							if endhref_index /= 0 and then endhref_index < end_index then
								url := image.substring (href_index, endhref_index-1)
								if url.index_of ('?', 1) /= 0 then
									url_with_sid := url + "&amp;sid=" + session.session_id
								else
									url_with_sid := url + "?sid=" + session.session_id
								end
								image.replace_substring_all (url, url_with_sid)
							end
						end
					end
					check end_index > 0 end
					start_index := end_index+1
				end
			end

			-- rewrite all 'form' tag into lower cases
			image.replace_substring_all ("<Form ", "<form ")
			image.replace_substring_all ("<FORM ", "<form ")

			form_input_sid := "%N<div><input name=%"sid%" type=%"hidden%" value=%"" + session.session_id + "%" /></div>%N"

			-- find and rewrite forms, add hidden 'sid' input
			form_index := 1
			count := 0
			from start_index := 1
			until form_index = 0
			loop
				form_index := image.substring_index ("<form ", start_index)
				if form_index /= 0 then
					end_index := image.index_of ('>', form_index+1)
					if end_index /= 0 then
						image.insert_string (form_input_sid, end_index+1)
					end
				end
				start_index := form_index + 5
			end

			create result_view.make
			result_view.set_content (image)
			return_page ?= result_view

		end

end
