cmake_minimum_required(VERSION 2.8)
project(liblightnvm_tests C)
include(FeatureSummary)

find_package(cunit REQUIRED liblightnvm_tests)
set_package_properties(cunit PROPERTIES DESCRIPTION "libcunit")
set_package_properties(cunit PROPERTIES TYPE REQUIRED PURPOSE "Tests depends on libcunit")

if ( NOT ${CUNIT_FOUND} )
	message(FATAL_ERROR
		"Please install libcunit (e.g. 'libcunit1-dev' on Ubuntu 16.04)")
endif()

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DNVM_DEBUG_ENABLED")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")

include_directories("${CUNIT_INCLUDE_DIR}")
include_directories("${PROJECT_SOURCE_DIR}/../include")
include_directories("${PROJECT_SOURCE_DIR}/../include/linux/uapi")

link_directories("/tmp/nvm_install/lib")

add_executable(nvm_test_dev
	${PROJECT_SOURCE_DIR}/test_dev.c)
target_link_libraries(nvm_test_dev lightnvm pthread udev cunit)
install(TARGETS nvm_test_dev DESTINATION bin)

add_executable(nvm_test_tgt
	${PROJECT_SOURCE_DIR}/test_tgt.c)
target_link_libraries(nvm_test_tgt lightnvm pthread udev cunit)
install(TARGETS nvm_test_tgt DESTINATION bin)

add_executable(nvm_test_vblock
	${PROJECT_SOURCE_DIR}/test_vblock.c)
target_link_libraries(nvm_test_vblock lightnvm pthread udev cunit)
install(TARGETS nvm_test_vblock DESTINATION bin)

add_executable(nvm_test_mgmt
	${PROJECT_SOURCE_DIR}/test_mgmt.c)
target_link_libraries(nvm_test_mgmt lightnvm pthread udev cunit)
install(TARGETS nvm_test_mgmt DESTINATION bin)

add_executable(nvm_test_beam
	${PROJECT_SOURCE_DIR}/test_beam.c)
target_link_libraries(nvm_test_beam lightnvm pthread udev cunit)
install(TARGETS nvm_test_beam DESTINATION bin)
