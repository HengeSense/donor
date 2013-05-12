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
using Newtonsoft.Json.Linq;
using RestSharp;
using Donor.ViewModels;

namespace Donor
{
    public partial class ReviewPage : PhoneApplicationPage
    {
        public ReviewPage()
        {
            InitializeComponent();
        }

        private static double ConvertToTimestamp(DateTime value)
        {
            TimeSpan span = (value - new DateTime(1970, 1, 1, 0, 0, 0, 0).ToLocalTime());
            return (double)Math.Round(span.TotalSeconds);
        } 

        private async void SaveButton_Click(object sender, EventArgs e)
        {
            if (ViewModelLocator.MainStatic.User.FoursquareToken == "")
            {
                try
                {
                    NavigationService.Navigate(new Uri("/Pages/Foursquare/FoursquareLogin.xaml", UriKind.Relative));
                }
                catch { };
            }
            else
            {
                ViewModelLocator.MainStatic.Reviews.SendReview();
                NavigationService.GoBack();
            };
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            NavigationService.GoBack();
        }

        private string _stationid_current;
        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            try {
            } catch {};
        }
    }
}