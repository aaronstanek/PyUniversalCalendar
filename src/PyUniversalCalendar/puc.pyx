cdef extern from "CUniversalCalendar/common/CalendarCache.h":
    struct CalendarCache:
        pass
    void CalendarCache__constructor(CalendarCache*)

cdef CalendarCache PUC_CACHE
CalendarCache__constructor(&PUC_CACHE)

cdef extern from "CUniversalCalendar/common/YMD.h":
    struct YMD:
        long year
        unsigned char month
        unsigned char day

cdef class UniversalCalendarDate:
    def __init__(self):
        raise NotImplementedError("instantiation of UniversalCalendarDate base class is forbidden")

cdef class SpecialDate_YMD(UniversalCalendarDate):
    cdef long _udn
    cdef YMD _ymd
    def udn(self):
        return self._udn
    def year(self):
        return self._ymd.year
    def month(self):
        return self._ymd.month
    def day(self):
        return self._ymd.day

cdef class GregorianDate(SpecialDate_YMD):
    def __init__(self):
        print("hi")