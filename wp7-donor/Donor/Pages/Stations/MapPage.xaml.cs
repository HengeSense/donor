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
        private YAStationItem _currentStation = null;

        private void ChangeGeolocation() {
            if (ViewModelLocator.MainStatic.Settings.Location == true)
            {                
                DisableLocation.Visibility = Visibility.Visible;
                EnableLocation.Visibility = Visibility.Collapsed;
            }
            else
            {
                DisableLocation.Visibility = Visibility.Collapsed;
                EnableLocation.Visibility = Visibility.Visible;
            };
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            ChangeGeolocation();

            if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _eventid = this.NavigationContext.QueryString["id"];
                    _stationid_current = _eventid;
                    _currentStation = ViewModelLocator.MainStatic.Stations.Items.FirstOrDefault(c => c.ObjectId.ToString() == _stationid_current.ToString());
                    DataContext = _currentStation;
                }
                catch { };
            };
            //ObservableCollection<ARItem> items = new ObservableCollection<ARItem>();

            //ARStation mapitem = new ARStation();
            GeoCoordinate currentLocation = new GeoCoordinate(Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Latitued.ToString()), Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Longitude.ToString()));
            
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
            List<YAStationItem> filteredItems = new List<YAStationItem>();
            if (ViewModelLocator.MainStatic.Stations.IsFilter == false)
            {
                if (ViewModelLocator.MainStatic.Stations.FilteredText == "")
                {
                    filteredItems = ViewModelLocator.MainStatic.Stations.DistanceItems;
                }
                else
                {
                    filteredItems = (from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                    where (stations.Name.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()))
                                                    orderby stations.Distance ascending
                                     select stations).ToList();
                };
            }
            else
            {
                if (ViewModelLocator.MainStatic.Stations.FilteredText == "")
                {
                    filteredItems = (from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                    where (stations.Town == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                    && (((!ViewModelLocator.MainStatic.Stations.IsChildrenDonor)) && ((!ViewModelLocator.MainStatic.Stations.IsRegional)) && ((!ViewModelLocator.MainStatic.Stations.IsSaturdayWork)))
                                                    orderby stations.Distance ascending
                                                    select stations).ToList();
                }
                else
                {
                    filteredItems = (from stations in ViewModelLocator.MainStatic.Stations.DistanceItems
                                                    where (stations.Name == ViewModelLocator.MainStatic.Stations.SelectedCity)
                                                    && (stations.Name.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower())) && (stations.Name.ToLower().Contains(ViewModelLocator.MainStatic.Stations.FilteredText.ToLower()))
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
                        Content = item.Name
                    };
                    pushpinItem.Tag = item.ObjectId;
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
                    Content = _currentStation.Name
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
                NavigationService.Navigate(new Uri("/Pages/Stations/StationPage.xaml?id=" + id, UriKind.Relative));
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
            ViewModelLocator.MainStatic.Settings.Location = false;
        }

        private void EnableLocation_Click(object sender, EventArgs e)
        {
            ViewModelLocator.MainStatic.Settings.Location = true;
        }

        private void DisableLocation_Click_1(object sender, EventArgs e)
        {
            ViewModelLocator.MainStatic.Settings.Location = false;
            ViewModelLocator.MainStatic.SaveSettingsToStorage();
            ChangeGeolocation();
        }

        private void EnableLocation_Click_1(object sender, EventArgs e)
        {
            ViewModelLocator.MainStatic.Settings.Location = true;
            ViewModelLocator.MainStatic.SaveSettingsToStorage();
            ChangeGeolocation();
        }
    }
}