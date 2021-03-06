-- Premake5 file to generate project files for all supported platforms
-- Author: Steven Savold

-- workspace (Solution) for the entire emulator 
workspace "6502emu"
    architecture "x86"
    configurations
    {
         "Debug",
         "Release"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- The build spec for the Shared Library for the 6502 cpu emulator
project "cpu6502"
    location "cpu6502"
    kind "SharedLib"
    language "C++"
    cppdialect "C++17"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader "%{prj.name}/src/6502pch.h"
    pchsource "%{prj.name}/src/6502pch.cpp"

    files
    {
        "%{prj.name}/src/**.cpp",
        "%{prj.name}/src/**.h"
    }

	includedirs
    {
	"cpu6502/src/",
        "vendor/spdlog/include/"
    }

    sysincludedirs
    {
	"cpu6502/src/",
        "vendor/spdlog/include/"
    }

    -- Filter for windows system only
    filter "system:windows"
        staticruntime "On"
        systemversion "latest"
        
        defines
        {
            "_6502_PLATFORM_WINDOWS",
            "_6502_BUILD_DLL"
        }

        postbuildcommands
        {
           ("{COPY} %{cfg.buildtarget.relpath} ../bin" .. outputdir .. "/example6502") 
        }

    -- Filter for Linux system only
    filter "system:linux"
        defines
        {
            "_6502_PLATFORM_LINUX"
        }

    -- Filter for MacOS system only
    filter "system:macosx"
        defines
        {
            "_6502_PLATFORM_MACOSX"
        }

    -- Filter for Debug configuration
    filter "configurations:Debug"
        defines 
        {
            "_6502_DEBUG"
        }
        symbols "On" -- turn debug symbols ON

    -- Filter for Release configuration
    filter "configurations:Release"
        defines 
        {
            "_6502_RELEASE"
        }
        optimize "On"


-- The build spec for the Executable for the 6502 cpu emulator example project
project "example6502"
    location "example6502"
    kind "ConsoleApp"
    language "C++"
    cppdialect "C++17"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files
    {
        "%{prj.name}/**.cpp",
        "%{prj.name}/**.h"
    }

    includedirs
    {
        "cpu6502/src/",
	    "vendor/spdlog/include/"
    }

    sysincludedirs
    {
        "cpu6502/src/",
	    "vendor/spdlog/include/"
    }

    links
    {
        "cpu6502" -- link with cpu6502 project
    }

    -- Filter for windows system only
    filter "system:windows"
        staticruntime "On"
        systemversion "latest"
        
        defines
        {
            "_6502_PLATFORM_WINDOWS"
        }

    -- Filter for Linux system only
    filter "system:linux"
        defines
        {
            "_6502_PLATFORM_LINUX"
        }

    -- Filter for MacOS system only
    filter "system:macosx"
        defines
        {
            "_6502_PLATFORM_MACOSX"
        }

    -- Filter for Debug configuration
    filter "configurations:Debug"
        defines 
        {
            "_6502_DEBUG"
        }
        symbols "On" -- turn debug symbols ON

    -- Filter for Release configuration
    filter "configurations:Release"
        defines 
        {
            "_6502_RELEASE"
        }
        optimize "On"
