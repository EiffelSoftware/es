indexing
	description: "Objects that factorize specific code used for building HTML pages"
	author: "Marco Piccioni"
	date: "$Date$"
	revision: "$Revision 0.3.1$"

class
	HTML_DELEGATE

inherit
	APPLICATION_CONSTANTS

feature -- Access

	countries: ARRAY[STRING] --the United Nations countries array
	contact_roles: ARRAY[STRING] --the contact roles array
	days: ARRAY[STRING] --the days array
	months: ARRAY[STRING] --the months array
	years: ARRAY[STRING] --the years array

feature	--html page factory methods

	get_meta_tag:STRING
			--meta tag
		do
			Result:="<meta http-equiv=%"Content-Type%" content=%"text/html; charset=iso-8859-1%">%N"
		end

	get_css:STRING
			--css
		do
			Result:="<link href=%""+Css_path+"%" rel=%"stylesheet%" type=%"text/css%" media=%"screen%">%N"
		end

	get_logo:STRING
			--logo
		do
			Result:="<img src=%""+Img_path+"informatics_europe_logo_sma.gif%" height=%"28%" width=%"100%" alt=%"%" />"
		end

	get_common_header:STRING
			--header common to all pages
		do
			Result:="<div class=%"style2%"><p>The Computer Science Event List</p></div>"
			Result.append("<div class=%"style2%"><h2>A service of Informatics Europe</h2></div>")
		end

	get_footer:STRING
			--hyperlink and info
		do
			Result:="<p class=%"heading1_subtitle%" style=%"text-align:center;%"><a href=%""+Main_website+"%">Informatics Europe:<br />"
			Result.append("&nbsp;The Research and Education Organization <br />of Computer Science and IT Departments in Europe</a></p><br />")
			Result.append("<p class=%"heading2_subtitle%" style=%"text-align:center;%"><a href=%""+Acknowledgements_page+"%">About the Computer Science Event List</a></p>")
		end

feature -- creation

	make
		--creates and initializes the contact_roles, the UN countries arrays and the arrays for days, months and years
		local
			index:INTEGER
		do
			create contact_roles.make(1,4)
			contact_roles[1]:="Event chair"
			contact_roles[2]:="Program committee chair"
			contact_roles[3]:="Organizing chair"
			contact_roles[4]:="Other"
			create countries.make(0,UN_countries_number)
			countries[0]:="Please choose"
			countries[1]:="Afghanistan"
			countries[2]:="Algeria"
			countries[3]:="Albania"
			countries[4]:="Andorra"
			countries[5]:="Angola"
			countries[6]:="Antigua and Barbuda"
			countries[7]:="Argentina"
			countries[8]:="Armenia"
			countries[9]:="Australia"
			countries[10]:="Austria"
			countries[11]:="Azerbaijan"
			countries[12]:="Bahamas"
			countries[13]:="Bahrain"
			countries[14]:="Bangladesh"
			countries[15]:="Barbados"
			countries[16]:="Belarus"
			countries[17]:="Belgium"
			countries[18]:="Belize"
			countries[19]:="Benin"
			countries[20]:="Bhutan"
			countries[21]:="Bolivia"
			countries[22]:="Bosnia and Herzegovina"
			countries[23]:="Botswana"
			countries[24]:="Brazil"
			countries[25]:="Brunei"
			countries[26]:="Bulgaria"
			countries[27]:="Burkina Faso"
			countries[28]:="Burundi"
			countries[29]:="Cambodia"
			countries[30]:="Cameroon"
			countries[31]:="Canada"
			countries[32]:="Cape Verde"
			countries[33]:="Central African Republic"
			countries[34]:="Chad"
			countries[35]:="Chile"
			countries[36]:="China"
			countries[37]:="Colombia"
			countries[38]:="Comoros"
			countries[39]:="Democratic Republic of the Congo"
			countries[40]:="Republic of the Congo"
			countries[41]:="Costa Rica"
			countries[42]:="Côte d'Ivorie"
			countries[43]:="Croatia"
			countries[44]:="Cuba"
			countries[45]:="Cyprus"
			countries[46]:="Czech Republic"
			countries[47]:="Denmark"
			countries[48]:="Djibouti"
			countries[49]:="Dominica"
			countries[50]:="Dominican Republic"
			countries[51]:="Ecuador"
			countries[52]:="Egypt"
			countries[53]:="El Salvador"
			countries[54]:="Equatorial Guinea"
			countries[55]:="Eritrea"
			countries[56]:="Estonia"
			countries[57]:="Ethiopia"
			countries[58]:="Fiji"
			countries[59]:="Finland"
			countries[60]:="France"
			countries[61]:="Gabon"
			countries[62]:="Gambia"
			countries[63]:="Georgia"
			countries[64]:="Germany"
			countries[65]:="Ghana"
			countries[66]:="Greece"
			countries[67]:="Grenada"
			countries[68]:="Guatemala"
			countries[69]:="Guinea"
			countries[70]:="Guinea-Bissau"
			countries[71]:="Guyana"
			countries[72]:="Haiti"
			countries[73]:="Honduras"
			countries[74]:="Hungary"
			countries[75]:="Iceland"
			countries[76]:="India"
			countries[77]:="Indonesia"
			countries[78]:="Iran"
			countries[79]:="Iraq"
			countries[80]:="Ireland"
			countries[81]:="Israel"
			countries[82]:="Italy"
			countries[83]:="Jamaica"
			countries[84]:="Japan"
			countries[85]:="Jordan"
			countries[86]:="Kazakhstan"
			countries[87]:="Kenya"
			countries[88]:="Kiribati"
			countries[89]:="Democratic People's Republic of Korea"
			countries[90]:="Republic of Korea"
			countries[91]:="Kuwait"
			countries[92]:="Kyrgyzstan"
			countries[93]:="Laos"
			countries[94]:="Latvia"
			countries[95]:="Lebanon"
			countries[96]:="Lesotho"
			countries[97]:="Liberia"
			countries[98]:="Libya"
			countries[99]:="Liechtenstein"
			countries[100]:="Lithuania"
			countries[101]:="Luxembourg"
			countries[102]:="Macedonia"
			countries[103]:="Madagascar"
			countries[104]:="Malawi"
			countries[105]:="Malaysia"
			countries[106]:="Maldives"
			countries[107]:="Mali"
			countries[108]:="Malta"
			countries[109]:="Marshall Islands"
			countries[110]:="Mauritania"
			countries[111]:="Mauritius"
			countries[112]:="Mexico"
			countries[113]:="Micronesia"
			countries[114]:="Moldova"
			countries[115]:="Monaco"
			countries[116]:="Mongolia"
			countries[117]:="Montenegro"
			countries[118]:="Morocco"
			countries[119]:="Mozambique"
			countries[120]:="Myanmar"
			countries[121]:="Namibia"
			countries[122]:="Nauru"
			countries[123]:="Nepal"
			countries[124]:="Netherlands"
			countries[125]:="New Zealand"
			countries[126]:="Nicaragua"
			countries[127]:="Niger"
			countries[128]:="Nigeria"
			countries[129]:="Norway"
			countries[130]:="Oman"
			countries[131]:="Pakistan"
			countries[132]:="Palau"
			countries[133]:="Panama"
			countries[134]:="Papua New Guinea"
			countries[135]:="Paraguay"
			countries[136]:="Peru"
			countries[137]:="Philippines"
			countries[138]:="Poland"
			countries[139]:="Portugal"
			countries[140]:="Qatar"
			countries[141]:="Romania"
			countries[142]:="Russia"
			countries[143]:="Rwanda"
			countries[144]:="Saint Kitts and Nevis"
			countries[145]:="Saint Lucia"
			countries[146]:="Saint Vincent and the Grenadines"
			countries[147]:="Samoa"
			countries[148]:="San Marino"
			countries[149]:="Sao Tome and Principe"
			countries[150]:="Saudi Arabia"
			countries[151]:="Senegal"
			countries[152]:="Serbia"
			countries[153]:="Seychelles"
			countries[154]:="Sierra Leone"
			countries[155]:="Singapore"
			countries[156]:="Slovakia"
			countries[157]:="Slovenia"
			countries[158]:="Solomon Islands"
			countries[159]:="Somalia"
			countries[160]:="South Africa"
			countries[161]:="Spain"
			countries[162]:="Sri Lanka"
			countries[163]:="Sudan"
			countries[164]:="Suriname"
			countries[165]:="Swaziland"
			countries[166]:="Sweden"
			countries[167]:="Switzerland"
			countries[168]:="Syria"
			countries[169]:="Tajikistan"
			countries[170]:="Tanzania"
			countries[171]:="Thailand"
			countries[172]:="Timor-Leste"
			countries[173]:="Togo"
			countries[174]:="Tonga"
			countries[175]:="Trinidad and Tobago"
			countries[176]:="Tunisia"
			countries[177]:="Turkey"
			countries[178]:="Turkmenistan"
			countries[179]:="Tuvalu"
			countries[180]:="Uganda"
			countries[181]:="Ukraine"
			countries[182]:="United Arab Emirates"
			countries[183]:="United Kingdom"
			countries[184]:="United States"
			countries[185]:="Uruguay"
			countries[186]:="Uzbekistan"
			countries[187]:="Vanuatu"
			countries[188]:="Venezuela"
			countries[189]:="Vietnam"
			countries[190]:="Yemen"
			countries[191]:="Zambia"
			countries[192]:="Zimbabwe"
			create days.make(1,32)
			from
				index:=1
			until
				index>days.count
			loop
				days[index]:=index.out
				index:=index+1
			end
			days[32]:="n/a"
			create months.make(1,13)
			from
				index:=1
			until
				index>months.count
			loop
				months[index]:=index.out
				index:=index+1
			end
			months[13]:="n/a"
			create years.make(1,30)
			from
				index:=1
			until
				index > years.count
			loop
				years[index]:=(index+2000).out
				index:=index+1
			end
			years[30]:="n/a"
			ensure
				countries_created: countries /=Void AND THEN countries.count=UN_countries_number+1
				contact_roles_created: contact_roles /=Void
				days_created: days /=Void
				months_created: months /=Void
				years_created: years /=Void
		end

invariant
	invariant_clause: True -- Your invariant here

end
