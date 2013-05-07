using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;
using Donor.ViewModels;

namespace Donor.Foursquare
{
    public partial class FoursquareLogin : PhoneApplicationPage
    {
        public FoursquareLogin()
        {
            InitializeComponent();
        }

        private void webBrowser1_Loaded(object sender, RoutedEventArgs e)
        {
            var loginUrl = new Uri("https://foursquare.com/oauth2/authenticate?client_id="+App.Foursquare_client_id+"&response_type=token&redirect_uri=http://donorapp.ru"); //GetFacebookLoginUrl(AppId, ExtendedPermissions);
            webBrowser1.Navigate(loginUrl);
        }
        private bool navigatedToken = false;
        private async void webBrowser1_Navigated(object sender, System.Windows.Navigation.NavigationEventArgs e)
        {
            try
            {
                string backurl = e.Uri.ToString();
                if ((e.Uri.Host == "donorapp.ru") && (!navigatedToken))
                {
                    ViewModelLocator.MainStatic.User.FoursquareToken = backurl.Replace("http://donorapp.ru/#access_token=", "");
                    navigatedToken = true;
                    await ViewModelLocator.MainStatic.Reviews.SendReview();
                    //RootFrame.RemoveBackEntry();
                    try
                    {
                        NavigationService.RemoveBackEntry();
                    }
                    catch { };
                    try
                    {
                        NavigationService.GoBack();
                    }
                    catch { };
                };
                return;
            }
            catch { };
        }


    }
}