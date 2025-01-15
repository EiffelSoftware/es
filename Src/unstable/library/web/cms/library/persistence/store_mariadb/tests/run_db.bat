set op=%1

if "%op%" EQU "start" goto START
if "%op%" EQU "stop" goto STOP

echo Usage: start, stop
goto EOF

:START
docker run --rm ^
	--detach ^
	--name test_cms_dev ^
	--env MARIADB_USER=foo ^
	--env MARIADB_PASSWORD=bar ^
	--env MARIADB_DATABASE=cms_dev ^
	--env MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1 ^
	-p 3306:3306 ^
	mariadb:latest

	REM --env MARIADB_ROOT_PASSWORD=my-secret-pw  ^
goto EOF

:STOP
docker stop test_cms_dev
goto EOF


:EOF
