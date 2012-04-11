using System;
using System.Collections.Generic;
using System.Text;

namespace CrossCompatibility.Net
{
    public interface IFigure
    {
        Point[] Vertices { get; set; }
        double StrokeLength { get; }
        void Draw();
    }
}
