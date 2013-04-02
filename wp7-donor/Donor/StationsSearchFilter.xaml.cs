﻿using System;
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
using Telerik.Windows.Controls;

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
        }

        private void StationsList_ItemTap(object sender, Telerik.Windows.Controls.ListBoxItemTapEventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Stations.CurrentState = "";
                ViewModelLocator.MainStatic.Stations.CurrentDistrict = ((sender as RadJumpList).SelectedItem as TownItem).DistrictName;
                NavigationService.GoBack();
            }
            catch { };
        }

        private void DistrictsList_GroupHeaderItemTap(object sender, GroupHeaderItemTapEventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Stations.CurrentState = e.Item.Content.ToString();
                ViewModelLocator.MainStatic.Stations.CurrentDistrict = "";
                NavigationService.GoBack();
            }
            catch { };
        }


    }
}