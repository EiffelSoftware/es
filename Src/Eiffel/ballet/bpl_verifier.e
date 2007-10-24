indexing
	description	: "bpl verifier"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date		: "$Date$"
	revision	: "$Revision$"

deferred class
	BPL_VERIFIER

inherit
	SHARED_BPL_ENVIRONMENT

feature
	input: KL_STRING_OUTPUT_STREAM

	reset is
			-- inializes `input' stream
		do
			create input.make_empty
		end

	verify is
			-- verifies all bpl code written to `input'
			-- verification errors are inserted into environment.error_log
		deferred
		end

indexing
	copyright:	"Copyright (c) 2006, Raphael Mack"
	license:	"GPL version 2 or later"
	copying: "[

				 This program is free software; you can redistribute it and/or
				 modify it under the terms of the GNU General Public License as
				 published by the Free Software Foundation; either version 2 of
				 the License, or (at your option) any later version.
				
				 This program is distributed in the hope that it will be useful,
				 but WITHOUT ANY WARRANTY; without even the implied warranty of
				 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
				 GNU General Public License for more details.
				
				 You should have received a copy of the GNU General Public
				 License along with this program; if not, write to the Free Software
				 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
				 MA 02110-1301  USA
				 ]"

end -- class BPL_VERFIER
