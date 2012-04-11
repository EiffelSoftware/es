using System;
using System.Collections.Generic;
using System.Text;

namespace CrossCompatibility.Net
{
    public struct Point
    {
        private int _x, _y;

        public Point(int x, int y)
        {
            _x = x;
            _y = y;
        }

        public int X
        {
            get
            {
                return _x;
            }
            set
            {
                _x = value;
            }
        }

        public int Y
        {
            get
            {
                return _y;
            }
            set
            {
                _y = value;
            }
        }

        public double DistanceTo(Point p)
        {
            return Math.Sqrt((p.X - _x) ^ 2 + (p.Y - _y) ^ 2);
        }
    }
}
