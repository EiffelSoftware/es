indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	I18N_DATE_FORMATTER

	feature
		-- Creation
		make (locale_info: I18N_LOCALE_INFO) is
				-- do

				do
					info := locale_info
					create long_date_format.make (info.long_date_format, info)
					create long_time_format.make (info.long_time_format, info)
					create date_time_format.make (info.date_time_format, info)
				end

	feature
		-- Access
		format_date(date:DATE):STRING_32 is
				-- formats an EiffelTime date according to the long date format
				require
					date_not_void: date /= Void
				do
					Result := long_date_format.filled (DATE,create {TIME}.make_now)
				end

		format_time(time: TIME): STRING_32 is
				-- formats an EiffelTime time according to the long time format
			require
				time_not_void: time /= Void
			do
				Result := long_date_format.filled (create {DATE}.make_now, time)
			end

		format_date_time(date_time:DATE_TIME):STRING_32 is
				--
			require
				date_time_not_void: date_time /= Void
			do
				Result := date_time_format.filled(date_time.date, date_time.time)
			end


	feature {NONE}
		-- Implementation
			info: I18N_LOCALE_INFO
			long_date_format: I18N_FORMAT_STRING
			long_time_format: I18N_FORMAT_STRING
			date_time_format: I18N_FORMAT_STRING



end
