note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_URL_DOWNLOAD_DELEGATE_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Optional Methods

	download_did_begin_ (a_download: detachable NS_URL_DOWNLOAD)
			-- Auto generated Objective-C wrapper.
		require
			has_download_did_begin_: has_download_did_begin_
		local
			a_download__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			objc_download_did_begin_ (item, a_download__item)
		end

	download__will_send_request__redirect_response_ (a_download: detachable NS_URL_DOWNLOAD; a_request: detachable NS_URL_REQUEST; a_redirect_response: detachable NS_URL_RESPONSE): detachable NS_URL_REQUEST
			-- Auto generated Objective-C wrapper.
		require
			has_download__will_send_request__redirect_response_: has_download__will_send_request__redirect_response_
		local
			result_pointer: POINTER
			a_download__item: POINTER
			a_request__item: POINTER
			a_redirect_response__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_request as a_request_attached then
				a_request__item := a_request_attached.item
			end
			if attached a_redirect_response as a_redirect_response_attached then
				a_redirect_response__item := a_redirect_response_attached.item
			end
			result_pointer := objc_download__will_send_request__redirect_response_ (item, a_download__item, a_request__item, a_redirect_response__item)
			if result_pointer /= default_pointer then
				if attached objc_get_eiffel_object (result_pointer) as existing_eiffel_object then
					check attached {like download__will_send_request__redirect_response_} existing_eiffel_object as valid_result then
						Result := valid_result
					end
				else
					check attached {like download__will_send_request__redirect_response_} new_eiffel_object (result_pointer, True) as valid_result_pointer then
						Result := valid_result_pointer
					end
				end
			end
		end

	download__can_authenticate_against_protection_space_ (a_connection: detachable NS_URL_DOWNLOAD; a_protection_space: detachable NS_URL_PROTECTION_SPACE): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_download__can_authenticate_against_protection_space_: has_download__can_authenticate_against_protection_space_
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
			Result := objc_download__can_authenticate_against_protection_space_ (item, a_connection__item, a_protection_space__item)
		end

	download__did_receive_authentication_challenge_ (a_download: detachable NS_URL_DOWNLOAD; a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		require
			has_download__did_receive_authentication_challenge_: has_download__did_receive_authentication_challenge_
		local
			a_download__item: POINTER
			a_challenge__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_download__did_receive_authentication_challenge_ (item, a_download__item, a_challenge__item)
		end

	download__did_cancel_authentication_challenge_ (a_download: detachable NS_URL_DOWNLOAD; a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		require
			has_download__did_cancel_authentication_challenge_: has_download__did_cancel_authentication_challenge_
		local
			a_download__item: POINTER
			a_challenge__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_download__did_cancel_authentication_challenge_ (item, a_download__item, a_challenge__item)
		end

	download_should_use_credential_storage_ (a_download: detachable NS_URL_DOWNLOAD): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_download_should_use_credential_storage_: has_download_should_use_credential_storage_
		local
			a_download__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			Result := objc_download_should_use_credential_storage_ (item, a_download__item)
		end

	download__did_receive_response_ (a_download: detachable NS_URL_DOWNLOAD; a_response: detachable NS_URL_RESPONSE)
			-- Auto generated Objective-C wrapper.
		require
			has_download__did_receive_response_: has_download__did_receive_response_
		local
			a_download__item: POINTER
			a_response__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_response as a_response_attached then
				a_response__item := a_response_attached.item
			end
			objc_download__did_receive_response_ (item, a_download__item, a_response__item)
		end

	download__will_resume_with_response__from_byte_ (a_download: detachable NS_URL_DOWNLOAD; a_response: detachable NS_URL_RESPONSE; a_starting_byte: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		require
			has_download__will_resume_with_response__from_byte_: has_download__will_resume_with_response__from_byte_
		local
			a_download__item: POINTER
			a_response__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_response as a_response_attached then
				a_response__item := a_response_attached.item
			end
			objc_download__will_resume_with_response__from_byte_ (item, a_download__item, a_response__item, a_starting_byte)
		end

	download__did_receive_data_of_length_ (a_download: detachable NS_URL_DOWNLOAD; a_length: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		require
			has_download__did_receive_data_of_length_: has_download__did_receive_data_of_length_
		local
			a_download__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			objc_download__did_receive_data_of_length_ (item, a_download__item, a_length)
		end

	download__should_decode_source_data_of_mime_type_ (a_download: detachable NS_URL_DOWNLOAD; a_encoding_type: detachable NS_STRING): BOOLEAN
			-- Auto generated Objective-C wrapper.
		require
			has_download__should_decode_source_data_of_mime_type_: has_download__should_decode_source_data_of_mime_type_
		local
			a_download__item: POINTER
			a_encoding_type__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_encoding_type as a_encoding_type_attached then
				a_encoding_type__item := a_encoding_type_attached.item
			end
			Result := objc_download__should_decode_source_data_of_mime_type_ (item, a_download__item, a_encoding_type__item)
		end

	download__decide_destination_with_suggested_filename_ (a_download: detachable NS_URL_DOWNLOAD; a_filename: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		require
			has_download__decide_destination_with_suggested_filename_: has_download__decide_destination_with_suggested_filename_
		local
			a_download__item: POINTER
			a_filename__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_filename as a_filename_attached then
				a_filename__item := a_filename_attached.item
			end
			objc_download__decide_destination_with_suggested_filename_ (item, a_download__item, a_filename__item)
		end

	download__did_create_destination_ (a_download: detachable NS_URL_DOWNLOAD; a_path: detachable NS_STRING)
			-- Auto generated Objective-C wrapper.
		require
			has_download__did_create_destination_: has_download__did_create_destination_
		local
			a_download__item: POINTER
			a_path__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_path as a_path_attached then
				a_path__item := a_path_attached.item
			end
			objc_download__did_create_destination_ (item, a_download__item, a_path__item)
		end

	download_did_finish_ (a_download: detachable NS_URL_DOWNLOAD)
			-- Auto generated Objective-C wrapper.
		require
			has_download_did_finish_: has_download_did_finish_
		local
			a_download__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			objc_download_did_finish_ (item, a_download__item)
		end

	download__did_fail_with_error_ (a_download: detachable NS_URL_DOWNLOAD; a_error: detachable NS_ERROR)
			-- Auto generated Objective-C wrapper.
		require
			has_download__did_fail_with_error_: has_download__did_fail_with_error_
		local
			a_download__item: POINTER
			a_error__item: POINTER
		do
			if attached a_download as a_download_attached then
				a_download__item := a_download_attached.item
			end
			if attached a_error as a_error_attached then
				a_error__item := a_error_attached.item
			end
			objc_download__did_fail_with_error_ (item, a_download__item, a_error__item)
		end

feature -- Status Report

	has_download_did_begin_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download_did_begin_ (item)
		end

	has_download__will_send_request__redirect_response_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__will_send_request__redirect_response_ (item)
		end

	has_download__can_authenticate_against_protection_space_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__can_authenticate_against_protection_space_ (item)
		end

	has_download__did_receive_authentication_challenge_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__did_receive_authentication_challenge_ (item)
		end

	has_download__did_cancel_authentication_challenge_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__did_cancel_authentication_challenge_ (item)
		end

	has_download_should_use_credential_storage_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download_should_use_credential_storage_ (item)
		end

	has_download__did_receive_response_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__did_receive_response_ (item)
		end

	has_download__will_resume_with_response__from_byte_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__will_resume_with_response__from_byte_ (item)
		end

	has_download__did_receive_data_of_length_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__did_receive_data_of_length_ (item)
		end

	has_download__should_decode_source_data_of_mime_type_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__should_decode_source_data_of_mime_type_ (item)
		end

	has_download__decide_destination_with_suggested_filename_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__decide_destination_with_suggested_filename_ (item)
		end

	has_download__did_create_destination_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__did_create_destination_ (item)
		end

	has_download_did_finish_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download_did_finish_ (item)
		end

	has_download__did_fail_with_error_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_download__did_fail_with_error_ (item)
		end

feature -- Status Report Externals

	objc_has_download_did_begin_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(downloadDidBegin:)];
			 ]"
		end

	objc_has_download__will_send_request__redirect_response_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:willSendRequest:redirectResponse:)];
			 ]"
		end

	objc_has_download__can_authenticate_against_protection_space_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:canAuthenticateAgainstProtectionSpace:)];
			 ]"
		end

	objc_has_download__did_receive_authentication_challenge_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:didReceiveAuthenticationChallenge:)];
			 ]"
		end

	objc_has_download__did_cancel_authentication_challenge_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:didCancelAuthenticationChallenge:)];
			 ]"
		end

	objc_has_download_should_use_credential_storage_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(downloadShouldUseCredentialStorage:)];
			 ]"
		end

	objc_has_download__did_receive_response_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:didReceiveResponse:)];
			 ]"
		end

	objc_has_download__will_resume_with_response__from_byte_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:willResumeWithResponse:fromByte:)];
			 ]"
		end

	objc_has_download__did_receive_data_of_length_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:didReceiveDataOfLength:)];
			 ]"
		end

	objc_has_download__should_decode_source_data_of_mime_type_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:shouldDecodeSourceDataOfMIMEType:)];
			 ]"
		end

	objc_has_download__decide_destination_with_suggested_filename_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:decideDestinationWithSuggestedFilename:)];
			 ]"
		end

	objc_has_download__did_create_destination_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:didCreateDestination:)];
			 ]"
		end

	objc_has_download_did_finish_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(downloadDidFinish:)];
			 ]"
		end

	objc_has_download__did_fail_with_error_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(download:didFailWithError:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_download_did_begin_ (an_item: POINTER; a_download: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item downloadDidBegin:$a_download];
			 ]"
		end

	objc_download__will_send_request__redirect_response_ (an_item: POINTER; a_download: POINTER; a_request: POINTER; a_redirect_response: POINTER): POINTER
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return (EIF_POINTER)[(id <NSURLDownloadDelegate>)$an_item download:$a_download willSendRequest:$a_request redirectResponse:$a_redirect_response];
			 ]"
		end

	objc_download__can_authenticate_against_protection_space_ (an_item: POINTER; a_connection: POINTER; a_protection_space: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSURLDownloadDelegate>)$an_item download:$a_connection canAuthenticateAgainstProtectionSpace:$a_protection_space];
			 ]"
		end

	objc_download__did_receive_authentication_challenge_ (an_item: POINTER; a_download: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download didReceiveAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_download__did_cancel_authentication_challenge_ (an_item: POINTER; a_download: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download didCancelAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_download_should_use_credential_storage_ (an_item: POINTER; a_download: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSURLDownloadDelegate>)$an_item downloadShouldUseCredentialStorage:$a_download];
			 ]"
		end

	objc_download__did_receive_response_ (an_item: POINTER; a_download: POINTER; a_response: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download didReceiveResponse:$a_response];
			 ]"
		end

	objc_download__will_resume_with_response__from_byte_ (an_item: POINTER; a_download: POINTER; a_response: POINTER; a_starting_byte: INTEGER_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download willResumeWithResponse:$a_response fromByte:$a_starting_byte];
			 ]"
		end

	objc_download__did_receive_data_of_length_ (an_item: POINTER; a_download: POINTER; a_length: NATURAL_64)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download didReceiveDataOfLength:$a_length];
			 ]"
		end

	objc_download__should_decode_source_data_of_mime_type_ (an_item: POINTER; a_download: POINTER; a_encoding_type: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id <NSURLDownloadDelegate>)$an_item download:$a_download shouldDecodeSourceDataOfMIMEType:$a_encoding_type];
			 ]"
		end

	objc_download__decide_destination_with_suggested_filename_ (an_item: POINTER; a_download: POINTER; a_filename: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download decideDestinationWithSuggestedFilename:$a_filename];
			 ]"
		end

	objc_download__did_create_destination_ (an_item: POINTER; a_download: POINTER; a_path: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download didCreateDestination:$a_path];
			 ]"
		end

	objc_download_did_finish_ (an_item: POINTER; a_download: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item downloadDidFinish:$a_download];
			 ]"
		end

	objc_download__did_fail_with_error_ (an_item: POINTER; a_download: POINTER; a_error: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLDownloadDelegate>)$an_item download:$a_download didFailWithError:$a_error];
			 ]"
		end

end