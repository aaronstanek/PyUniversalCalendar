# import setuptools
from distutils.core import Extension, setup
from Cython.Build import cythonize

ext = Extension(name="puc", sources=[
        "src/PyUniversalCalendar/puc.pyx",
        "src/PyUniversalCalendar/CUniversalCalendar/common/CalendarCache.c",
        "src/PyUniversalCalendar/CUniversalCalendar/dayOfWeek/DOWcache.c",
        "src/PyUniversalCalendar/CUniversalCalendar/JulianGregorianMonthCache/JulianGregorianMonthCache.c"
    ])
setup(ext_modules=cythonize(ext,language_level=3))