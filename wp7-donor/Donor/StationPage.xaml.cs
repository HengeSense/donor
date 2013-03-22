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
using System.Collections.ObjectModel;
using Microsoft.Phone.Tasks;
using Microsoft.Phone.Net.NetworkInformation;
using Donor.Controls;

namespace Donor
{
    public partial class StationPage : PhoneApplicationPage
    {
        public StationPage()
        {
            InitializeComponent();
            this.MainPanorama.DefaultItem = this.MainPanorama.Items[0];
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
                try
                {
                }
                catch
                {
                    NavigationService.GoBack();
                };
        }

        private void ReviewsLoaded(object sender, EventArgs e)
        {
            try
            {
            }
            catch
            {
            };
        }

        private void ListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Ads.CurrentAd = ((sender as ListBox).SelectedItem as AdsViewModel);
                NavigationService.Navigate(new Uri("/AdsPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }

        private void CreateReviewButton_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/CreateReviewPage.xaml?id=" + ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId, UriKind.Relative));
        }

        private void VotesControl_VoteChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {
        }

        private void TextBlock_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                WebBrowserTask webbrowser = new WebBrowserTask();
                webbrowser.Uri = new Uri(ViewModelLocator.MainStatic.Stations.CurrentStation.Site);
                webbrowser.Show();
            }
            catch
            {
            };
        }

        private void Image_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/MapPage.xaml?id=" + ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId, UriKind.Relative));
            }
            catch
            {
            };
        }

        private void TextBlock_Tap_1(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/MapPage.xaml?id=" + ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId, UriKind.Relative));
            }
            catch
            {
            };
        }
    }
}