set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR "neo4j")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "seabolt: The C Connector Library for Neo4j")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://github.com/neo4j-drivers/seabolt")

set(CPACK_RESOURCE_FILE_LICENSE "${PROJECT_SOURCE_DIR}/LICENSE")

set(CPACK_MONOLITHIC_INSTALL ON)
if (WIN32 OR MINGW)
    unset(CPACK_PACKAGING_INSTALL_PREFIX)
else ()
    set(CPACK_PACKAGING_INSTALL_PREFIX "/usr/local")
endif ()

set(CPACK_PACKAGE_VERSION_MAJOR "${PROJECT_VERSION_MAJOR}")
set(CPACK_PACKAGE_VERSION_MINOR "${PROJECT_VERSION_MINOR}")
set(CPACK_PACKAGE_VERSION_PATCH "${PROJECT_VERSION_PATCH}")
set(CPACK_PACKAGE_VERSION_TWEAK "${PROJECT_VERSION_TWEAK}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")

set(CPACK_PACKAGE_CHECKSUM "SHA256")
set(CPACK_SOURCE_IGNORE_FILES "${PROJECT_BINARY_DIR};/.git/;.gitignore;menu.yml")
set(CPACK_SOURCE_GENERATOR "ZIP;TGZ")
set(CPACK_GENERATOR "ZIP;TGZ")
set(CPACK_PACKAGE_DIRECTORY "${PROJECT_BINARY_DIR}/dist-package")

if (UNIX)
    if (CMAKE_SYSTEM_NAME MATCHES Linux)
        list(APPEND CPACK_GENERATOR "DEB")
        set(CPACK_DEBIAN_PACKAGE_NAME "${SEABOLT_NAME}")
        set(CPACK_DEBIAN_PACKAGE_VERSION "${PROJECT_VERSION}")
        set(CPACK_DEBIAN_PACKAGE_MAINTAINER "neo4j")
        set(CPACK_DEBIAN_PACKAGE_SECTION "devel")
        set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)
        set(CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA "${CMAKE_CURRENT_SOURCE_DIR}/cmake/package/deb/postinst;${CMAKE_CURRENT_SOURCE_DIR}/cmake/package/deb/postrm;" )

        list(APPEND CPACK_GENERATOR "RPM")
        set(CPACK_RPM_PACKAGE_NAME "${SEABOLT_NAME}")
        set(CPACK_RPM_PACKAGE_RELEASE "1")
        set(CPACK_RPM_PACKAGE_LICENSE "Apache")
        set(CPACK_RPM_POST_INSTALL_SCRIPT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/package/rpm/post")
        set(CPACK_RPM_POST_UNINSTALL_SCRIPT_FILE "${CMAKE_CURRENT_SOURCE_DIR}/cmake/package/rpm/postun")
    endif ()
endif ()

message(STATUS "CPack generators: ${CPACK_GENERATOR}")

include(CPack)