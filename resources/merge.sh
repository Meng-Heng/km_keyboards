#!/bin/bash

#----------------------------------------------------------------------------------------
# Merge the source .keyboard_info with data gleaned from the output files and place
# the result in the build/ folder
#----------------------------------------------------------------------------------------

function merge_keyboard_info {
  local keyboard_info=$1
  
  echo "Merging $keyboard_info"
  
  cp "$keyboard_info" "build/$keyboard_info" || die
  
  # Need to call into something that reads the .kmp/.kmx and .js data ... yeesh
  
  #
  # Call nodejs to load data from .kmp's kmp.inf into a variable
  # And load the .js data at the same time
  #
  
  #
  # For release/ folder, we can deduce packageFilename and jsFilename
  #
   
  if [ ! -n "$keyboard_info_packageFilename" ]; then
    # See if a .kmp file exists in the build/ folder
    local packages=(build/*.kmp)
    if [ -f "${packages[0]}" ]; then
      keyboard_info_packageFilename=`basename "${packages[0]}"`
    fi
  fi
  
  if [ ! -n "$keyboard_info_jsFilename" ]; then
    # See if a .js file exists in the build/ folder
    local jsfiles=(build/*.js)
    if [ -f "${jsfiles[0]}" ]; then
      keyboard_info_jsFilename=`basename "${jsfiles[0]}"`
    fi
  fi
  
  local pOut=build/"$keyboard_info"
  local pInKmp=
  local pInKmpM=
  local pInJs=
  local pInJsM=
  echo build/"$keyboard_info_packageFilename"
  if [ -f build/"$keyboard_info_packageFilename" ]; then
    pInKmp=build/"$keyboard_info_packageFilename"
    pInKmpM=-m
  fi

  if [ -f build/"$keyboard_info_jsFilename" ]; then
    pInJs=build/"$keyboard_info_jsFilename"
    pInJsM=-m
  fi
  
  echo "$KMCOMP" $pInKmpM "$pInKmp" $pInJsM "$pInJsM" "$pOut" || die "Failed to merge keyboard_info for $1"
  
  return 0
}
