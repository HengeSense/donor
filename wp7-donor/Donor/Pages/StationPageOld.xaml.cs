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

namespace Donor
{
    public partial class StationPageOld : PhoneApplicationPage
    {
        public StationPageOld()
        {
            InitializeComponent();
            this.MainPanorama.DefaultItem = this.MainPanorama.Items[0];
        }

        //private string _stationid_current;
        //private StationViewModel _currentStation;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            //if (this.NavigationContext.QueryString.ContainsKey("id"))
            //{
                try
                {
                    //string _id = this.NavigationContext.QueryString["id"];
                    //_stationid_current = _id;
                    //_currentStation = ViewModelLocator.MainStatic.Stations.Items.FirstOrDefault(c => c.objectId.ToString() == _id.ToString());
                    //DataContext = _currentStation;

                    List<AdsViewModel> adsItems = ViewModelLocator.MainStatic.Ads.LoadStationAds(ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId.ToString());
                    if (adsItems.Count() > 0)
                    {
                        //this.StationAds.ItemsSource = adsItems;
                    }
                    else
                    {
                        //this.PanaramaAdsItem.Visibility = Visibility.Collapsed;
                    };

                    bool hasNetworkConnection =
                    NetworkInterface.NetworkInterfaceType != NetworkInterfaceType.None;
                    if (hasNetworkConnection)
                    {
                        ViewModelLocator.MainStatic.Reviews.LoadReviewsForStation(ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId.ToString());
                    }
                    else
                    {
                        this.progressOverlay.Visibility = Visibility.Collapsed;
                        this.progressOverlay.IsEnabled = false;
                    };

                    ViewModelLocator.MainStatic.Reviews.ReviewsLoaded += new ReviewsListViewModel.ReviewsLoadedEventHandler(this.ReviewsLoaded);
                }
                catch
                {
                    NavigationService.GoBack();
                };
            /*}
            else
            {
                NavigationService.GoBack();
            };*/
        }

        private void ReviewsLoaded(object sender, EventArgs e)
        {
            try
            {
                //this.StationReviews.ItemsSource = ViewModelLocator.MainStatic.Reviews.Items;
                int votes = 0;
                foreach (var item in ViewModelLocator.MainStatic.Reviews.Items) {
                    votes = votes + item.Rate;
                };
                this.rate.Vote = (int)Math.Round((double)votes / (double)ViewModelLocator.MainStatic.Reviews.Items.Count());

                this.progressOverlay.Visibility = Visibility.Collapsed;
                this.progressOverlay.IsEnabled = false;
            }
            catch
            {
                this.progressOverlay.Visibility = Visibility.Collapsed;
                this.progressOverlay.IsEnabled = false;
            };
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
                NavigationService.Navigate(new Uri("/Pages/Stations/MapPage.xaml?id=" + ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId, UriKind.Relative));
            }
            catch
            {
            };
        }

        private void TextBlock_Tap_1(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/Pages/Stations/MapPage.xaml?id=" + ViewModelLocator.MainStatic.Stations.CurrentStation.ObjectId, UriKind.Relative));
            }
            catch
            {
            };
        }

        private void VotesControl_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                (sender as VotesControl).Vote = Int32.Parse((sender as VotesControl).Tag.ToString());
            }
            catch
            {
            };
        }
    }
}