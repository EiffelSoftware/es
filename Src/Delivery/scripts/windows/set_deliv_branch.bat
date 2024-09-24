@echo off
set STUDIO_VERSION_MAJOR_MINOR=%1

::set DEFAULT_PUBLIC_SVN=https://svn.eiffel.com/eiffelstudio/branches/Eiffel_%STUDIO_VERSION_MAJOR_MINOR%
set DEFAULT_ES_ROOT=https://gitlab.com/eiffelsoftware/es.git
set DEFAULT_ES_BRANCH=Eiffel_%STUDIO_VERSION_MAJOR_MINOR%

set DEFAULT_ISE_SVN=svn://svn.ise/ise_svn/branches/Eiffel_%STUDIO_VERSION_MAJOR_MINOR%

echo Version: %STUDIO_VERSION_MAJOR_MINOR%
echo Public repository: %DEFAULT_ES_ROOT% branch %DEFAULT_ES_BRANCH%
echo ISE    repository: %DEFAULT_ISE_SVN%
