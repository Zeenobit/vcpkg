if(VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    message(FATAL_ERROR "${PORT} currently doesn't supports UWP.")
endif()

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO LukasBanana/LLGL
    REF e7ee7ef7a0c8f4168863d9ea6e28ae53e55330d8
    SHA512 c0142f4f76887425f81c74a3969d5769da2eff9c41aed8bc8d1fdf9c98681c8629350e6fbd393630bf4b79f1a4ca5809cee1eb177b0a4df498e3026f2a81d5aa
    HEAD_REF master
    PATCHES 
        fix-install-error.patch
)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    opengl     LLGL_BUILD_RENDERER_OPENGL
    direct3d11 LLGL_BUILD_RENDERER_DIRECT3D11 
    direct3d12 LLGL_BUILD_RENDERER_DIRECT3D12 
    vulkan     LLGL_BUILD_RENDERER_VULKAN
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA 
    OPTIONS ${FEATURE_OPTIONS}
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
      file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

vcpkg_copy_pdbs()

# Handle copyright
file(INSTALL ${SOURCE_PATH}/LICENSE.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)