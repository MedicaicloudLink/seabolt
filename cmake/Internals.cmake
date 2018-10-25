macro(fix_compiler_settings)
    if (CMAKE_C_COMPILER_ID MATCHES MSVC)
        message(STATUS "Setting C Compiler default warning level to /W4 and defining _CRT_SECURE_NO_WARNINGS")
        list(APPEND setting_list CMAKE_C_FLAGS CMAKE_C_FLAGS_DEBUG CMAKE_C_FLAGS_RELEASE CMAKE_C_FLAGS_MINSIZEREL CMAKE_C_FLAGS_RELWITHDEBINFO)

        foreach (setting ${setting_list})
            # Change default warning level in all C/CXX default compiler settings
            string(REGEX REPLACE "/W[0-4]" "/W4" ${setting} "${${setting}}")
            string(APPEND ${setting} " -D_CRT_SECURE_NO_WARNINGS")
        endforeach (setting)
    endif ()

    if (CMAKE_CXX_COMPILER_ID MATCHES MSVC)
        message(STATUS "Setting CXX Compiler default warning level to /W4 and defining _CRT_SECURE_NO_WARNINGS")
        list(APPEND setting_list CMAKE_CXX_FLAGS CMAKE_CXX_FLAGS_DEBUG CMAKE_CXX_FLAGS_RELEASE CMAKE_CXX_FLAGS_MINSIZEREL CMAKE_CXX_FLAGS_RELWITHDEBINFO)

        foreach (setting ${setting_list})
            # Change default warning level in all C/CXX default compiler settings
            string(REGEX REPLACE "/W[0-4]" "/W4" ${setting} "${${setting}}")
            string(APPEND ${setting} " -D_CRT_SECURE_NO_WARNINGS")
        endforeach (setting)
    endif ()
endmacro()

macro(find_openssl_both)
    unset(OPENSSL_FOUND CACHE)
    unset(OPENSSL_INCLUDE_DIR CACHE)
    unset(OPENSSL_SSL_LIBRARY CACHE)
    unset(OPENSSL_CRYPTO_LIBRARY CACHE)
    unset(OPENSSL_LIBRARIES CACHE)
    unset(OPENSSL_VERSION CACHE)
    find_package(OpenSSL REQUIRED)
    set(OPENSSL_SHARED_INCLUDE_DIR ${OPENSSL_INCLUDE_DIR})
    set(OPENSSL_SHARED_LIBRARIES ${OPENSSL_LIBRARIES})

    unset(OPENSSL_FOUND CACHE)
    unset(OPENSSL_INCLUDE_DIR CACHE)
    unset(OPENSSL_SSL_LIBRARY CACHE)
    unset(OPENSSL_CRYPTO_LIBRARY CACHE)
    unset(OPENSSL_LIBRARIES CACHE)
    unset(OPENSSL_VERSION CACHE)
    set(OPENSSL_USE_STATIC_LIBS ON)
    if (MSVC)
        set(OPENSSL_MSVC_STATIC_RT ON)
    endif ()
    find_package(OpenSSL REQUIRED)

    set(OPENSSL_STATIC_INCLUDE_DIR ${OPENSSL_INCLUDE_DIR})
    set(OPENSSL_STATIC_LIBRARIES ${OPENSSL_LIBRARIES})
endmacro()

macro(set_version)
    if (SEABOLT_VERSION MATCHES "^v?([0-9]+).[0-9]+.[0-9]+")
        set(_VERSION_MAJOR ${CMAKE_MATCH_1})
    endif ()

    if (SEABOLT_VERSION MATCHES "^v?[0-9]+.([0-9]+).[0-9]+")
        set(_VERSION_MINOR ${CMAKE_MATCH_1})
    endif ()

    if (SEABOLT_VERSION MATCHES "^v?[0-9]+.[0-9]+.([0-9]+)")
        set(_VERSION_PATCH ${CMAKE_MATCH_1})
    endif ()

    if (SEABOLT_VERSION MATCHES "^v?[0-9]+.[0-9]+.[0-9]+-([a-zA-Z]+[0-9]+)$")
        set(_VERSION_TWEAK ${CMAKE_MATCH_1})
    endif ()

    if (_VERSION_MAJOR STREQUAL "")
        message(FATAL_ERROR "Version ${PROJECT_VERSION} is not a valid semver version value.")
    endif ()

    if (_VERSION_MINOR STREQUAL "")
        message(FATAL_ERROR "Version ${PROJECT_VERSION} is not a valid semver version value.")
    endif ()

    if (_VERSION_PATCH STREQUAL "")
        message(FATAL_ERROR "Version ${PROJECT_VERSION} is not a valid semver version value.")
    endif ()

    set(PROJECT_VERSION ${SEABOLT_VERSION})
    set(PROJECT_VERSION_MAJOR ${_VERSION_MAJOR})
    set(PROJECT_VERSION_MINOR ${_VERSION_MINOR})
    set(PROJECT_VERSION_PATCH ${_VERSION_PATCH})
    set(PROJECT_VERSION_TWEAK ${_VERSION_TWEAK})
endmacro()

macro(set_names)
    set(SEABOLT_NAME "seabolt${PROJECT_VERSION_MAJOR}${PROJECT_VERSION_MINOR}" CACHE STRING "Seabolt version suffixed name")
    if (CMAKE_SYSTEM_NAME STREQUAL "Windows")
        set(SEABOLT_STATIC_NAME ${SEABOLT_NAME}-static)
    else ()
        set(SEABOLT_STATIC_NAME ${SEABOLT_NAME})
    endif ()
    set(SEABOLT_SHARED "seabolt-shared")
    set(SEABOLT_STATIC "seabolt-static")
    set(SEABOLT_TEST "seabolt-test")
endmacro()

macro(configure_rpath)
    set(CMAKE_SKIP_RPATH OFF)
    set(CMAKE_BUILD_RPATH ${CMAKE_CURRENT_BINARY_DIR}/lib)
    set(CMAKE_MACOSX_RPATH ON)
endmacro()