#
# Copyright (c) 2005       Ero Carrera Ventura <ero / dkbza.org> (Python adaptation)
# Copyright (c) 2004-2007  Jarkko Turkulainen <jt / nologin.org> <turkja / github.com>
# Copyright (c) 2009-2010  Ange Albertini <angea / github.com>
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1) Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# 2) Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

import os
from setuptools import setup, Extension
from distutils.sysconfig import get_python_inc

incdir = os.path.join(get_python_inc(plat_specific=1))

module = Extension('pydasm',
	include_dirs = [incdir],
	libraries = [],
	library_dirs = [],
	sources = ['../libdasm.c', 'pydasm.c'])

setup(name = 'pydasm',
    version = '1.5',
    description = 'Python module wrapping libdasm',
    author = 'Ero Carrera',
    author_email = 'ero@dkbza.org',
    ext_modules = [module])
