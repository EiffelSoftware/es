note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_URL_CONNECTION_DELEGATE_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Optional Methods

	connection__will_send_request__redirect_response_ (a_connection: detachable NS_URL_CONNECTION; a_request: detachable NS_URL_REQUEST; a_response: detachable NS_URL_RESPONSE): detachable NS_URL_REQUEST
			-- Auto generated Objective-C wrapper.
		require
			has_connection__will_send_request__redirect_response_: has_connection__will_send_request__redirect_response_
		local
			result_pointer: POINTER
			a_connection__item: POINTER
			a_request__item: POINTER
			a_response__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_request as a_request_attached then
				a_request__item := a_request_attached.item
			end
			if attached a_response as a_response_attached then
				a_response__item := a_response_attached.item
			end
			result_pointer := objc_connection__will_send_request__redirect_response_ (item, a_connection__item, a_request__item, a_response__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like connection__will_send_request__redirect_response_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like connection__will_send_request__redirect_response_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	connection__need_new_body_stream_ (a_connection: detachable NS_URL_CONNECTION; a_request: detachable NS_URL_REQUEST): detachable NS_INPUT_STREAM
			-- Auto generated Objective-C wrapper.
		require
			has_connection__need_new_body_stream_: has_connection__need_new_body_stream_
		local
			result_pointer: POINTER
			a_connection__item: POINTER
			a_request__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_request as a_request_attached then
				a_request__item := a_request_attached.item
			end
			result_pointer := objc_connection__need_new_body_stream_ (item, a_connection__item, a_request__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like connection__need_new_body_stream_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like connection__need_new_body_stream_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	connection__can_authenticate_against_protection_space_ (a_connection: detachable NS_URL_CONNECTION; a_protection_space: detachable NS_URL_PROTECTION_SPACE): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_connection__can_authenticate_against_protection_space_: has_connection__can_authenticate_against_protection_space_
		local
			a_connection__item: POINTER
			a_protection_space__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_protection_space as a_protection_space_attached then
				a_protection_space__item := a_protection_space_attached.item
			end
			Result := objc_connection__can_authenticate_against_protection_space_ (item, a_connection__item, a_protection_space__item)
		end

	connection__did_receive_authentication_challenge_ (a_connection: detachable NS_URL_CONNECTION; a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		require
			has_connection__did_receive_authentication_challenge_: has_connection__did_receive_authentication_challenge_
		local
			a_connection__item: POINTER
			a_challenge__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_connection__did_receive_authentication_challenge_ (item, a_connection__item, a_challenge__item)
		end

	connection__will_send_request_for_authentication_challenge_ (a_connection: detachable NS_URL_CONNECTION; a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		require
			has_connection__will_send_request_for_authentication_challenge_: has_connection__will_send_request_for_authentication_challenge_
		local
			a_connection__item: POINTER
			a_challenge__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_connection__will_send_request_for_authentication_challenge_ (item, a_connection__item, a_challenge__item)
		end

	connection__did_cancel_authentication_challenge_ (a_connection: detachable NS_URL_CONNECTION; a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		require
			has_connection__did_cancel_authentication_challenge_: has_connection__did_cancel_authentication_challenge_
		local
			a_connection__item: POINTER
			a_challenge__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_connection__did_cancel_authentication_challenge_ (item, a_connection__item, a_challenge__item)
		end

	connection_should_use_credential_storage_ (a_connection: detachable NS_URL_CONNECTION): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_connection_should_use_credential_storage_: has_connection_should_use_credential_storage_
		local
			a_connection__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			Result := objc_connection_should_use_credential_storage_ (item, a_connection__item)
		end

	connection__did_receive_response_ (a_connection: detachable NS_URL_CONNECTION; a_response: detachable NS_URL_RESPONSE)
			-- Auto generated Objective-C wrapper.
		require
			has_connection__did_receive_response_: has_connection__did_receive_response_
		local
			a_connection__item: POINTER
			a_response__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_response as a_response_attached then
				a_response__item := a_response_attached.item
			end
			objc_connection__did_receive_response_ (item, a_connection__item, a_response__item)
		end

	connection__did_receive_data_ (a_connection: detachable NS_URL_CONNECTION; a_data: detachable NS_DATA)
			-- Auto generated Objective-C wrapper.
		require
			has_connection__did_receive_data_: has_connection__did_receive_data_
		local
			a_connection__item: POINTER
			a_data__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_data as a_data_attached then
				a_data__item := a_data_attached.item
			end
			objc_connection__did_receive_data_ (item, a_connection__item, a_data__item)
		end

	connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_ (a_connection: detachable NS_URL_CONNECTION; a_bytes_written: INTEGER_64; a_total_bytes_written: INTEGER_64; a_total_bytes_expected_to_write: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		require
			has_connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_: has_connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_
		local
			a_connection__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			objc_connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_ (item, a_connection__item, a_bytes_written, a_total_bytes_written, a_total_bytes_expected_to_write)
		end

	connection_did_finish_loading_ (a_connection: detachable NS_URL_CONNECTION)
			-- Auto generated Objective-C wrapper.
		require
			has_connection_did_finish_loading_: has_connection_did_finish_loading_
		local
			a_connection__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			objc_connection_did_finish_loading_ (item, a_connection__item)
		end

	connection__did_fail_with_error_ (a_connection: detachable NS_URL_CONNECTION; a_error: detachable NS_ERROR)
			-- Auto generated Objective-C wrapper.
		require
			has_connection__did_fail_with_error_: has_connection__did_fail_with_error_
		local
			a_connection__item: POINTER
			a_error__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			objc_connection__did_fail_with_error_ (item, a_connection__item, a_error__item)
		end

	connection__will_cache_response_ (a_connection: detachable NS_URL_CONNECTION; a_cached_response: detachable NS_CACHED_URL_RESPONSE): detachable NS_CACHED_URL_RESPONSE
			-- Auto generated Objective-C wrapper.
		require
			has_connection__will_cache_response_: has_connection__will_cache_response_
		local
			result_pointer: POINTER
			a_connection__item: POINTER
			a_cached_response__item: POINTER
		do
			if attached a_connection as a_connection_attached then
				a_connection__item := a_connection_attached.item
			end
			if attached a_cached_response as a_cached_response_attached then
				a_cached_response__item := a_cached_response_attached.item
			end
			result_pointer := objc_connection__will_cache_response_ (item, a_connection__item, a_cached_response__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like connection__will_cache_response_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like connection__will_cache_response_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

feature -- Status Report

	has_connection__will_send_request__redirect_response_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__will_send_request__redirect_response_ (item)
		end

	has_connection__need_new_body_stream_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__need_new_body_stream_ (item)
		end

	has_connection__can_authenticate_against_protection_space_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__can_authenticate_against_protection_space_ (item)
		end

	has_connection__did_receive_authentication_challenge_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__did_receive_authentication_challenge_ (item)
		end

	has_connection__will_send_request_for_authentication_challenge_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__will_send_request_for_authentication_challenge_ (item)
		end

	has_connection__did_cancel_authentication_challenge_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__did_cancel_authentication_challenge_ (item)
		end

	has_connection_should_use_credential_storage_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection_should_use_credential_storage_ (item)
		end

	has_connection__did_receive_response_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__did_receive_response_ (item)
		end

	has_connection__did_receive_data_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__did_receive_data_ (item)
		end

	has_connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_ (item)
		end

	has_connection_did_finish_loading_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection_did_finish_loading_ (item)
		end

	has_connection__did_fail_with_error_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__did_fail_with_error_ (item)
		end

	has_connection__will_cache_response_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_connection__will_cache_response_ (item)
		end

feature -- Status Report Externals

	objc_has_connection__will_send_request__redirect_response_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:willSendRequest:redirectResponse:)];
			 ]"
		end

	objc_has_connection__need_new_body_stream_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:needNewBodyStream:)];
			 ]"
		end

	objc_has_connection__can_authenticate_against_protection_space_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:canAuthenticateAgainstProtectionSpace:)];
			 ]"
		end

	objc_has_connection__did_receive_authentication_challenge_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:didReceiveAuthenticationChallenge:)];
			 ]"
		end

	objc_has_connection__will_send_request_for_authentication_challenge_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:willSendRequestForAuthenticationChallenge:)];
			 ]"
		end

	objc_has_connection__did_cancel_authentication_challenge_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:didCancelAuthenticationChallenge:)];
			 ]"
		end

	objc_has_connection_should_use_credential_storage_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connectionShouldUseCredentialStorage:)];
			 ]"
		end

	objc_has_connection__did_receive_response_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:didReceiveResponse:)];
			 ]"
		end

	objc_has_connection__did_receive_data_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:didReceiveData:)];
			 ]"
		end

	objc_has_connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:didSendBodyData:totalBytesWritten:totalBytesExpectedToWrite:)];
			 ]"
		end

	objc_has_connection_did_finish_loading_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connectionDidFinishLoading:)];
			 ]"
		end

	objc_has_connection__did_fail_with_error_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:didFailWithError:)];
			 ]"
		end

	objc_has_connection__will_cache_response_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(connection:willCacheResponse:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_connection__will_send_request__redirect_response_ (an_item: POINTER; a_connection: POINTER; a_request: POINTER; a_response: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection willSendRequest:$a_request redirectResponse:$a_response];
			 ]"
		end

	objc_connection__need_new_body_stream_ (an_item: POINTER; a_connection: POINTER; a_request: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection needNewBodyStream:$a_request];
			 ]"
		end

	objc_connection__can_authenticate_against_protection_space_ (an_item: POINTER; a_connection: POINTER; a_protection_space: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSURLConnectionDelegate>)$an_item connection:$a_connection canAuthenticateAgainstProtectionSpace:$a_protection_space];
			 ]"
		end

	objc_connection__did_receive_authentication_challenge_ (an_item: POINTER; a_connection: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection didReceiveAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_connection__will_send_request_for_authentication_challenge_ (an_item: POINTER; a_connection: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection willSendRequestForAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_connection__did_cancel_authentication_challenge_ (an_item: POINTER; a_connection: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection didCancelAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_connection_should_use_credential_storage_ (an_item: POINTER; a_connection: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSURLConnectionDelegate>)$an_item connectionShouldUseCredentialStorage:$a_connection];
			 ]"
		end

	objc_connection__did_receive_response_ (an_item: POINTER; a_connection: POINTER; a_response: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection didReceiveResponse:$a_response];
			 ]"
		end

	objc_connection__did_receive_data_ (an_item: POINTER; a_connection: POINTER; a_data: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection didReceiveData:$a_data];
			 ]"
		end

	objc_connection__did_send_body_data__total_bytes_written__total_bytes_expected_to_write_ (an_item: POINTER; a_connection: POINTER; a_bytes_written: INTEGER_64; a_total_bytes_written: INTEGER_64; a_total_bytes_expected_to_write: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection didSendBodyData:$a_bytes_written totalBytesWritten:$a_total_bytes_written totalBytesExpectedToWrite:$a_total_bytes_expected_to_write];
			 ]"
		end

	objc_connection_did_finish_loading_ (an_item: POINTER; a_connection: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connectionDidFinishLoading:$a_connection];
			 ]"
		end

	objc_connection__did_fail_with_error_ (an_item: POINTER; a_connection: POINTER; a_error: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection didFailWithError:$a_error];
			 ]"
		end

	objc_connection__will_cache_response_ (an_item: POINTER; a_connection: POINTER; a_cached_response: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(id <NSURLConnectionDelegate>)$an_item connection:$a_connection willCacheResponse:$a_cached_response];
			 ]"
		end

end