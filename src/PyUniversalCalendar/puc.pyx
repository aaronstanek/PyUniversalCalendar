cdef class UniversalCalendarDate:
    def __init__(self):
        raise NotImplementedError("instantiation of UniversalCalendarDate base class is forbidden")

cdef class GregorianDate(UniversalCalendarDate):
    def __init__(self):
        print("hi")