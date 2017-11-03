@where /q cl
@if errorlevel 1 (
    @set "DevEnvDir=C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\"
    @set "Framework35Version=v3.5"
    @set "FrameworkDir=C:\Windows\Microsoft.NET\Framework\"
    @set "FrameworkDIR32=C:\Windows\Microsoft.NET\Framework\"
    @set "FrameworkVersion=v4.0.30319"
    @set "FrameworkVersion32=v4.0.30319"
    @set "INCLUDE=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\INCLUDE;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\INCLUDE;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\include;"
    @set "LIB=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\lib;"
    @set "LIBPATH=C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\LIB;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\ATLMFC\LIB;"
    @set "VCINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\"
    @set "VSINSTALLDIR=C:\Program Files (x86)\Microsoft Visual Studio 10.0\"
    @set "WindowsSdkDir=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\"
    @set "Path=C:\Program Files (x86)\Microsoft Visual Studio 10.0\VSTSDB\Deploy;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\IDE\;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\BIN;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Common7\Tools;C:\Windows\Microsoft.NET\Framework\v4.0.30319;C:\Windows\Microsoft.NET\Framework\v3.5;C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\VCPackages;C:\Program Files (x86)\HTML Help Workshop;C:\Program Files (x86)\Microsoft Visual Studio 10.0\Team Tools\Performance Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin\NETFX 4.0 Tools;C:\Program Files (x86)\Microsoft SDKs\Windows\v7.0A\bin;%PATH%"
)

@msbuild /m sanguo.sln
