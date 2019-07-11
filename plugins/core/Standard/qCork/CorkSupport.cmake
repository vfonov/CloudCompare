# ------------------------------------------------------------------------------
# Quick & dirty Cork+MPIR+CMake support for CloudCompare
# ------------------------------------------------------------------------------

	# Cork library (CC fork) https://github.com/cloudcompare/cork
	set( CORK_INCLUDE_DIR "" CACHE PATH "Cork include directory" )
	set( CORK_RELEASE_LIBRARY_FILE "" CACHE FILEPATH "Cork library file (release mode)" )

	option(CORK_USE_MPIR "Use MPIR library for CORK" OFF)
	option(CORK_USE_GMP "Use GMP library for CORK"  OFF)
	
	if (WIN32)
		set( CORK_DEBUG_LIBRARY_FILE "" CACHE FILEPATH "Cork library file (debug mode)" )
	endif()

	if ( NOT CORK_INCLUDE_DIR )
		message( SEND_ERROR "No Cork include dir specified (CORK_INCLUDE_DIR)" )
	else()
		include_directories( ${CORK_INCLUDE_DIR} )
	endif()

	if(CORK_USE_MPIR)
		set( MPIR_INCLUDE_DIR "" CACHE PATH "MPIR include directory" )
		set( MPIR_RELEASE_LIBRARY_FILE "" CACHE FILEPATH "MPIR library file (release mode)" )
		if (WIN32)
			set( MPIR_DEBUG_LIBRARY_FILE "" CACHE FILEPATH "MPIR library file (debug mode)" )
		endif()

		if ( NOT MPIR_INCLUDE_DIR )
			message( SEND_ERROR "No MPIR include dir specified (MPIR_INCLUDE_DIR)" )
		else()
			include_directories( ${MPIR_INCLUDE_DIR} )
		endif()
	elseif(CORK_USE_GMP)
		set( GMP_INCLUDE_DIR "" CACHE PATH "GMP include directory" )
		set( GMP_LIBRARY_FILE "" CACHE FILEPATH "GMP library file " )
		#include_directories( ${GMP_INCLUDE_DIR} )
	endif()

# Link project with Cork + MPIR library
function( target_link_cork ) # 1 argument: ARGV0 = project name

	if( CORK_RELEASE_LIBRARY_FILE )
	
		#Release mode only by default
		target_link_libraries( ${ARGV0} optimized ${CORK_RELEASE_LIBRARY_FILE} ${MPIR_RELEASE_LIBRARY_FILE} )
		
		if(CORK_USE_MPIR)
			target_link_libraries( ${ARGV0} optimized ${MPIR_RELEASE_LIBRARY_FILE} )
		elseif(CORK_USE_GMP)
			target_link_libraries( ${ARGV0} optimized ${GMP_LIBRARY_FILE} )
		ENDIF()
		
		#optional: debug mode
		if ( CORK_DEBUG_LIBRARY_FILE)
			target_link_libraries( ${ARGV0} debug ${CORK_DEBUG_LIBRARY_FILE}  )

			if(CORK_USE_MPIR)
				target_link_libraries( ${ARGV0} debug ${MPIR_DEBUG_LIBRARY_FILE} )
			endif()

		endif()
		
		# DGM: CC_CORK_SUPPORT preproc is not used
		#if ( CMAKE_CONFIGURATION_TYPES )
		#	#Anytime we use COMPILE_DEFINITIONS_XXX we must define this policy!
		#	#(and setting it outside of the function/file doesn't seem to work...)
		#	cmake_policy(SET CMP0043 OLD)
		#
		#	set_property( TARGET ${ARGV0} APPEND PROPERTY COMPILE_DEFINITIONS_RELEASE CC_CORK_SUPPORT )
		#	set_property( TARGET ${ARGV0} APPEND PROPERTY COMPILE_DEFINITIONS_RELWITHDEBINFO CC_CORK_SUPPORT )
		#	
		#	if ( CORK_DEBUG_LIBRARY_FILE )
		#		set_property( TARGET ${ARGV0} APPEND PROPERTY COMPILE_DEFINITIONS_DEBUG CC_CORK_SUPPORT )
		#	endif()
		#else()
		#	set_property( TARGET ${ARGV0} APPEND PROPERTY COMPILE_DEFINITIONS CC_CORK_SUPPORT )
		#endif()
	
	else() #if ( NOT CORK_RELEASE_LIBRARY_FILE )
	
		message( SEND_ERROR "No Cork or MPIR release library files specified (CORK_RELEASE_LIBRARY_FILE / MPIR_RELEASE_LIBRARY_FILE)" )
	
	endif()

endfunction()
