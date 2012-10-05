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

            this.StationsSearchText.ItemsSource = App.ViewModel.Stations.DistanceItems;
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
                //if ((value as StationViewModel).Title.ToString().ToLower().Contains(search)) return true;
            }
            return false;
        }

        private void StationsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (task != "select")
                {
                    string id = ((sender as ListBox).SelectedItem as StationViewModel).Nid.ToString();
                    NavigationService.Navigate(new Uri("/StationPage.xaml?id=" + id, UriKind.Relative));
                }
                else
                {
                    App.ViewModel.Stations.SelectedStation = ((sender as ListBox).SelectedItem as StationViewModel).Nid.ToString();
                    NavigationService.GoBack();
                };
            }
            catch
            {
            }
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            //this.AppBar1.IsVisible = true;
            this.StationsSearchText.Text = App.ViewModel.Stations.FilteredText;

            if (App.ViewModel.Stations.IsFilter == true)
            {
                this.CityFilterText.Text = App.ViewModel.Stations.SelectedCity;
            }
            else
            {
                this.CityFilterText.Text = " ";
            };

            this.StationsList.DataContext = App.ViewModel;
            if (App.ViewModel.Stations.IsFilter == false)
            {
                if (App.ViewModel.Stations.FilteredText == "")
                {
                    this.StationsList.ItemsSource = App.ViewModel.Stations.DistanceItems;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                where (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower()))
                                                orderby stations.Distance ascending
                                                select stations;
                };
            }
            else
            {
                if (App.ViewModel.Stations.FilteredText == "")
                {
                    this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                    where (stations.City == App.ViewModel.Stations.SelectedCity)
                                                    && (((!App.ViewModel.Stations.IsChildrenDonor) || (stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor)) && ((!App.ViewModel.Stations.IsRegional) || (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional)) && ((!App.ViewModel.Stations.IsSaturdayWork) || (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)))
                                                    orderby stations.Distance ascending
                                                    select stations;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                    where (stations.City == App.ViewModel.Stations.SelectedCity)
                                                    && ((stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor) && (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional) && (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)) && (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower())) && (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower()))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            };
        }

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            string searchtext = this.StationsSearchText.Text;
            App.ViewModel.Stations.FilteredText = searchtext;
            base.OnNavigatedFrom(e);
        }

        private void StationsSearchText_Populating(object sender, PopulatingEventArgs e)
        {
            string searchtext = this.StationsSearchText.Text;
            App.ViewModel.Stations.FilteredText = searchtext;

            if (searchtext != "")
            {
                if (App.ViewModel.Stations.IsFilter == false)
                {
                    this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                    where (stations.Title.ToLower().Contains(searchtext.ToLower()))
                                                    orderby stations.Distance ascending
                                                    select stations;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                    where (stations.Title.ToLower().Contains(searchtext.ToLower())) && ((stations.City == App.ViewModel.Stations.SelectedCity)
                                                        && ((stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor) && (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional) && (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)) && (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower())))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            }
            else
            {
                this.StationsList.DataContext = App.ViewModel;
                if (App.ViewModel.Stations.IsFilter == false)
                {
                    this.StationsList.ItemsSource = App.ViewModel.Stations.DistanceItems;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in App.ViewModel.Stations.Items
                                                    where ((stations.City == App.ViewModel.Stations.SelectedCity)
                                                    && ((stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor) && (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional) && (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)) && (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower())))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            };
        }

        private void MapButton_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/MapPage.xaml", UriKind.Relative));
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

        private void StationsSearchText_Populated(object sender, PopulatedEventArgs e)
        {
            string searchtext = this.StationsSearchText.Text;
            if (searchtext != "")
            {
            }
            else
            {
                if (App.ViewModel.Stations.IsFilter == false)
                {
                }
                else
                {
                };
            };
        }

        private string task; 

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                this.task = this.NavigationContext.QueryString["task"];
            }
            catch { };
        }

    }
}