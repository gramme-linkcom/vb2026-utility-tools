cmake_minimum_required (VERSION 3.10)

# 下記にvcpkgのルートディレクトリを入力してください。
set(VCPKG_ROOT "C:/programs_data_usr")
set(CMAKE_TOOLCHAIN_FILE "${VCPKG_ROOT}/vcpkg/scripts/buildsystems/vcpkg.cmake" CACHE STRING "vcpkg toolchain")

# サポートされている場合は、MSVC コンパイラのホット リロードを有効にします。
if (POLICY CMP0141)
  cmake_policy(SET CMP0141 NEW)
  set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "$<IF:$<AND:$<C_COMPILER_ID:MSVC>,$<CXX_COMPILER_ID:MSVC>>,$<$<CONFIG:Debug,RelWithDebInfo>:EditAndContinue>,$<$<CONFIG:Debug,RelWithDebInfo>:ProgramDatabase>>")
endif()

project ("vb2026-utility-tools")

# -------------------------------------------------------------------
# Qt5 用の自動処理設定 (MOC, RCC, UIC)
# -------------------------------------------------------------------
# Qt特有のメタオブジェクトコンパイラや、UIファイル、リソースファイルを自動処理します。
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# -------------------------------------------------------------------
# vcpkg から Qt5 の必要なパッケージを検索
# -------------------------------------------------------------------
# カメラ映像（Multimedia）やリッチなUI（Quick/QML）、基本のWidgetsなどを読み込みます。
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Multimedia MultimediaWidgets Quick Qml)

file(GLOB ALL_SOURCES 
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h"
    "${CMAKE_CURRENT_SOURCE_DIR}/ui/*.qml"
)

# ソースをこのプロジェクトの実行可能ファイルに追加します。
add_executable (vb2026-utility-tools "vb2026-utility-tools.cpp" "vb2026-utility-tools.h" ${ALL_SOURCES})

if (MSVC)
  target_compile_options(vb2026-utility-tools PRIVATE "/utf-8")
endif()

if (CMAKE_VERSION VERSION_GREATER 3.12)
  set_property(TARGET vb2026-utility-tools PROPERTY CXX_STANDARD 20)
endif()

# -------------------------------------------------------------------
# ターゲットに Qt5 ライブラリをリンク
# -------------------------------------------------------------------
target_link_libraries(vb2026-utility-tools PRIVATE
    Qt5::Core
    Qt5::Widgets
    Qt5::Multimedia
    Qt5::MultimediaWidgets
    Qt5::Quick
    Qt5::Qml
)

add_custom_command(
    TARGET vb2026-utility-tools POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
            "${CMAKE_CURRENT_SOURCE_DIR}/UI"
            "$<TARGET_FILE_DIR:vb2026-utility-tools>/ui"
    COMMENT "ui フォルダを丸ごとビルドディレクトリにコピー中..."
)