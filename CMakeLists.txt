cmake_minimum_required(VERSION 3.16)

project(HabitTracker VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appHabitTracker
    main.cpp
    Assets.xcassets
)

qt_add_qml_module(appHabitTracker
    URI HabitTracker
    QML_FILES
        Main.qml
    RESOURCES
        scratch.mp3
    SOURCES habitmanager.h habitmanager.cpp
    RESOURCES .gitignore
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appHabitTracker PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER "codebind.appHabitTracker"
    MACOSX_BUNDLE_BUNDLE_NAME "Atomic Path"
    MACOSX_BUNDLE_DISPLAY_NAME "Atomic Path"
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    XCODE_ATTRIBUTE_ASSETCATALOG_COMPILER_APPICON_NAME "AppIcon"
)

target_link_libraries(appHabitTracker PRIVATE Qt6::Quick Qt6::Multimedia)

if(IOS)
target_link_libraries(appHabitTracker PRIVATE
    "-framework AVFoundation"
    "-framework AudioToolbox"
    "-framework CoreMedia"
    "-framework VideoToolbox"
    "-lbz2"
    "-liconv"
    "-lz"
)
qt_add_ios_ffmpeg_libraries(appHabitTracker)
endif()

include(GNUInstallDirs)
install(TARGETS appHabitTracker
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
