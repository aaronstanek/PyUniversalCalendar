cdef extern from "CUniversalCalendar/common/CalendarCache.h":
    struct CalendarCache:
        pass
    void CalendarCache__constructor(CalendarCache*)

cdef extern from "CUniversalCalendar/dayOfWeek/DayOfWeek.h":
    const char* dayOfWeekString(CalendarCache*, long)
    int dayOfWeekISO(long)

cdef CalendarCache PUC_CACHE
CalendarCache__constructor(&PUC_CACHE)

def check_error_code(int code):
    if code:
        raise Exception("A bad thing happened.")

cdef class UniversalCalendarDate:
    def __init__(self):
        raise NotImplementedError("instantiation of UniversalCalendarDate base class is forbidden")

cdef extern from "CUniversalCalendar/common/YMD.h":
    struct YMD:
        long year
        unsigned char month
        unsigned char day

cdef class SpecialDate_YMD(UniversalCalendarDate):
    cdef long _udn
    cdef YMD _ymd
    def __init__(self,*args):
        if len(args) == 1:
            if type(args[0]) == int:
                self._udn = args[0]
            elif isinstance(args[0],UniversalCalendarDate):
                self._udn = args[0].udn()
            else:
                raise TypeError("Expected int or UniversalCalendarDate, not "+str(type(args[0])))
            self._encode()
        elif len(args) == 3:
            # all three must be int
            for i in range(3):
                if type(args[i]) != int:
                    raise TypeError("Expected int, not "+str(type(args[i])))
            self._ymd.year = args[0]
            self._ymd.month = args[1]
            self._ymd.day = args[2]
            self._decode()
        else:
            raise ValueError("Expected either 1 or 3 parameters, not "+str(len(args)))
    def udn(self):
        return self._udn
    def year(self):
        return self._ymd.year
    def month(self):
        return self._ymd.month
    def day(self):
        return self._ymd.day
    def day_of_week_string(self):
        cdef bytes output = dayOfWeekString(&PUC_CACHE,self._udn)
        return output.decode("UTF-8")
    def day_of_week_iso(self):
        return dayOfWeekISO(self._udn)

cdef extern from "CUniversalCalendar/Gregorian/Gregorian.h":
    int GregorianEncode(CalendarCache*, YMD*, long)
    int GregorianDecode(CalendarCache*, long*, YMD*)
    int GregorianShift(CalendarCache*, YMD*, YMD*, long)

cdef class GregorianDate(SpecialDate_YMD):
    def __init__(self,*args):
        super().__init__(*args)
    def _encode(self):
        check_error_code( GregorianEncode(&PUC_CACHE,&(self._ymd),self._udn) )
    def _decode(self):
        check_error_code( GregorianDecode(&PUC_CACHE,&(self._udn),&(self._ymd)) )