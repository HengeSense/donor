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
//using GART;
//using GART.Controls;
//using GART.Data;
using System.Collections.ObjectModel;
using System.Device.Location;
using Microsoft.Phone.Controls.Maps;

namespace Donor
{
    public partial class MapPage : PhoneApplicationPage
    {
        public MapPage()
        {
            InitializeComponent();
        }

        private string _stationid_current;
        private StationViewModel _currentStation = null;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (App.ViewModel.Settings.Location == true)
            {
                
                //DisableLocation.IsEnabled = true;
                //EnableLocation.IsEnabled = false;
            }
            else
            {
                //DisableLocation.IsEnabled = false;
                //EnableLocation.IsEnabled = true;
            };

            if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _eventid = this.NavigationContext.QueryString["id"];
                    _stationid_current = _eventid;
                    _currentStation = App.ViewModel.Stations.Items.FirstOrDefault(c => c.Nid.ToString() == _stationid_current.ToString());
                    DataContext = _currentStation;
                }
                catch { };
            };
            //ObservableCollection<ARItem> items = new ObservableCollection<ARItem>();

            //ARStation mapitem = new ARStation();
            GeoCoordinate currentLocation = new GeoCoordinate(Convert.ToDouble(App.ViewModel.Stations.Latitued.ToString()), Convert.ToDouble(App.ViewModel.Stations.Longitude.ToString()));
            
            map1.Children.Add(new Pushpin() { Location = currentLocation, Content = "Я" });
            map1.ZoomLevel = 14;
            if (_currentStation == null)
            {
                map1.Center = currentLocation;
            }
            else
            {
                map1.Center = new GeoCoordinate(Convert.ToDouble(_currentStation.Lat.ToString()), Convert.ToDouble(_currentStation.Lon.ToString()));
            };

            //mapitem.GeoLocation = currentLocation;

            //mapitem.Title = "Я";
            //mapitem.Adress = "Текущее положение";
            //items.Add(mapitem);


            ///
            /// Set filtered collection
            ///
            List<StationViewModel> filteredItems = new List<StationViewModel>();
            if (App.ViewModel.Stations.IsFilter == false)
            {
                if (App.ViewModel.Stations.FilteredText == "")
                {
                    filteredItems = App.ViewModel.Stations.DistanceItems;
                }
                else
                {
                    filteredItems = (from stations in App.ViewModel.Stations.Items
                                                    where (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower()))
                                                    orderby stations.Distance ascending
                                     select stations).ToList();
                };
            }
            else
            {
                if (App.ViewModel.Stations.FilteredText == "")
                {
                    filteredItems = (from stations in App.ViewModel.Stations.Items
                                                    where (stations.City == App.ViewModel.Stations.SelectedCity)
                                                    && (((!App.ViewModel.Stations.IsChildrenDonor) || (stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor)) && ((!App.ViewModel.Stations.IsRegional) || (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional)) && ((!App.ViewModel.Stations.IsSaturdayWork) || (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)))
                                                    orderby stations.Distance ascending
                                                    select stations).ToList();
                }
                else
                {
                    filteredItems = (from stations in App.ViewModel.Stations.Items
                                                    where (stations.City == App.ViewModel.Stations.SelectedCity)
                                                    && ((stations.DonorsForChildrens == App.ViewModel.Stations.IsChildrenDonor) && (stations.RegionalRegistration == App.ViewModel.Stations.IsRegional) && (stations.SaturdayWork == App.ViewModel.Stations.IsSaturdayWork)) && (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower())) && (stations.Title.ToLower().Contains(App.ViewModel.Stations.FilteredText.ToLower()))
                                                    orderby stations.Distance ascending
                                                    select stations).ToList();
                };
            };

            if (_currentStation == null)
            {
                foreach (var item in filteredItems)
                {
                    /*mapitem = new ARStation();
                    mapitem.GeoLocation = new GeoCoordinate(Convert.ToDouble(item.Lat.ToString()), Convert.ToDouble(item.Lon.ToString()));
                    mapitem.Content = item.Title;*/

                    currentLocation = new GeoCoordinate(Convert.ToDouble(item.Lat.ToString()), Convert.ToDouble(item.Lon.ToString()));

                    Pushpin pushpinItem = new Pushpin()
                    {
                        Location = currentLocation, //mapitem.GeoLocation,
                        Content = item.Title
                    };
                    pushpinItem.Tag = item.Nid;
                    pushpinItem.Tap += this.Pushpin_Tap;
                    map1.Children.Add(pushpinItem);

                    /*mapitem.Title = item.Title;
                    mapitem.Adress = item.Adress;
                    items.Add(mapitem);*/
                };
            }
            else
            {
                /*mapitem = new ARStation();
                mapitem.GeoLocation = new GeoCoordinate(Convert.ToDouble(_currentStation.Lat.ToString()), Convert.ToDouble(_currentStation.Lon.ToString()));
                mapitem.Content = _currentStation.Title;*/

                currentLocation = new GeoCoordinate(Convert.ToDouble(_currentStation.Lat.ToString()), Convert.ToDouble(_currentStation.Lon.ToString()));

                Pushpin pushpinItem = new Pushpin()
                {
                    Location = currentLocation, //mapitem.GeoLocation,
                    Content = _currentStation.Title
                };
                //pushpinItem.Tag = _currentStation.Nid;
                //pushpinItem.Tap += this.Pushpin_Tap;

                map1.Children.Add(pushpinItem);

                /*mapitem.Title = _currentStation.Title;
                mapitem.Adress = _currentStation.Adress;
                items.Add(mapitem);*/
            };

            //ARDisplay.ARItems = items;
            
        }

        private void Pushpin_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                string id = (sender as Pushpin).Tag.ToString();
                NavigationService.Navigate(new Uri("/StationPage.xaml?id=" + id, UriKind.Relative));
            }
            catch
            {
            };
        }

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            // Stop AR services
            //ARDisplay.StopServices();
            
            base.OnNavigatedFrom(e);
        }

        protected override void OnNavigatedTo(System.Windows.Navigation.NavigationEventArgs e)
        {
            //ARDisplay.Visibility = Visibility.Collapsed;
            base.OnNavigatedTo(e);
        }

        private void ThreeDButton_Click(object sender, System.EventArgs e)
        {

           //ARDisplay.StartServices();
           //this.ARDisplay.Visibility = Visibility.Visible;
        }

        private void RemoveAR_Click(object sender, EventArgs e)
        {
            //this.ARDisplay.Visibility = Visibility.Collapsed;
            //ARDisplay.StopServices();
        }

        private void DisableLocation_Click(object sender, EventArgs e)
        {
            App.ViewModel.Settings.Location = false;
        }

        private void EnableLocation_Click(object sender, EventArgs e)
        {
            App.ViewModel.Settings.Location = true;
        }
    }
}