#!/usr/bin/python
# Remove all the code from a feature and all local variable definitions!
#
# Limitations: Do not write several do's end's or other keywords in one line
#  or things will get very messy!

file = open("ev_dockable_source_imp.e")
lines = file.readlines()

depth = 0
in_feature = False
in_local = False
in_external = False
in_alias = False
in_rescue = False


for line in lines:
	if line.count("local\n"):
		in_local = True
	if line.count("external\n") or line.count("external \n"):
		in_external = True
		print line.replace("external", "do"),
		depth = depth + 1
	if line.count("alias\n"):
		in_external = False
		in_alias = True
	if line.count("once\n"):
		print line,		
		in_local = False
		in_feature = True
	if not in_feature and line.count("do\n"):
		print line,
		in_local = False
		in_feature = True
	if in_feature and (line.count("do\n") or line.count("check\n")or line.count("if ")):
		depth = depth + 1
	if line.count("rescue\n"):
		in_feature = False
		in_rescue = True
	if line.count("end\n") or line.count("end	\n") or line.count("end \n"):
		depth = depth - 1
		if depth == 0 and (in_feature or in_rescue or in_alias or in_external):
			in_feature = False
			in_rescue = False
			in_alias = False
			in_external = False
	if not (in_feature or in_local or in_external or in_alias or in_rescue):
		print line,
	#print str(depth) + " " + str(in_local) + " " + str(in_feature) + " " + str(in_rescue) + " " + str(in_external) + " " + str(in_alias)