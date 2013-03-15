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

            this.StationsSearchText.ItemsSource = ViewModelLocator.MainStatic.Stations.DistanceItems;
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
                    ViewModelLocator.MainStatic.Stations.SelectedStation = ((sender as ListBox).SelectedItem as StationViewModel).Nid.ToString();
                    NavigationService.GoBack();
                };
            }
            catch
            {
            }
        }

        private void ShowNoResults()
        {
            if (this.StationsList.Items.Count() > 0)
            {
                this.Noresults.Visibility = Visibility.Collapsed;
            }
            else
            {
                this.Noresults.Visibility = Visibility.Visible;
            };
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                if (task == "select")
                {
                    AppBar.IsVisible = false;
                }
                else
                {
                    AppBar.IsVisible = true;
                };
            }
            catch { };
            //this.AppBar1.IsVisible = true;
            this.StationsSearchText.Text = ViewModelLocator.MainStatic.Stations.FilteredText;

            if (ViewModelLocator.MainStatic.Stations.IsFilter == true)
            {
                this.CityFilterText.Text = ViewModelLocator.MainStatic.Stations.SelectedCity;
            }
            else
            {
                this.CityFilterText.Text = " ";
            };

            this.StationsList.DataContext = ViewModelLocator.MainStatic;
            if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
            {
                if (ViewModelLocator.MainStatic.Stations.FilteredText == "")
                {
                    this.StationsList.ItemsSource = ViewModelLocator.MainStatic.Stations.DistanceItems;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.Items
                                                    where (stations.Title.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()) || stations.Adress.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            }
            else
            {
                if (ViewModelLocator.MainStatic.Stations.FilteredText == "")
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.Items
                                                    where (stations.City == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                    && (((!ViewModelLocator.MainStatic.Stations.IsChildrenDonor) || (stations.DonorsForChildrens == ViewModelLocator.MainStatic.Stations.IsChildrenDonor)) && ((!ViewModelLocator.MainStatic.Stations.IsRegional) || (stations.RegionalRegistration == ViewModelLocator.MainStatic.Stations.IsRegional)) && ((!ViewModelLocator.MainStatic.Stations.IsSaturdayWork) || (stations.SaturdayWork == ViewModelLocator.MainStatic.Stations.IsSaturdayWork)))
                                                    orderby stations.Distance ascending
                                                    select stations;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.Items
                                                    where (stations.City == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                    && ((stations.DonorsForChildrens == ViewModelLocator.MainStatic.Stations.IsChildrenDonor) && (stations.RegionalRegistration == ViewModelLocator.MainStatic.Stations.IsRegional) && (stations.SaturdayWork == ViewModelLocator.MainStatic.Stations.IsSaturdayWork)) && (stations.Title.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())) && ((stations.Adress.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()) || stations.Adress.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            };
            ShowNoResults();
        }

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            string searchtext = this.StationsSearchText.Text;
            ViewModelLocator.MainStatic.Stations.FilteredText = searchtext;
            base.OnNavigatedFrom(e);
        }

        private void FilterStationsList()
        {
            string searchtext = this.StationsSearchText.Text;
            ViewModelLocator.MainStatic.Stations.FilteredText = searchtext;

            if (searchtext != "")
            {
                if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.Items
                                                    where (stations.Title.ToLower().Contains(searchtext.ToLower()) || stations.Adress.ToLower().Contains(searchtext.ToLower()))
                                                    orderby stations.Distance ascending
                                                    select stations;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.Items
                                                    where (stations.Title.ToLower().Contains(searchtext.ToLower())) && ((stations.City == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                        && ((stations.DonorsForChildrens == ViewModelLocator.MainStatic.Stations.IsChildrenDonor) && (stations.RegionalRegistration == ViewModelLocator.MainStatic.Stations.IsRegional) && (stations.SaturdayWork == ViewModelLocator.MainStatic.Stations.IsSaturdayWork)) && ((stations.Title.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())) || stations.Adress.ToLower().Contains(searchtext.ToLower())))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            }
            else
            {
                this.StationsList.DataContext = ViewModelLocator.MainStatic;
                if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
                {
                    this.StationsList.ItemsSource = ViewModelLocator.MainStatic.Stations.DistanceItems;
                }
                else
                {
                    this.StationsList.ItemsSource = from stations in ViewModelLocator.MainStatic.Stations.Items
                                                    where ((stations.City == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                    && ((stations.DonorsForChildrens == ViewModelLocator.MainStatic.Stations.IsChildrenDonor) && (stations.RegionalRegistration == ViewModelLocator.MainStatic.Stations.IsRegional) && (stations.SaturdayWork == ViewModelLocator.MainStatic.Stations.IsSaturdayWork)) && ((stations.Title.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())) || (stations.Adress.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()))))
                                                    orderby stations.Distance ascending
                                                    select stations;
                };
            };
            ShowNoResults();
        }

        private void StationsSearchText_Populating(object sender, PopulatingEventArgs e)
        {
            FilterStationsList();
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
                if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
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

        private void StationsSearchText_LostFocus(object sender, RoutedEventArgs e)
        {
            FilterStationsList();
        }

        private void StationsSearchText_TextChanged(object sender, RoutedEventArgs e)
        {
            FilterStationsList();
        }

    }
}