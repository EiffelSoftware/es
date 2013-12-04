import sys
import os, os.path
from subprocess import call

# environment variables
os.environ['ISE_PLATFORM'] = 'win64'
os.environ['ISE_EIFFEL'] = os.getcwd()
os.environ['ISE_LIBRARY'] = os.getenv("ISE_EIFFEL")
os.environ['ISE_PRECOMP'] = os.path.join(os.getenv("ISE_EIFFEL"), 'precomp', 'spec', 'win64')
os.environ['PATH'] = os.path.join(os.getenv("ISE_EIFFEL"), 'studio', 'tools', 'boogie') + os.pathsep + os.path.join(os.getenv("ISE_EIFFEL"), 'studio', 'spec', os.getenv("ISE_PLATFORM"), 'bin') + os.pathsep + os.environ['PATH']

# call eve
call(["ec.exe", "-gui"])
