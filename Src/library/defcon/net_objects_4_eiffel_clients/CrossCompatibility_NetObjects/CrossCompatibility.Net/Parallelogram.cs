using System;
using System.Collections.Generic;
using System.Text;

namespace CrossCompatibility.Net
{
    public class Parallelogram : IFigure
    {
        private Point[] _vertices;
        private double _sideLength1, _sideLength2;
        

        public Parallelogram(Point[] v)
        {
            _vertices = v;
            _sideLength1 = v[0].DistanceTo(v[1]);
            _sideLength2 = v[1].DistanceTo(v[2]);
        }

        public Point[] Vertices
        {
            get
            {
                return _vertices;
            }
            set
            {
                _vertices = value;
                _sideLength1 = value[0].DistanceTo(value[1]);
                _sideLength2 = value[1].DistanceTo(value[2]);

            }
        }

        public double SideLength1
        {
            get
            {
                return _sideLength1;
            }
        }

        public double SideLength2
        {
            get
            {
                return _sideLength2;
            }
        }

        public double StrokeLength
        {
            get
            {
                return (_sideLength1 + _sideLength2) * 2;
            }
        }

        public void Draw()
        {
            Console.WriteLine(this.GetType().Name + " (" + _sideLength1 + ", " + _sideLength2);
        }
    }
}
