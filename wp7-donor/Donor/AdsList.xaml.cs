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

namespace Donor
{
    public partial class AdsList : PhoneApplicationPage
    {
        public AdsList()
        {
            InitializeComponent();
            DataContext = App.ViewModel;
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

        private void ListBox_Tap(object sender, System.Windows.Input.GestureEventArgs e)
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
    }
}