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
using System.Collections.ObjectModel;
using Microsoft.Phone.Tasks;
using Microsoft.Phone.Net.NetworkInformation;
using Donor.Controls;
using System.Device.Location;
using Microsoft.Phone.Controls.Maps;
using AsyncOAuth;
using System.Security.Cryptography;
using System.Net.Http;

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

            GeoCoordinate currentLocation = new GeoCoordinate(Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Latitued.ToString()), Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Longitude.ToString()));
            map1.Children.Add(new Pushpin() { Location = currentLocation, Content = "Я" });
            GeoCoordinate stationLocation = new GeoCoordinate(ViewModelLocator.MainStatic.Stations.CurrentStation.Lat, ViewModelLocator.MainStatic.Stations.CurrentStation.Lon);
            map1.Children.Add(new Pushpin() { Location = stationLocation, Content = ViewModelLocator.MainStatic.Stations.CurrentStation.Name });
            map1.ZoomLevel = 14;
            map1.Center = stationLocation;

            ViewModelLocator.MainStatic.Reviews.LoadTipsFromFoursquareForStation();
        }

        private void ReviewsLoaded(object sender, EventArgs e)
        {
        }

        private void ListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Ads.CurrentAd = ((sender as ListBox).SelectedItem as AdsViewModel);
                NavigationService.Navigate(new Uri("/Pages/Ads/AdsPage.xaml", UriKind.Relative));
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

        private void TextBlock_Tap_2(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                PhoneCallTask callTask = new PhoneCallTask();
                string phone = "+7" + (sender as TextBlock).Text.Replace(" ", "").Replace("(", "").Replace(")", "").Replace("-", "");
                int index = phone.IndexOf(",");
                if (index > 0)
                    phone = phone.Substring(0, index);
                callTask.PhoneNumber = phone; //"88002505222";
                callTask.DisplayName = phone;
                callTask.Show();
            }
            catch
            {
            };
        }

        private void ReviewButton_Click(object sender, EventArgs e)
        {
            try
            {
                //OAuthUtility.ComputeHash = (key, buffer) => { using (var hmac = new HMACSHA1(key)) { return hmac.ComputeHash(buffer); } };
                //var client = new HttpClient(new OAuthMessageHandler(App.Foursquare_client_id, App.Foursquare_secret ));
                //new AccessToken("accessToken", "accessTokenSecret")
                //NavigationService.Navigate(new Uri("/ReviewPage.xaml?id=" + ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId, UriKind.Relative));
                try
                {
                    NavigationService.Navigate(new Uri("/ReviewPage.xaml", UriKind.Relative));
                }
                catch { };
            }
            catch
            {
            };
        }

        private void map1_MapPan(object sender, MapDragEventArgs e)
        {
            e.Handled = true;
        }

        private void map1_MapZoom(object sender, MapZoomEventArgs e)
        {
            e.Handled = true;
        }

        private void map1_ManipulationStarted(object sender, ManipulationStartedEventArgs e)
        {
            e.Handled = true;
        }
    }
}