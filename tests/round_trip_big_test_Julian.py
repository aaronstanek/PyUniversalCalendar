import sys
sys.path.append("src")

import PyUniversalCalendar as puc

lengths = {
    1: 31,
    3: 31,
    4: 30,
    5: 31,
    6: 30,
    7: 31,
    8: 31,
    9: 30,
    10: 31,
    11: 30
}

def check_date_ordering(past,now):
    global lengths
    # make sure that now is a sensible date
    # make sure that now comes after past
    if now[0] == 0:
        raise Exception("Year zero encountered!")
    if now[1] < 1 or now[1] > 12:
        raise Exception("Invalid Month")
    if now[2] < 1 or now[2] > 31:
        raise Exception("Invalid Day")
    if now[0] != past[0]:
        # different years
        if past[1] != 12 or past[2] != 31:
            raise Exception("Invalid end of year")
        if now[1] != 1 or now[2] != 1:
            raise Exception("Invalid start of year")
        if past[0] == -1:
            if now[0] != 1:
                raise Exception("Years jump")
        else:
            if now[0] != past[0] + 1:
                raise Exception("Years jump")
    else:
        # same year
        if now[1] != past[1]:
            # different months
            if now[2] != 1:
                raise Exception("Invalid start of month")
            if now[1] != past[1] + 1:
                raise Exception("Months jump")
            if past[1] != 2:
                if past[2] != lengths[past[1]]:
                    raise Exception("Invalid end of month")
            else:
                # feb to march
                days_in_feb = 28
                year = past[0]
                if year < 0:
                    year += 1
                if year % 4 == 0:
                    # leap year
                    days_in_feb = 29
                if past[2] != days_in_feb:
                    raise Exception("Invalid end of Month")
        else:
            # same month
            if now[2] != past[2] + 1:
                raise Exception("Days jump")

def main():
    past = None
    for udn in range(-10**6,10**6+1,1):
        a = puc.JulianDate(udn)
        b = [a.year(),a.month(),a.day()]
        c = puc.JulianDate(*b)
        if c.udn() != udn:
            raise Exception("Round trip failed: "+str(udn))
        if past is not None:
            try:
                check_date_ordering(past,b)
            except:
                raise Exception("Ordering failed: "+str(udn))
        past = b
    print("All Good!")

if __name__ == '__main__':
    main()