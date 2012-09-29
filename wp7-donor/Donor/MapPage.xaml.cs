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

        private string _stationid_current;
        private StationViewModel _currentStation = null;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
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
            ObservableCollection<ARItem> items = new ObservableCollection<ARItem>();

            ARStation mapitem = new ARStation();
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

            mapitem.GeoLocation = currentLocation;

            mapitem.Title = "Я";
            mapitem.Adress = "Текущее положение";
            items.Add(mapitem);

            if (_currentStation == null)
            {
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
            }
            else
            {
                mapitem = new ARStation();
                mapitem.GeoLocation = new GeoCoordinate(Convert.ToDouble(_currentStation.Lat.ToString()), Convert.ToDouble(_currentStation.Lon.ToString()));
                mapitem.Content = _currentStation.Title;
                map1.Children.Add(new Pushpin() { Location = mapitem.GeoLocation, Content = _currentStation.Title });

                mapitem.Title = _currentStation.Title;
                mapitem.Adress = _currentStation.Adress;
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