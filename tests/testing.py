import unittest
import sys
sys.path.append("src")

import PyUniversalCalendar as puc

class TestErrorClasses(unittest.TestCase):

    def test_a(self):
        self.assertTrue(isinstance(
            puc.UniversalCalendarError(),
            Exception
            ))
        self.assertTrue(isinstance(
            puc.UniversalCalendarValidationError(),
            puc.UniversalCalendarError
            ))
        self.assertTrue(isinstance(
            puc.UniversalCalendarBoundsError(),
            puc.UniversalCalendarError
            ))

class TestBaseClass(unittest.TestCase):

    def test_a(self):
        with self.assertRaises(NotImplementedError):
            puc.UniversalCalendarDate()

class TestGregorianDate(unittest.TestCase):

    def test_creation(self):
        a = puc.GregorianDate(0)
        self.assertTrue(isinstance(
            a,puc.GregorianDate
        ))
        self.assertTrue(isinstance(
            a,puc.UniversalCalendarDate
        ))
        a = puc.GregorianDate(1969,7,20)
        a = puc.GregorianDate(a)

    def test_round_trip(self):
        # 100 days chosen at random in
        # the range -10**6 to 10**6
        # this will check that the encode and decode
        # compute inverse functions
        # this does not check correctness
        days = [
            505640, -284950, -957491, 511337, 9292,
            937095, -712186, 105569, 945351, 432216,
            808172, -403333, 275858, -45877, 8418,
            834874, 378793, -281789, -992075, 939476,
            347094, 545952, 484987, -976119, -926830,
            29294, -321755, 646073, -963366, -983258,
            -271166, -36851, 349321, -871837, -976181,
            -622155, 267101, 732884, -574437, 530273,
            226794, 553580, 845049, 372711, -722875,
            -134473, 468609, -187522, -599280, -680742,
            -911736, -946472, 925130, -129286, -481519,
            292744, 867276, -669699, 974218, -319450,
            625164, -787194, 473379, -527613, -622499,
            -801573, 613765, -309319, 790527, -491352,
            791746, 509733, 208883, 300094, -128231,
            674579, 977146, -716611, 667254, 321738,
            -245972, 410193, 722171, 411250, 426289,
            -77522, 938699, -786547, 244399, 991777,
            353638, -278089, -160870, 175495, -86483,
            892091, -73570, 24204, 672977, -609832
            ]
        for udn in days:
            a = puc.GregorianDate(udn)
            b = [a.year(),a.month(),a.day()]
            c = puc.GregorianDate(*b)
            self.assertEqual(udn,c.udn())
        
    def test_day_of_week(self):
        a = puc.GregorianDate(2000,1,1)
        self.assertEqual(a.day_of_week_string(),"Saturday")
        self.assertEqual(a.day_of_week_iso(),6)
        a = puc.GregorianDate(2000,1,2)
        self.assertEqual(a.day_of_week_string(),"Sunday")
        self.assertEqual(a.day_of_week_iso(),7)
        a = puc.GregorianDate(2000,1,3)
        self.assertEqual(a.day_of_week_string(),"Monday")
        self.assertEqual(a.day_of_week_iso(),1)
        a = puc.GregorianDate(2000,1,4)
        self.assertEqual(a.day_of_week_string(),"Tuesday")
        self.assertEqual(a.day_of_week_iso(),2)
        a = puc.GregorianDate(2000,1,5)
        self.assertEqual(a.day_of_week_string(),"Wednesday")
        self.assertEqual(a.day_of_week_iso(),3)
        a = puc.GregorianDate(2000,1,6)
        self.assertEqual(a.day_of_week_string(),"Thursday")
        self.assertEqual(a.day_of_week_iso(),4)
        a = puc.GregorianDate(2000,1,7)
        self.assertEqual(a.day_of_week_string(),"Friday")
        self.assertEqual(a.day_of_week_iso(),5)
        a = puc.GregorianDate(1969,7,20)
        self.assertEqual(a.day_of_week_string(),"Sunday")
        self.assertEqual(a.day_of_week_iso(),7)
        a = puc.GregorianDate(1945,4,25)
        self.assertEqual(a.day_of_week_string(),"Wednesday")
        self.assertEqual(a.day_of_week_iso(),3)
        a = puc.GregorianDate(-1,1,1)
        self.assertEqual(a.day_of_week_string(),"Saturday")
        self.assertEqual(a.day_of_week_iso(),6)
        a = puc.GregorianDate(-2,12,31)
        self.assertEqual(a.day_of_week_string(),"Friday")
        self.assertEqual(a.day_of_week_iso(),5)

    def test_comparison_methods(self):
        a = puc.GregorianDate(2000,1,1)
        b = puc.GregorianDate(2000,1,1)
        c = puc.GregorianDate(2000,1,2)
        self.assertTrue(a == b)
        self.assertFalse(a == c)
        self.assertFalse(a != b)
        self.assertTrue(a != c)
        self.assertFalse(a < b)
        self.assertTrue(a < c)
        self.assertFalse(c < a)
        self.assertFalse(a > b)
        self.assertFalse(a > c)
        self.assertTrue(c > a)
        self.assertTrue(a <= b)
        self.assertTrue(a <= c)
        self.assertFalse(c <= a)
        self.assertTrue(a >= b)
        self.assertFalse(a >= c)
        self.assertTrue(c >= a)

if __name__ == '__main__':
    unittest.main()