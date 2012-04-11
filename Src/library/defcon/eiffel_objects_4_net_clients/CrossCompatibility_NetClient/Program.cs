using System;
using System.Collections.Generic;
using System.Text;
using Db4objects.Db4o;
using RootCluster;
using RootCluster.Db4oForEiffel;
using EiffelSoftware.Library.Base.Structures.List;

namespace CrossCompatibility_NetClient
{
    class Program
    {
        static void Main(string[] args)
        {
            Program p = new Program();
            p.Test();
        }

        private void Test()
        {
            Init();
            Retrieve_SODA();
            Retrieve_NQ();
            Console.ReadLine();
        }

        private void Init()
        {
            Configuration eiffelConfig = RootCluster.Db4oForEiffel.Create.Configuration.DefaultCreate();
            eiffelConfig.InstallHandlers();
        }

        private string databaseFile = "..\\..\\eiffel.db4o";

        private void Retrieve_SODA()
        {
            Console.WriteLine("***** SODA Query API *****");
            RetrieveEiffelStrings_SODA();
            RetrievePoints_SODA();
            RetrieveParallelograms_SODA();
            RetrieveGlists_SODA();
            RetrieveTuples_SODA();
        }

        // TODO
        private void RetrieveEiffelStrings_SODA()
        {

        }

        private void RetrievePoints_SODA()
        {
            IObjectContainer db = Db4oFactory.OpenFile(databaseFile);
            try
            {
                Console.WriteLine("----- Point.x >= 3 -----");
                Query eiffelQuery = RootCluster.Db4oForEiffel.Create.Query.MakeFromQuery(db.Query());
                Constraint eiffelConstraint = eiffelQuery.Constrain(typeof(Point));
                Query eiffelSubquery = eiffelQuery.Descend("x", typeof(Point));
                Constraint eiffelSubconstraint = eiffelSubquery.Constrain(3).Greater().Equal_();
                IObjectSet resultos = eiffelQuery.Execute();
                Console.WriteLine(resultos.Count + " instances retrieved.");
                Point pnt;
                while (resultos.HasNext())
                {
                    pnt = (Point)resultos.Next();
                    Console.WriteLine("Point (" + pnt.X() + ", " + pnt.Y() + ")");
                }
            }
            finally
            {
                db.Close();
            }
        }

        private void RetrieveParallelograms_SODA()
        {
            IObjectContainer db = Db4oFactory.OpenFile(databaseFile);
            try
            {
                Console.WriteLine("----- Parallelogram.height1 >= 20 -----");
                Query eiffelQuery = RootCluster.Db4oForEiffel.Create.Query.MakeFromQuery(db.Query());
                Constraint eiffelConstraint = eiffelQuery.Constrain(typeof(Parallelogram));
                Query eiffelSubquery = eiffelQuery.Descend("height1", typeof(Parallelogram));
                Constraint eiffelSubconstraint = eiffelSubquery.Constrain(20).Greater().Equal_();
                IObjectSet resultos = eiffelQuery.Execute();
                Console.WriteLine(resultos.Count + " instances retrieved.");
                Parallelogram par;
                while (resultos.HasNext())
                {
                    par = (Parallelogram)resultos.Next();
                    Console.WriteLine(par.ToEiffelString().ToCil());
                }
            }
            finally
            {
                db.Close();
            }
        }

        private void RetrieveGlists_SODA()
        {
            IObjectContainer db = Db4oFactory.OpenFile(databaseFile);
            try
            {
                Console.WriteLine("----- GlistReference.next.item.height1 >= 20 -----");
                Query eiffelQuery = RootCluster.Db4oForEiffel.Create.Query.MakeFromQuery(db.Query());
                Constraint eiffelConstraint = eiffelQuery.Constrain(typeof(GlistReference));
                Query eiffelSubquery = eiffelQuery.Descend("next", typeof(GlistReference));
                eiffelSubquery = eiffelSubquery.Descend("item", typeof(GlistReference));
                eiffelSubquery = eiffelSubquery.Descend("height1", typeof(Parallelogram));
                Constraint eiffelSubconstraint = eiffelSubquery.Constrain(20).Greater().Equal_();
                IObjectSet resultos = eiffelQuery.Execute();
                Console.WriteLine(resultos.Count + " instances retrieved.");
                //GenericityHelper ghelper = RootCluster.Db4oForEiffel.Create.GenericityHelper.DefaultCreate();
                //ListReference lr = ghelper.GetConformingObjects(resultos, );
                //Console.WriteLine(lr.Count() + " conforming instances.");
                GlistReference glr;
                while (resultos.HasNext())
                {
                    glr = (GlistReference)resultos.Next();
                }
            }
            finally
            {
                db.Close();
            }
        }

        private void RetrieveTuples_SODA()
        {

        }

        private void Retrieve_NQ()
        {
            Console.WriteLine("***** Native Queries *****");
            RetrieveEiffelStrings_NQ();
            RetrievePoints_NQ();
            RetrieveParallelograms_NQ();
            RetrieveGlists_NQ();
            RetrieveTuples_NQ();
        }

        private void RetrieveEiffelStrings_NQ()
        {

        }

        private void RetrievePoints_NQ()
        {
            IObjectContainer db = Db4oFactory.OpenFile(databaseFile);
            try
            {
                Console.WriteLine("----- Point.x >= 3 -----");
                IList<Point> points = db.Query<Point>(delegate(Point p)
                {
                    return p.X() >= 3;
                });
                Console.WriteLine(points.Count + " instances retrieved.");
                foreach (Point pnt in points) 
                {
                    Console.WriteLine("Point (" + pnt.X() + ", " + pnt.Y() + ")");
                }
            }
            finally
            {
                db.Close();
            }
        }

        private void RetrieveParallelograms_NQ()
        {
            IObjectContainer db = Db4oFactory.OpenFile(databaseFile);
            try
            {
                Console.WriteLine("----- Parallelogram.height1 >= 20 -----");
                IList<Parallelogram> pars = db.Query<Parallelogram>(delegate(Parallelogram p)
                {
                    return p.Height1() >= 20;
                });
                Console.WriteLine(pars.Count + " instances retrieved.");
                foreach (Parallelogram p in pars)
                {
                    Console.WriteLine(p.ToEiffelString().ToCil());
                }
            }
            finally
            {
                db.Close();
            }
        }

        private void RetrieveGlists_NQ()
        {

        }

        private void RetrieveTuples_NQ()
        {

        }
    }
}
