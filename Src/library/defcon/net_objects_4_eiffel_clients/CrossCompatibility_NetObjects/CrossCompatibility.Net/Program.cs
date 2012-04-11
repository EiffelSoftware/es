using System;
using System.Collections.Generic;
using System.Text;
using Db4objects.Db4o;

namespace CrossCompatibility.Net
{
    public class Program
    {
        static void Main(string[] args)
        {
            Program p = new Program();
            p.Store();
        }

        private void Store()
        {
            IObjectContainer db = Db4oFactory.OpenFile("NetObjects.db4o");
            try
            {
                GList<Point> gp = new GList<Point>();
                gp.Put(new Point(1, 2));
                gp.Put(new Point(3, 4));
                db.Store(gp);

                GList<Parallelogram> gpar = new GList<Parallelogram>();
                Point[] vertices = new Point[4];
                vertices[0] = new Point(0, 0);
                vertices[1] = new Point(5, 10);
                vertices[2] = new Point(25, 10);
                vertices[3] = new Point(20, 0);
                gpar.Put(new Parallelogram(vertices));
                vertices[0] = new Point(30, 30);
                vertices[1] = new Point(30, 50);
                vertices[2] = new Point(80, 50);
                vertices[3] = new Point(80, 30);
                gpar.Put(new Rectangle(vertices));
                db.Store(gpar);

                GSublist<Point> gsubp = new GSublist<Point>();
                gsubp.Put(new Point(11, 12));
                gsubp.Put(new Point(13, 14));
                db.Store(gsubp);

                GSublist<Parallelogram> gsubpar = new GSublist<Parallelogram>();
                vertices[0] = new Point(100, 100);
                vertices[1] = new Point(105, 110);
                vertices[2] = new Point(125, 110);
                vertices[3] = new Point(120, 100);
                gsubpar.Put(new Parallelogram(vertices));
                vertices[0] = new Point(130, 130);
                vertices[1] = new Point(130, 150);
                vertices[2] = new Point(180, 150);
                vertices[3] = new Point(180, 130);
                gsubpar.Put(new Rectangle(vertices));
                db.Store(gsubpar);
            }
            finally
            {
                db.Close();
            }
        }
    }
}
