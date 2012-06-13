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
    public partial class StationsSearch : PhoneApplicationPage
    {
        public StationsSearch()
        {
            InitializeComponent();
        }

        private void StationsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as StationViewModel).objectId;
                NavigationService.Navigate(new Uri("/StationPage.xaml?id="+id, UriKind.Relative));
            }
            catch
            {
            }
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            this.StationsList.DataContext = App.ViewModel;
            this.StationsList.ItemsSource = App.ViewModel.Stations.Items;
        }

    }
}