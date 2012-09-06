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

namespace Donor
{
    public partial class StationsSearch : PhoneApplicationPage
    {
        public StationsSearch()
        {
            InitializeComponent();

            this.StationsSearchText.ItemsSource = App.ViewModel.Stations.Items;
            this.StationsSearchText.FilterMode = AutoCompleteFilterMode.Contains;
            this.StationsSearchText.ItemFilter += SearchBank;
        }
        //custom filter
        bool CustomFilter(string search, string value)
        {
            return (value.Length > 2);
        }
        bool SearchBank(string search, object value)
        {
            if (value != null)
            {
                if ((value as StationViewModel).Title.ToString().ToLower().Contains(search))
                    return true;
            }
            // If no match, return false.
            return false;
        }

        private void StationsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as StationViewModel).objectId;
                NavigationService.Navigate(new Uri("/StationPage.xaml?id="+id, UriKind.Relative));
            }
            catch
            {
            }
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            this.StationsList.DataContext = App.ViewModel;
            if (App.ViewModel.Stations.IsFilter == false)
            {
                this.StationsList.ItemsSource = App.ViewModel.Stations.Items;
            }
            else
            {
                this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                where (stations.City == App.ViewModel.Stations.SelectedCity)
                                                &&
                                                ((stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor)
                                                ||
                                                (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional)
                                                ||
                                                (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork))
                                                select stations;
            };
        }

        private void StationsSearchText_Populating(object sender, PopulatingEventArgs e)
        {
            string searchtext = this.StationsSearchText.Text;
            if (searchtext != "")
            {
                this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                where (stations.Title.ToLower().Contains(searchtext.ToLower())) && ((stations.City == App.ViewModel.Stations.SelectedCity)
                                                    && (
                                                    (stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor)
                                                    ||
                                                    (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional)
                                                    ||
                                                    (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)))
                                                select stations;
            }
            else
            {
                this.StationsList.DataContext = App.ViewModel;
                if (App.ViewModel.Stations.IsFilter == false)
                {
                    this.StationsList.ItemsSource = App.ViewModel.Stations.Items;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                    where ((stations.City == App.ViewModel.Stations.SelectedCity)
                                                    &&
                                                    ((stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor)
                                                    ||
                                                    (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional)
                                                    ||
                                                    (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)))
                                                    select stations;
                };
            };
        }

        private void MapButton_Click(object sender, EventArgs e)
        {
            //show map code
        }

        private void ApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            //show filter page
            try
            {
                NavigationService.Navigate(new Uri("/StationsSearchFilter.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }

        private void StationsList_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as StationViewModel).objectId;
                NavigationService.Navigate(new Uri("/StationPage.xaml?id=" + id, UriKind.Relative));
            }
            catch
            {
            }
        }

    }
}