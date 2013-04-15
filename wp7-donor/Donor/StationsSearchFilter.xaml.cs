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
using Telerik.Windows.Controls;

namespace Donor
{
    public partial class StationsSearchFilter : PhoneApplicationPage
    {
        public StationsSearchFilter()
        {
            InitializeComponent();

            this.DistrictsList.ItemsSource = ViewModelLocator.MainStatic.Stations.DistrictItems;
            //this.StationsSearchText.FilterMode = AutoCompleteFilterMode.Contains;
            this.DistrictsList.GroupDescriptors.Add(GroupedBadgesList);           
            this.DistrictsList.SortDescriptors.Add(Sort);

            InteractionEffectManager.AllowedTypes.Add(typeof(Grid));
            InteractionEffectManager.AllowedTypes.Add(typeof(StackPanel));
            InteractionEffectManager.AllowedTypes.Add(typeof(Border));
            InteractionEffectManager.AllowedTypes.Add(typeof(RadJumpList));
            InteractionEffectManager.AllowedTypes.Add(typeof(RadDataBoundListBoxItem));
        }

        public GenericGroupDescriptor<TownItem, string> GroupedBadgesList = new GenericGroupDescriptor<TownItem, string>(item => item.RegionName);
        //public GenericGroupDescriptor<TownItem, string> GroupedDistrictBadgesList = new GenericGroupDescriptor<TownItem, string>(item => item.DistrictName);
        public GenericSortDescriptor<TownItem, string> Sort = new GenericSortDescriptor<TownItem, string>(item => item.TownName);

        private void StationsList_GroupPickerItemTap(object sender, Telerik.Windows.Controls.GroupPickerItemTapEventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Stations.CurrentState = e.Item.Content.ToString();
                ViewModelLocator.MainStatic.Stations.CurrentDistrict = "";
                NavigationService.GoBack();
            }
            catch { };
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

        private void PhoneApplicationPage_Loaded_1(object sender, RoutedEventArgs e)
        {
        }


    }
}