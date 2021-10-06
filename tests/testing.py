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

if __name__ == '__main__':
    unittest.main()