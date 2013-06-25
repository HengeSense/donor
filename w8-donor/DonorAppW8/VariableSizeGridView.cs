using DonorAppW8.DataModel;
//using DonorAppW8.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml;
using Windows.UI.Xaml.Controls;

namespace DonorAppW8
{
    class VariableSizeGridView : GridView
    {
        private int rowVal;
        private int colVal;

        protected override void PrepareContainerForItemOverride(Windows.UI.Xaml.DependencyObject element, object item)
        {
            try
            {
                Object dataItem = item as Object;
                int index = -1;

                int group = -1;



                /*if (dataItem.Group.UniqueId.Contains("stas"))
                {
                    group = 1;
                }

                if (dataItem != null)
                {
                    index = dataItem.Group.Items.IndexOf(dataItem);
                };

                colVal = 2;
                rowVal = 2;

                if (index == 2)
                {
                    colVal = 2;
                    rowVal = 4;
                }

                if (index == 5)
                {
                    colVal = 4;
                    rowVal = 4;
                }

                if (group > 0)
                {
                    if (index == 2)
                    {
                        colVal = 2;
                        rowVal = 4;
                    }

                    if (index == 5)
                    {
                        colVal = 4;
                        rowVal = 4;
                    }
                }*/

                colVal = 1;
                rowVal = 1;
                if (dataItem.GetType() == typeof(HelpItem))
                {
                    colVal = 2;
                    rowVal = 1;
                };

                VariableSizedWrapGrid.SetRowSpan(element as UIElement, rowVal);
                VariableSizedWrapGrid.SetColumnSpan(element as UIElement, colVal);
            }
            catch { };           

            base.PrepareContainerForItemOverride(element, item);
        }
    }
}
