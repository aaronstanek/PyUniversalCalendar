cdef extern from "CUniversalCalendar/common/CalendarCache.h":
    struct CalendarCache:
        pass
    void CalendarCache__constructor(CalendarCache*)

cdef extern from "CUniversalCalendar/dayOfWeek/DayOfWeek.h":
    const char* dayOfWeekString(CalendarCache*, long)
    int dayOfWeekISO(long)

cdef CalendarCache PUC_CACHE
CalendarCache__constructor(&PUC_CACHE)

class UniversalCalendarError(Exception):
    pass

class UniversalCalendarValidationError(UniversalCalendarError):
    pass

class UniversalCalendarBoundsError(UniversalCalendarError):
    pass

def check_error_code(int code):
    if code:
        if code == 1:
            raise UniversalCalendarValidationError()
        elif code == 2:
            raise UniversalCalendarBoundsError()
        else:
            raise UniversalCalendarError("Unknown Internal Error")

cdef class UniversalCalendarDate:
    def __init__(self):
        raise NotImplementedError("Instantiation of UniversalCalendarDate base class is forbidden")
    def day_of_week_string(self):
        cdef bytes output = dayOfWeekString(&PUC_CACHE,self.udn())
        return output.decode("UTF-8")
    def day_of_week_iso(self):
        return dayOfWeekISO(self.udn())
    def __eq__(self,other):
        if isinstance(other,UniversalCalendarDate):
            return self.udn() == other.udn()
        else:
            raise TypeError("Expected UniversalCalendarDate, not"+str(type(other)))
    def __ne__(self,other):
        if isinstance(other,UniversalCalendarDate):
            return self.udn() != other.udn()
        else:
            raise TypeError("Expected UniversalCalendarDate, not"+str(type(other)))
    def __lt__(self,other):
        if isinstance(other,UniversalCalendarDate):
            return self.udn() < other.udn()
        else:
            raise TypeError("Expected UniversalCalendarDate, not"+str(type(other)))
    def __gt__(self,other):
        if isinstance(other,UniversalCalendarDate):
            return self.udn() > other.udn()
        else:
            raise TypeError("Expected UniversalCalendarDate, not"+str(type(other)))
    def __le__(self,other):
        if isinstance(other,UniversalCalendarDate):
            return self.udn() <= other.udn()
        else:
            raise TypeError("Expected UniversalCalendarDate, not"+str(type(other)))
    def __ge__(self,other):
        if isinstance(other,UniversalCalendarDate):
            return self.udn() >= other.udn()
        else:
            raise TypeError("Expected UniversalCalendarDate, not"+str(type(other)))
    def __add__(a,b):
        # safe to assume that at least one of the arguments
        # is a UniversalCalendarDate
        if type(a) == int:
            # b must be UniversalCalendarDate
            return type(b)( b.udn() + a )
        elif type(b) == int:
            # a must be UniversalCalendarDate
            return type(a)( a.udn() + b )
        else:
            raise TypeError("Expected UniversalCalendarDate and int, not "+str(type(a))+" and "+str(type(b)))
    def __sub__(a,b):
        # a must be UniversalCalendarDate
        # b must be UniversalCalendarDate or int
        if isinstance(a,UniversalCalendarDate):
            if type(b) == int:
                return a.udn() - b
            elif isinstance(b,UniversalCalendarDate):
                return a.udn() - b.udn()
            else:
                raise TypeError("Expected int or UniversalCalendarDate, not "+str(type(b)))
        else:
            raise TypeError("Expected UniversalCalendarDate, not "+str(type(a)))

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