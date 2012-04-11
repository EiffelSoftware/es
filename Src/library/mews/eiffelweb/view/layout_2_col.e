indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LAYOUT_2_COL

inherit
	VIEW_HTML
		redefine
			out
		end

create
	make

feature
	out:STRING is
			--
		do
			put_link_css ("/layout-common.css")

			Result:= doctype +
				"%N<html xmlns=%"http://www.w3.org/1999/xhtml%" xml:lang=%"en%" lang=%"en%">" +
				"%N<head>"+
				"%N	<title>" + title + "</title>" +
				charset +
				link +
				"%N	<style type=%"text/css%">" +
				"%N		#content-left {"+
				"%N			width:25%%;"+
				"%N		}"+
				"%N		#content-middle {"+
				"%N			margin:0 0 0 25%%;"+
				"%N		}"+
				"%N	</style>"+
				"%N</head>"+
				"%N<body>"+
				"%N<div id=%"content-header%"><div class=%"content-columnin%">"+
				"%N"+content_header.out+
				"%N</div></div>"+

				"%N<div id=%"content-left1%">"+

				"%N	<div id=%"content-left%"><div class=%"content-columnin%">"+
				"%N"+content_left.out +
				"%N	</div></div>"+

				"%N	<div id=%"content-middle%"><div class=%"content-columnin%">"+
				"%N"+content_middle.out +
				"%N	</div></div>"+

				"%N	<div class=%"cleaner%">&nbsp;</div>"+

				"%N</div>"+

				"%N<div id=%"content-footer%"><div class=%"content-columnin%">"+
				"%N"+content_footer.out+
				"%N</div></div>"+

				"%N</body>"+
				"%N</html>"

		end

feature {NONE} -- Implementation

invariant
	invariant_clause: True -- Your invariant here

end
