##############################################################################
# Joshua Spisak
# joshs333@live.com / jjs231@pitt.edu
#
# This file acts as a build and test script for the assembly project for
# CS 447.
#
# test.sh -r : compiles project and runs tests
##############################################################################
#!/bin/bash
SRC_DIR=./src/
INCLUDE=.:include/hamcrest-all-1.3.jar:include/junit-4.13-beta-2.jar
RUN_INCLUDE=.:../include/hamcrest-all-1.3.jar:../include/junit-4.13-beta-2.jar
BUILD_DIR=class

JAR_PACKAGE=org.junit.runner.JUnitCore
JAR_MAIN=AssemblerTest

# See if build already exists
if [ -d "$BUILD_DIR" ]; then #|| [ -f "$BUILD_JAR" ]; then
    rm -rf $BUILD_DIR/
#    # Make old_build folder if !exist
#    if [ ! -d "old_$BUILD_DIR" ]; then
#        mkdir old_$BUILD_DIR
#    else
#	    # either build or Solver.jar exists
#        # we only want to remove everything
#        # if we have a replacement Solver.jar
#        if [ -f "$BUILD_JAR" ]; then
#            rm -rf old_$BUILD_DIR/
#            mkdir old_$BUILD_DIR
#        else
#            rm -rf old_$BUILD_DIR/$BUILD_DIR/
#        fi
#    fi
#
#    # Now that we have a backup folder let's store stuff
#    if [ -d "$BUILD_DIR" ]; then
#        mv $BUILD_DIR/ old_$BUILD_DIR/$BUILD_DIR/
#    fi
#
#    if [ -f "$BUILD_JAR" ]; then
#        mv $BUILD_JAR old_$BUILD_DIR/
#    fi
fi

# make new build directory
mkdir $BUILD_DIR
# generate class files
javac -cp $INCLUDE -d ./$BUILD_DIR $SRC_DIR/*.java

cd $BUILD_DIR

# Run code if told to
if [ ! -z $1 ]; then
    if [ "$1" == "-r" ]; then
        java -cp $RUN_INCLUDE $JAR_PACKAGE $JAR_MAIN
    fi
fi

cd ..
