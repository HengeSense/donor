using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using Microsoft.Phone.Controls;
using Donor.ViewModels;
using Telerik.Windows.Data;

namespace Donor
{
    public partial class StationsSearchFilter : PhoneApplicationPage
    {
        public StationsSearchFilter()
        {
            InitializeComponent();

            this.DistrictsList.GroupDescriptors.Add(GroupedBadgesList);
            this.DistrictsList.SortDescriptors.Add(Sort);
            //this.DistrictsList.ItemsSource = ViewModelLocator.MainStatic.Stations.DistrictItems;
        }

        public GenericGroupDescriptor<TownItem, string> GroupedBadgesList = new GenericGroupDescriptor<TownItem, string>(item => item.RegionName);
        public GenericSortDescriptor<TownItem, string> Sort = new GenericSortDescriptor<TownItem, string>(item => item.TownName);

        private void StationsList_GroupPickerItemTap(object sender, Telerik.Windows.Controls.GroupPickerItemTapEventArgs e)
        {
            try
            {
                NavigationService.GoBack();
            }
            catch { };
        }

        private void StationsList_ItemTap(object sender, Telerik.Windows.Controls.ListBoxItemTapEventArgs e)
        {
            try
            {
                NavigationService.GoBack();
            }
            catch { };
        }


    }
}