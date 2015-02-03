import sys
import platform
import os, os.path
from subprocess import call

if platform.system() == 'Windows':
	if 'PROGRAMFILES(X86)' in os.environ:
		ise_platform = 'win64'
	else:
		ise_platform = 'windows'
	eve_exe_name = 'ec.exe'
	os.environ['ISE_C_COMPILER'] = "msc"
elif platform.system() == 'Linux':
	if platform.architecture()[0] == '64bit':
		ise_platform = 'linux-x86-64'
	else:
		ise_platform = 'linux-x86'
	eve_exe_name = 'ec'

# environment variables
os.environ['ISE_PLATFORM'] = ise_platform
os.environ['ISE_EIFFEL'] = os.getcwd()
os.environ['ISE_LIBRARY'] = os.getenv("ISE_EIFFEL")
os.environ['ISE_PRECOMP'] = os.path.join(os.getenv("ISE_EIFFEL"), 'precomp', 'spec', ise_platform)
os.environ['PATH'] = os.path.join(os.getenv("ISE_EIFFEL"), 'studio', 'tools', 'boogie') + os.pathsep + os.path.join(os.getenv("ISE_EIFFEL"), 'studio', 'spec', os.getenv("ISE_PLATFORM"), 'bin') + os.pathsep + os.environ['PATH']

# call eve
call([eve_exe_name, "-gui"])
