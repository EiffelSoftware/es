# mongodb


Update the mongodb.ecf file to force the Windows SDK headers in the correct order:

```xml
<external_cflag 
        value="-DWIN32 -D_WINDOWS -D_WIN32_WINNT=0x0600 -DWINVER=0x0600 -D_CRT_SECURE_NO_WARNINGS -D_WINSOCK_DEPRECATED_NO_WARNINGS">
			<condition>
				<platform value="windows"/>
			</condition>
		</external_cflag>
		<external_cflag value="-DWIN32_LEAN_AND_MEAN">
			<condition>
				<platform value="windows"/>
			</condition>
		</external_cflag>
```


## -DWIN32:
Defines that we're building for Windows 32-bit or 64-bit platforms

## -D_WINDOWS:
Enables Windows-specific features in the Windows headers

## -D_WIN32_WINNT=0x0600 and -DWINVER=0x0600:
Sets the minimum Windows version we're targeting 0x0600 corresponds to Windows Vista. This ensures we have access to newer Windows APIs Particularly important for network-related functions that MongoDB needs

## -D_CRT_SECURE_NO_WARNINGS:
Disables warnings about using "unsafe" C runtime functions
Without this, Visual Studio would warn about functions like sprintf, strcpy, etc.
Suggests using their safer alternatives (sprintf_s, strcpy_s)

## -D_WINSOCK_DEPRECATED_NO_WARNINGS:
Disables warnings about using deprecated Winsock functions
Some network functions MongoDB uses might be marked as deprecated
This prevents compiler warnings about them

## -DWIN32_LEAN_AND_MEAN:
Excludes rarely-used Windows headers. Helps prevent conflicts between windows.h and winsock2.h. Reduces compilation time and potential header conflicts

Tutorial: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-windows/

Driver: https://github.com/mongodb/mongo-c-driver


