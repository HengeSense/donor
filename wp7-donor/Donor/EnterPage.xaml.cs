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

namespace Donor
{
    public partial class EnterPage : PhoneApplicationPage
    {
        public EnterPage()
        {
            InitializeComponent();
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/ProfileLogin.xaml?task=login", UriKind.Relative));
            }
            catch { };
        }

        private void FacebookLogin_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/FacebookPages/FacebookLoginPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                if (App.ViewModel.User.IsLoggedIn == true)
                {
                    NavigationService.GoBack();
                };
            }
            catch {
            };

            App.ViewModel.UserEnter += new MainViewModel.UserEnterEventHandler(this.UserLoaded);
        }

        private void UserLoaded(object sender, EventArgs e)
        {
            try
            {
                if (App.ViewModel.User.IsLoggedIn == true)
                {
                    try
                    {
                        if (NavigationService.CanGoBack == true)
                        {
                            NavigationService.GoBack();
                        }
                        else
                        {
                            NavigationService.Navigate(new Uri("/MainPage.xaml", UriKind.Relative)); 
                        };
                    }
                    catch { };
                }
                else
                {
                };
            }
            catch
            {
            };
        }

        private void RegisterShowButton_Click(object sender, RoutedEventArgs e)
        {
            try { 
                NavigationService.Navigate(new Uri("/ProfileLogin.xaml?task=register", UriKind.Relative)); 
            }
            catch { };
        }
    }
}