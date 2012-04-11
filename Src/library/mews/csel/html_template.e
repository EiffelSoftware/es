indexing
	description: "Objects that ..."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	HTML_TEMPLATE

inherit
	VIEW_HTML
		redefine
			out
		end
	HTML_DELEGATE
		undefine
			out,
			make
		end

create
	make

feature -- out
	out:STRING is
			-- a one column layout
		do
			Result:= doctype +
				"%N<html xmlns=%"http://www.w3.org/1999/xhtml%" xml:lang=%"en%" lang=%"en%">" +
				"%N<head>"+
				"%N	<title>" + title + "</title>" +
				charset +
				link +
				"%N</head>"+
				"%N<body>"+

				"%N<table border=%"0%" cellspacing=%"0%" cellpadding=%"0%">" +
				"%N<tbody><tr><td align=%"left%" valign=%"top%">"+

				"%N	<table border=%"0%" cellpadding=%"0%" cellspacing=%"2%" width=%"98%%%"><tbody>" +
				"%N		<tr><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td></tr>" +
				"%N		<tr>"+
				"%N			<td>"+
				"%N				<table><tr><td><a href=%"http://www.informatics-europe.org%">"+get_logo+ "</a></td></tr><tr>%N<td>&nbsp;</td>%N</tr>%N<tr>%N<td>&nbsp;"+
				"%N					</td></tr>"+
				"%N				</table>"+
				"%N			</td>" +
				"%N			<td>&nbsp;</td>"+
				"%N			<td valign=%"baseline%">"+ get_common_header+"</td>"+
				"%N		</tr>" +
				"%N		<tr><td>&nbsp;</td><td>&nbsp;</td><td valign=%"top%"><div class=%"style2%">" + content_header.out + "</div>%N" +
				"%N	<br /><br /><br />" +
				"%N	</td>%N</tr>"+
				"%N	</tbody>"+
				"%N	</table>" +


				"%N	<div id=%"content-middle%" style=%"clear:both;%" ><div class=%"content-columnin%">"+
				"%N"+content_middle.out +
				"%N	</div></div>"+

				"%N	<div class=%"cleaner%">&nbsp;</div>"+




				"%N<div id=%"content-footer%"><div class=%"content-columnin%">"+
				"%N"+content_footer.out+
				"%N"+get_footer +
				"%N</div></div>"+


				"%N</td>%N</tr>"+
				"%N</tbody></table>%N" +

				"%N</body>"+
				"%N</html>"

		end


end
