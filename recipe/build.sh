#!/bin/bash

set -ex

mkdir build
pushd build
cmake ${CMAKE_ARGS} -GNinja \
  -DCMAKE_PREFIX_PATH=$PREFIX \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_SHARED_LIBS=ON \
  -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
  -DBUILD_TESTING=ON \
  ..

cmake --build . --config Release --target install

# Following tests failed with error Certificate has expired 
  EXCLUDE_ROOT_TESTS="\
connection_setup_shutdown_tls|\
connection_customized_alpn|\
connection_h2_prior_knowledge_not_work_with_tls|\
connection_customized_alpn_error_with_unknown_return_string|\
connection_manager_single_http2_connection_failed"

  ctest -E "$EXCLUDE_ROOT_TESTS" --output-on-failure -j${CPU_COUNT}
popd