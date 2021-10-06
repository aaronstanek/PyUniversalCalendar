# import setuptools
from distutils.core import Extension, setup
from Cython.Build import cythonize

ext = Extension(name="puc", sources=["src/PyUniversalCalendar/puc.pyx"])
setup(ext_modules=cythonize(ext,language_level=3))