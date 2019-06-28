if( CMAKE_CXX_STANDARD )
  # check for downgrade
  if( NOT (( ${CMAKE_CXX_STANDARD} GREATER_EQUAL 98 ) OR ( ${CMAKE_CXX_STANDARD} LESS_EQUAL 14 )))
    message( SEND_ERROR "we don't support downgrading std standard" )
  endif()
endif()

set( CMAKE_CXX_STANDARD 14 )
set( CMAKE_CXX_STANDARD_REQUIRED ON )