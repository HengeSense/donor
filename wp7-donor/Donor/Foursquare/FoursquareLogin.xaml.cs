using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Shell;

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

        private void webBrowser1_Navigated(object sender, System.Windows.Navigation.NavigationEventArgs e)
        {
            string backurl = e.Uri.Query;
            return;
        }


    }
}