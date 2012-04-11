indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	LAYOUT_3_COL

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
			result := doctype +
				"%N<html xmlns=%"http://www.w3.org/1999/xhtml%" xml:lang=%"en%" lang=%"en%">"+
				"%N<head>"+
				"%N	<title>"+title+"</title>"+
				charset +
				link +
				"%N	<style type=%"text/css%">"+
				"%N		#content-left {"+
				"%N			width:20%%;"+
				"%N		}"+
				"%N		#content-right {"+
				"%N			width:20%%;"+
				"%N		}"+
				"%N		#content-middle {"+
				"%N			margin:0 20%% 0 20%%;"+
				"%N		}"+
				"%N	</style>"+
				"%N</head>"+

				"%N<body>"+
				"%N<div id=%"content-header%"><div class=%"content-columnin%">"+
				content_header.out+
				"</div></div>"+

				"<div id=%"content-left1%"><div id=%"content-right1%">"+

				"	<div id=%"content-left%"><div class=%"content-columnin%">"+
				content_left.out+
				"	</div></div>"+

				"	<div id=%"content-right%"><div class=%"content-columnin%">"+
				content_right.out+
				"	</div></div>"+

				"	<div id=%"content-middle%"><div class=%"content-columnin%">"+
				content_middle.out+
				"	</div></div>"+

				"	<div class=%"cleaner%">&nbsp;</div>"+

				"</div></div>"+

				"<div id=%"content-footer%"><div class=%"content-columnin%">"+
				content_footer.out+
				"</div></div>"+

				"</body>"+
				"</html>"
		end
end
