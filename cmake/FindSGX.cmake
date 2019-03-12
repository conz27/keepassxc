set(_default_sgx_path /opt/intel/sgxsdk)
set(_default_sgx_mode "SIM_PRERELEASE")

if(NOT DEFINED SGXSDK_ROOT_PATH)
    set(SGXSDK_ROOT_PATH ${_default_sgx_path})
endif()

if(NOT EXISTS "${SGXSDK_ROOT_PATH}")
    message(FATAL_ERROR "${SGXSDK_ROOT_PATH} does not exist!")
endif()

list(APPEND CMAKE_FRAMEWORK_PATH ${SGXSDK_ROOT_PATH})
include(FindPkgConfig)
pkg_check_modules(SGXSDK REQUIRED QUIET libsgx_urts)

if(NOT DEFINED SGX_MODE)
    set(SGX_MODE ${_default_sgx_mode} CACHE STRING "")
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(_bin_path "x64")
    set(_lib_suffix "64")
else()
    set(_bin_path "x86")
endif()

if(SGX_MODE MATCHES "HW_")
    # Will use actual SGX hardware for execution
    set(SGX_HARDWARE_MODE TRUE)
else()
    # Will use SGX simulation mode
    set(SGX_HARDWARE_MODE FALSE)
    set(_sgx_library_suffix "_sim")
endif()

set(SGXSDK_C_FLAGS)
if(SGX_MODE MATCHES "_DEBUG")
    set(SGX_RELEASE_MODE "DEBUG")
    list(APPEND SGXSDK_C_FLAGS -DDEBUG -UNDEBUG -UEDEBUG)
elseif(SGX_MODE MATCHES "_RELEASE")
    set(SGX_RELEASE_MODE "RELEASE")
    list(APPEND SGXSDK_C_FLAGS -DNDEBUG -UEDEBUG -UDEBUG)
else()
    set(SGX_RELEASE_MODE "PRERELEASE")
    list(APPEND SGXSDK_C_FLAGS -DNDEBUG -DEDEBUG -UDEBUG)
endif()

find_library(SGXSDK_TRTS_LIBRARY
    NAMES libsgx_trts${_sgx_library_suffix}.a
    HINTS ${SGXSDK_ROOT_PATH}
    PATHS ${_default_sgx_path}
    PATH_SUFFIXES lib${_lib_suffix}
    NO_DEFAULT_PATH
    )

find_library(SGXSDK_URTS_LIBRARY
    NAMES libsgx_urts${_sgx_library_suffix}.so
    HINTS ${SGXSDK_ROOT_PATH}
    PATHS ${_default_sgx_path}
    PATH_SUFFIXES lib${_lib_suffix}
    )

find_library(SGXSDK_UAE_SERVICE_LIBRARY
    NAMES libsgx_uae_service${_sgx_library_suffix}.so
    HINTS ${SGXSDK_ROOT_PATH}
    PATHS ${_default_sgx_path}
    PATH_SUFFIXES lib${_lib_suffix}
    )

find_program(SGXSDK_EDGER8R
    NAMES sgx_edger8r
    HINTS ${SGXSDK_ROOT_PATH}
    PATHS ${_default_sgx_path}
    PATH_SUFFIXES bin/${_bin_path}
    NO_DEFAULT_PATH
    )

find_program(SGXSDK_ENCLAVE_SIGNER
    NAMES sgx_sign
    HINTS ${SGXSDK_ROOT_PATH}
    PATHS ${_default_sgx_path}
    PATH_SUFFIXES bin/${_bin_path}
    NO_DEFAULT_PATH
    )

mark_as_advanced(
    SGXSDK_FOUND
    SGXSDK_VERSION
    SGXSDK_INCLUDE_DIRS
    SGXSDK_LIBRARY_DIRS
    SGXSDK_CFLAGS
    SGXSDK_ENCLAVE_SIGNER
    SGXSDK_EDGER8R
    SGXSDK_TRTS_LIBRARY
    SGXSDK_UAE_SERVICE_LIBRARY
    SGXSDK_URTS_LIBRARY
    )
