#!/usr/bin/python
import sys;
import os;
import shutil;
from subprocess import call
from upload_version import upload_version, iron_config;

def safe_rmtree(dn):
	if os.path.exists (dn):
		shutil.rmtree (dn)
	#else:
		#print("rmtree: Folder not found: %s" % (dn))

def safe_copytree(src,tgt):
	if os.path.exists (src):
		print ("Copy tree from %s to %s" % (src, tgt))
		if os.path.exists (tgt):
			safe_rmtree(tgt)
		shutil.copytree(src, tgt)
	else:
		print("copytree: Folder not found: %s" % (src))

def safe_rmfile(fn):
	if os.path.exists (fn):
		os.remove (fn)
	#else:
		#print("rmfile: File not found: %s" % (fn))

def get_ise_libraries(basedir, git_repo_location, br, v):
	if br == 'trunk':
		branch="master"
	else:
		branch="Eiffel_%s" % (v)

	print("Getting source code from %s  ..." % (branch))
	repo_dir = os.path.join (basedir, ".repo")
	if os.path.exists (repo_dir):
		print ("Reuse repo %s" % (repo_dir))
		#call(["echo", "git", "pull", repo_dir ])
	else:
		call(["git", "clone", "--quiet", "--single-branch", "--no-depth", "--branch", branch, git_repo_location, repo_dir ])

	print ("Get library")
	d = os.path.join (basedir, "library")
	if not os.path.exists (d):
		safe_copytree(os.path.join(repo_dir, "Src", "library"), d)
	safe_rmtree (os.path.join (d, "obsolete"))
	safe_rmtree (os.path.join (d, "wizard"))
	safe_rmtree (os.path.join (d, "base", "test"))
	safe_rmtree (os.path.join (d, "base", "testing"))

	d = os.path.join (basedir, "C_library")
	if not os.path.exists (d):
		safe_copytree(os.path.join(repo_dir, "Src", "C_library"), d)
	safe_rmtree (os.path.join (d, "openssl"))
	safe_rmtree (os.path.join (d, "curl"))
	safe_rmfile (os.path.join (d, "build.eant"))

	d = os.path.join (basedir, "contrib")
	if not os.path.exists (d):
		safe_copytree(os.path.join(repo_dir, "Src", "contrib"), d)
	safe_rmtree (os.path.join (d, "examples"))
	safe_rmtree (os.path.join (d, "library", "network", "authentication"))
	safe_rmtree (os.path.join (d, "library", "web", "framework", "ewf", "obsolete"))

            # Do not include sub packages.
	safe_rmfile (os.path.join (d, "library", "web", "framework", "ewf", "libfcgi", "package.iron"))
	safe_rmfile (os.path.join (d, "library", "web", "framework", "ewf", "text", "encoder", "package.iron"))
	safe_rmfile (os.path.join (d, "library", "web", "framework", "ewf", "wsf_html", "package.iron"))
	safe_rmfile (os.path.join (d, "library", "web", "framework", "ewf", "ewsgi", "package.iron"))
	safe_rmfile (os.path.join (d, "library", "web", "framework", "ewf", "wsf", "package.iron"))

	d = os.path.join (basedir, "unstable")
	if not os.path.exists (d):
		safe_copytree(os.path.join(repo_dir, "Src", "unstable"), d)
	alter_folder_with (basedir, os.path.join (basedir, "..", "..", "alter"))
	alter_folder_with (basedir, os.path.join (basedir, "..", "alter"))

def alter_folder_with (a_source, a_alter):
	print("Altering %s with %s." % (a_source, a_alter))
	if os.path.exists (a_alter):
		if os.path.exists (a_source):
			names = os.listdir(a_alter)
			for name in names:
				srcname = os.path.join (a_alter, name)
				if name.endswith(".ecf.tpl") or name.endswith(".e.tpl"):
					dstname = os.path.join (a_source, name[:-3])
				else:
					dstname = os.path.join (a_source, name)
				if os.path.isdir(srcname):
					alter_folder_with (dstname, srcname)
				else:
					shutil.copy2(srcname, dstname)
		else:
			shutil.copytree (a_alter, a_source)
				
def main():
	git_repo_location="git@gitlab.com:eiffelsoftware/es.git"
	if len(sys.argv) > 1:
		cfg_location = sys.argv[1]
		if len(sys.argv) > 2:
			git_repo_location=sys.argv[2]
	else:
		cfg_location = "iron.cfg"

	config = iron_config (cfg_location)
	l_version = config['version']
	l_branch = config['branch']
	l_base_dir = os.path.normpath(os.path.abspath (os.path.join ("VERSIONS", l_version)))
	l_sources_dir = os.path.join (l_base_dir, "sources")
	#l_packages_dir = os.path.join (l_base_dir, "packages")
	if not os.path.exists (l_sources_dir):
		os.makedirs(l_sources_dir)
	get_ise_libraries(l_sources_dir, git_repo_location, l_branch, l_version)

	print("Upload ISE packages ...")
	upload_version(l_sources_dir, cfg_location)

if __name__ == '__main__':
	main()
	sys.exit()
