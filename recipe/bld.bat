mkdir "%SRC_DIR%"\build
pushd "%SRC_DIR%"\build

cmake -GNinja ^
      -DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX% ^
      -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
      -DCMAKE_INSTALL_LIBDIR=lib ^
      -DCMAKE_BUILD_TYPE=Release ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_TESTING=ON ^
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON ^
      ..
if errorlevel 1 exit 1

cmake --build . --config Release --target install
if errorlevel 1 exit 1

set "EXCLUDE_ROOT_TESTS=^
connection_setup_shutdown_tls|^
connection_customized_alpn|^
connection_customized_alpn_error_with_unknown_return_string|^
connection_manager_single_http2_connection_failed"

ctest -E "%EXCLUDE_ROOT_TESTS%" --output-on-failure
if errorlevel 1 exit 1