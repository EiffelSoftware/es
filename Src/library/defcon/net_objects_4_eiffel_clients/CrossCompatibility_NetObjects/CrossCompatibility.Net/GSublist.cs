using System;
using System.Collections.Generic;
using System.Text;

namespace CrossCompatibility.Net
{
    public class GSublist<T> : GList<T>
    {
        public int Count;
        public GSublist<T> nextSublist;

        public GSublist()
            : base()
        {
            nextSublist = null;
            Count = 0;
        }

        public override void Put(T a_item)
        {
            if (item == null)
            {
                item = a_item;
            }
            else
            {
                if (nextSublist == null)
                {
                    nextSublist = new GSublist<T>();
                    nextSublist.item = a_item;
                }
                else
                {
                    nextSublist.Put(a_item);
                }
            }
            Count++;
        }

        public override string ToString()
        {
            if (item == null)
            {
                return "";
            }
            if (nextSublist == null)
            {
                return item.ToString();
            }
            return item.ToString() + ", " + nextSublist.ToString();

        }
    }
}
