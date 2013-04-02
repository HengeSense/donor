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

namespace Donor
{
    public partial class AchievesPage : PhoneApplicationPage
    {
        public AchievesPage()
        {
            InitializeComponent();
        }

        private void ListBox_Loaded(object sender, RoutedEventArgs e)
        {
            //this.AvailableBadges.ItemsSource = ViewModelLocator.BadgesStatic.AvailableAchieves;
            this.SoonBadges.ItemsSource = ViewModelLocator.BadgesStatic.SoonAchieves;
        }

        private void AvailableBadges_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                if ((this.AvailableBadges.SelectedItem as AchieveItem).Status == true)
                {
                    ViewModelLocator.BadgesStatic.ShowBadgeMessage();
                };
            }
            catch { };            
        }

        private void ItsbetaAppButton_Click(object sender, RoutedEventArgs e)
        {
            
            try
            {
                WebBrowserTask webTask = new WebBrowserTask();
                webTask.Uri = new Uri("http://www.windowsphone.com/ru-RU/store/app/itsbeta/609b66dc-4d84-4ba1-9b6c-bcc2ca1c03c6");
                webTask.Show();
            }
            catch { };
        }

        private void qtButton_Click(object sender, EventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/QRread.xaml", UriKind.Relative));
            }
            catch { };
        }

        private void ApplicationBarIconButton_Click_1(object sender, EventArgs e)
        {
            try
            {
                ViewModelLocator.BadgesStatic.DisableFirstBlood();
            }
            catch { };
        }
    }
}