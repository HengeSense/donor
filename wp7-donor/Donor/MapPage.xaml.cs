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
using GART;
using GART.Controls;
using GART.Data;
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

        private string _eventid_current;
        private EventViewModel _currentEvent;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _eventid = this.NavigationContext.QueryString["id"];
                    _eventid_current = _eventid;
                    _currentEvent = App.ViewModel.Events.Items.FirstOrDefault(c => c.Id == _eventid.ToString());
                    DataContext = _currentEvent;
                }
                catch { };
            };
            ObservableCollection<ARItem> items = new ObservableCollection<ARItem>();

            ARStation mapitem = new ARStation();
            GeoCoordinate currentLocation = new GeoCoordinate(Convert.ToDouble(App.ViewModel.Stations.Latitued.ToString()), Convert.ToDouble(App.ViewModel.Stations.Longitude.ToString()));
            //mapitem.Content = new Pushpin() { Location = currentLocation, Content = "Тут" };
            map1.Children.Add(new Pushpin() { Location = currentLocation, Content = "Тут" });

            mapitem.GeoLocation = currentLocation;

            mapitem.Title = "Тут";
            mapitem.Adress = "Адрес";
            items.Add(mapitem);

            foreach (var item in App.ViewModel.Stations.Items)
            {
                mapitem = new ARStation();
                mapitem.GeoLocation = new GeoCoordinate(Convert.ToDouble(item.Lat.ToString()), Convert.ToDouble(item.Lon.ToString()));
                mapitem.Content = item.Title;
                map1.Children.Add(new Pushpin() { Location = mapitem.GeoLocation, Content = item.Title });

                mapitem.Title = item.Title;
                mapitem.Adress = item.Adress;
                items.Add(mapitem);
            };
            ARDisplay.ARItems = items;
            
        }

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            // Stop AR services
            //ARDisplay.StopServices();
            
            base.OnNavigatedFrom(e);
        }

        protected override void OnNavigatedTo(System.Windows.Navigation.NavigationEventArgs e)
        {
            // Start AR services
            //ARDisplay.StartServices();
            ARDisplay.Visibility = Visibility.Collapsed;
            base.OnNavigatedTo(e);
        }

        private void ThreeDButton_Click(object sender, System.EventArgs e)
        {
           //UIHelper.ToggleVisibility(WorldView);
           ARDisplay.StartServices();
           this.ARDisplay.Visibility = Visibility.Visible;
        }

        private void RemoveAR_Click(object sender, EventArgs e)
        {
            this.ARDisplay.Visibility = Visibility.Collapsed;
            ARDisplay.StopServices();
        }
    }
}