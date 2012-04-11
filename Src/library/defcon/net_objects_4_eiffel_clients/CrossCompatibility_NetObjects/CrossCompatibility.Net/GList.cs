using System;
using System.Collections.Generic;
using System.Text;

namespace CrossCompatibility.Net
{
    public class GList<T>
    {
        public T item;
        public GList<T> next;

        public GList()
        {
            item = default(T);
            next = null;
        }

        public virtual void Put(T a_item)
        {
            if (item == null)
            {
                item = a_item;
            }
            else
            {
                if (next == null)
                {
                    next = new GList<T>();
                    next.item = a_item;
                }
                else
                {
                    next.Put(a_item);
                }
            }
        }

        public override string ToString()
        {
            if (item == null)
            {
                return "";
            }
            if (next == null)
            {
                return item.ToString();
            }
            return item.ToString() + ", " + next.ToString();
        }
    }
}
