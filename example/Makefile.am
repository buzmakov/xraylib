#Copyright (c) 2009,2010, Tom Schoonjans
#All rights reserved.

#Redistribution and use in source and binary forms, with or without
#modification, are permitted provided that the following conditions are met:
#    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
#    * The names of the contributors may not be used to endorse or promote products derived from this software without specific prior written permission.

#THIS SOFTWARE IS PROVIDED BY Tom Schoonjans ''AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Tom Schoonjans BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#Makefile.am for the examples. These can be used to verify that the compilation went ok by typing in "make check" 


AM_CPPFLAGS = -I${top_srcdir}/include -I${top_builddir}/include


#since the C lib will always be built, always check xrlexample1
check_PROGRAMS = xrlexample1$(EXEEXT)
if ENABLE_FORTRAN
  check_PROGRAMS += xrlexample3
endif
check_SCRIPTS=
if ENABLE_PERL
  check_SCRIPTS += xrlexample2.sh
endif
if ENABLE_IDL
  check_SCRIPTS += xrlexample4.sh
endif
if ENABLE_PYTHON
  check_SCRIPTS += xrlexample5.sh
endif
if ENABLE_CXX
  check_PROGRAMS += xrlexample6$(EXEEXT)
endif
if ENABLE_JAVA
  check_SCRIPTS += xrlexample7.sh
endif
if ENABLE_LUA
  check_SCRIPTS += xrlexample9.sh
endif
if ENABLE_RUBY
  check_SCRIPTS += xrlexample10.sh
endif
if ENABLE_PHP
  check_SCRIPTS += xrlexample12.sh
endif
if ENABLE_PYTHON_NUMPY
  check_SCRIPTS += xrlexample13.sh
endif


xrlexample1_SOURCES = xrlexample1.c
xrlexample1_LDADD = ../src/libxrl.la
xrlexample1_CPPFLAGS = -I${top_srcdir}/include -I${top_builddir}/include
xrlexample1_CFLAGS = $(ARCHFLAGS)

if ENABLE_FORTRAN
  xrlexample3_SOURCES = xrlexample3.f90 
  xrlexample3_LDADD = ../fortran/libxrlf03.la ../src/libxrl.la
  xrlexample3_CPPFLAGS = -I../fortran
  xrlexample3_FFLAGS = ${xrlexample3_CPPFLAGS} $(ARCHFLAGS)
  xrlexample3_FCFLAGS = ${xrlexample3_CPPFLAGS}
endif

if ENABLE_CXX
  xrlexample6_SOURCES = xrlexample6.cpp
  xrlexample6_LDADD = ../src/libxrl.la
endif



if ENABLE_CROSS
TESTS_ENVIRONMENT = path="${top_builddir}/src/.libs" $(WINE)
endif

TESTS = $(check_PROGRAMS) $(check_SCRIPTS)
#AM_TESTS_FD_REDIRECT = 9>&2

EXTRA_DIST = xrlexample4.pro xrlexample2.pl xrlexample5.py xrlexample7.java xrlexample8.cs xrlexample9.lua xrlexample10.rb xrlexample12.php xrlexample13.py


#test the idl bindings using this script
xrlexample4.sh: ../idl/libxrlidl.la xrlexample4.pro
	@echo "Testing IDL bindings"
	@echo "unset IDL_STARTUP" > xrlexample4.sh
	@echo "cp ${top_srcdir}/idl/libxrlidl.dlm ${top_builddir}/idl/.libs/libxrlidl.dlm" >> xrlexample4.sh
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" IDL_PATH=\"${top_srcdir}/example:${top_srcdir}/idl:<IDL_DEFAULT>\" IDL_DLM_PATH=\"${top_builddir}/idl/.libs:<IDL_DEFAULT>\" @RSIIDL_BINDIR@/idl xrlexample4" >> xrlexample4.sh
	@echo "rm -f ${top_builddir}/idl/.libs/libxrlidl.dlm" >> xrlexample4.sh
	@chmod +x xrlexample4.sh	

#test the perl bindings
xrlexample2.sh: ../perl/xraylib.pm xrlexample2.pl
	@echo "Testing perl bindings"
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" PERL5LIB=\"${top_builddir}/perl/.libs/:${top_builddir}/perl\" $(PERL) ${top_srcdir}/example/xrlexample2.pl" > xrlexample2.sh
	@chmod +x xrlexample2.sh

#test the python bindings
xrlexample5.sh: ../python/_xraylib.la xrlexample5.py
	@echo "Testing python bindings"
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" PYTHONPATH=\"${top_builddir}/python:${top_builddir}/python/.libs\" $(PYTHON) ${top_srcdir}/example/xrlexample5.py" > xrlexample5.sh
	@chmod +x xrlexample5.sh

#test the java bindings
xrlexample7.sh: ../java/xraylib.java xrlexample7.java
	@echo "Testing java bindings"
	@echo "$(JAVAC) -classpath \"${top_builddir}/java:.:..\" -d \"${builddir}\" ${top_srcdir}/example/xrlexample7.java" > xrlexample7.sh
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs:${top_builddir}/java/\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs:${top_builddir}/java/\" $(JAVA) -Djava.library.path=\"${top_builddir}/java/.libs\" -classpath \"${top_builddir}/java:.:..\" xrlexample7" >> xrlexample7.sh
	@chmod +x xrlexample7.sh

#test the lua bindings
xrlexample9.sh: ../lua/xraylib.la xrlexample9.lua
	@echo "Testing lua bindings"
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" LUA_CPATH=\"${top_builddir}/lua/.libs/?.so\" lua  ${top_srcdir}/example/xrlexample9.lua" > xrlexample9.sh
	@chmod +x xrlexample9.sh
	
#test the ruby bindings
xrlexample10.sh: ../ruby/xraylib.la xrlexample10.rb
	@echo "Testing ruby bindings"
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" RUBYLIB=\"${top_builddir}/ruby/.libs\" $(RUBY)  ${top_srcdir}/example/xrlexample10.rb" > xrlexample10.sh
	@chmod +x xrlexample10.sh

xrlexample12.sh: ../php/xraylib.la xrlexample12.php
	@echo "Testing PHP bindings"
	@echo "extension=\"${top_builddir}/php/.libs/xraylib.so\"" > php.ini
	@echo "include_path=\"${top_builddir}/php/\"" >> php.ini
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" $(PHP) -c ${builddir}  ${top_srcdir}/example/xrlexample12.php" > xrlexample12.sh
	@echo "rm -f php.ini" >> xrlexample12.sh
	@chmod +x xrlexample12.sh

#test the numpy-python bindings
xrlexample13.sh: ../python/xraylib_np.la xrlexample13.py
	@echo "Testing python-numpy bindings"
	@echo "LD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" DYLD_LIBRARY_PATH=\"${top_builddir}/src/.libs\" PYTHONPATH=\"${top_builddir}/python:${top_builddir}/python/.libs\" $(PYTHON) ${top_srcdir}/example/xrlexample13.py" > xrlexample13.sh
	@chmod +x xrlexample13.sh


../perl/xraylib.pm:
	$(MAKE) -C ../perl xraylib.pm

../idl/libxrlidl.la:
	$(MAKE) -C ../idl libxrlidl.la

../python/_xraylib.la:
	$(MAKE) -C ../python _xraylib.la

../java/xraylib.java:
	$(MAKE) -C ../java xraylib.java

../lua/xraylib.la:
	$(MAKE) -C ../lua xraylib.la

../ruby/xraylib.la:
	$(MAKE) -C ../ruby xraylib.la

../php/xraylib.la:
	$(MAKE) -C ../php xraylib.la

../python/xraylib_np.la:
	$(MAKE) -C ../python xraylib_np.la

clean-local:
	rm -rf xrlexample4.sh xrlexample2.sh xrlexample5.sh xrlexample7.sh xrlexample7.class xrlexample9.sh xrlexample10.sh xrlexample12.sh xrlexample13.sh
