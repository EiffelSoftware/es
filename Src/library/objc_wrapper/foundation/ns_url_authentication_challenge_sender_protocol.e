note
	description: "Auto-generated Objective-C wrapper class"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	NS_URL_AUTHENTICATION_CHALLENGE_SENDER_PROTOCOL

inherit
	NS_OBJECT_PROTOCOL

feature -- Required Methods

	use_credential__for_authentication_challenge_ (a_credential: detachable NS_URL_CREDENTIAL; a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		local
			a_credential__item: POINTER
			a_challenge__item: POINTER
		do
			if attached a_credential as a_credential_attached then
				a_credential__item := a_credential_attached.item
			end
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_use_credential__for_authentication_challenge_ (item, a_credential__item, a_challenge__item)
		end

	continue_without_credential_for_authentication_challenge_ (a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		local
			a_challenge__item: POINTER
		do
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_continue_without_credential_for_authentication_challenge_ (item, a_challenge__item)
		end

	cancel_authentication_challenge_ (a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		local
			a_challenge__item: POINTER
		do
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_cancel_authentication_challenge_ (item, a_challenge__item)
		end

feature {NONE} -- Required Methods Externals

	objc_use_credential__for_authentication_challenge_ (an_item: POINTER; a_credential: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLAuthenticationChallengeSender>)$an_item useCredential:$a_credential forAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_continue_without_credential_for_authentication_challenge_ (an_item: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLAuthenticationChallengeSender>)$an_item continueWithoutCredentialForAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_cancel_authentication_challenge_ (an_item: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLAuthenticationChallengeSender>)$an_item cancelAuthenticationChallenge:$a_challenge];
			 ]"
		end

feature -- Optional Methods

	perform_default_handling_for_authentication_challenge_ (a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		require
			has_perform_default_handling_for_authentication_challenge_: has_perform_default_handling_for_authentication_challenge_
		local
			a_challenge__item: POINTER
		do
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_perform_default_handling_for_authentication_challenge_ (item, a_challenge__item)
		end

	reject_protection_space_and_continue_with_challenge_ (a_challenge: detachable NS_URL_AUTHENTICATION_CHALLENGE)
			-- Auto generated Objective-C wrapper.
		require
			has_reject_protection_space_and_continue_with_challenge_: has_reject_protection_space_and_continue_with_challenge_
		local
			a_challenge__item: POINTER
		do
			if attached a_challenge as a_challenge_attached then
				a_challenge__item := a_challenge_attached.item
			end
			objc_reject_protection_space_and_continue_with_challenge_ (item, a_challenge__item)
		end

feature -- Status Report

	has_perform_default_handling_for_authentication_challenge_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_perform_default_handling_for_authentication_challenge_ (item)
		end

	has_reject_protection_space_and_continue_with_challenge_: BOOLEAN
			-- Auto generated Objective-C wrapper.
		do
			Result := objc_has_reject_protection_space_and_continue_with_challenge_ (item)
		end

feature -- Status Report Externals

	objc_has_perform_default_handling_for_authentication_challenge_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(performDefaultHandlingForAuthenticationChallenge:)];
			 ]"
		end

	objc_has_reject_protection_space_and_continue_with_challenge_ (an_item: POINTER): BOOLEAN
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				return [(id)$an_item respondsToSelector:@selector(rejectProtectionSpaceAndContinueWithChallenge:)];
			 ]"
		end

feature {NONE} -- Optional Methods Externals

	objc_perform_default_handling_for_authentication_challenge_ (an_item: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLAuthenticationChallengeSender>)$an_item performDefaultHandlingForAuthenticationChallenge:$a_challenge];
			 ]"
		end

	objc_reject_protection_space_and_continue_with_challenge_ (an_item: POINTER; a_challenge: POINTER)
			-- Auto generated Objective-C wrapper.
		external
			"C inline use <Foundation/Foundation.h>"
		alias
			"[
				[(id <NSURLAuthenticationChallengeSender>)$an_item rejectProtectionSpaceAndContinueWithChallenge:$a_challenge];
			 ]"
		end

end