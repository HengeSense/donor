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

namespace Donor
{
    public partial class StationPage : PhoneApplicationPage
    {
        public StationPage()
        {
            InitializeComponent();
            this.MainPanorama.DefaultItem = this.MainPanorama.Items[0];
        }

        private string _stationid_current;
        private StationViewModel _currentStation;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _id = this.NavigationContext.QueryString["id"];
                    _stationid_current = _id;
                    _currentStation = App.ViewModel.Stations.Items.FirstOrDefault(c => c.objectId == _id.ToString());
                    DataContext = _currentStation;

                    List<AdsViewModel> adsItems = App.ViewModel.Ads.LoadStationAds(_currentStation.Nid.ToString());
                    if (adsItems.Count() > 0)
                    {
                        this.StationAds.ItemsSource = adsItems;
                    }
                    else
                    {
                        this.PanaramaAdsItem.Visibility = Visibility.Collapsed;
                    };

                    App.ViewModel.Reviews.LoadReviewsForStation(_currentStation.Nid.ToString());

                    App.ViewModel.Reviews.ReviewsLoaded += new ReviewsListViewModel.ReviewsLoadedEventHandler(this.ReviewsLoaded);

                    this.progressOverlay.Visibility = Visibility.Collapsed;
                    this.progressOverlay.IsEnabled = false;
                }
                catch
                {
                    NavigationService.GoBack();
                };
            }
            else
            {
                NavigationService.GoBack();
            };
        }

        private void ReviewsLoaded(object sender, EventArgs e)
        {
            try
            {
                ObservableCollection<ReviewsViewModel> reviewslist1 = new ObservableCollection<ReviewsViewModel>();
                reviewslist1 = App.ViewModel.Reviews.Items;

                this.StationReviews.ItemsSource = App.ViewModel.Reviews.Items;
            }
            catch
            {
            };
        }

        private void ListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as AdsViewModel).ObjectId;
                NavigationService.Navigate(new Uri("/AdsPage.xaml?id=" + id, UriKind.Relative));
            }
            catch
            {
            }
        }

        private void CreateReviewButton_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/CreateReviewPage.xaml?id=" + _stationid_current, UriKind.Relative));
        }

        private void VotesControl_VoteChanged(object sender, System.ComponentModel.PropertyChangedEventArgs e)
        {

        }
    }
}