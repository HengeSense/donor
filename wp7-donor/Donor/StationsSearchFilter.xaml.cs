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
    public partial class StationsSearchFilter : PhoneApplicationPage
    {
        public StationsSearchFilter()
        {
            InitializeComponent();
        }

        private void CitySelect_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            App.ViewModel.Stations.SelectedCity = ((sender as ListPicker).SelectedItem as ListBoxItem).Content.ToString();
        }

        private void regional_Unchecked(object sender, RoutedEventArgs e)
        {
            App.ViewModel.Stations.IsRegional = false;
        }

        private void regional_Checked(object sender, RoutedEventArgs e)
        {
            App.ViewModel.Stations.IsRegional = true;
        }

        private void saturdays_Checked(object sender, RoutedEventArgs e)
        {
            App.ViewModel.Stations.IsSaturdayWork = true;
        }

        private void saturdays_Unchecked(object sender, RoutedEventArgs e)
        {
            App.ViewModel.Stations.IsSaturdayWork = false;
        }

        private void childrens_Unchecked(object sender, RoutedEventArgs e)
        {
            App.ViewModel.Stations.IsChildrenDonor = false;
        }

        private void childrens_Checked(object sender, RoutedEventArgs e)
        {
            App.ViewModel.Stations.IsChildrenDonor = true;
        }

        private void SaveButton1_Click(object sender, System.EventArgs e)
        {
        	// TODO: Add event handler implementation here.
            App.ViewModel.Stations.IsFilter = true;
            NavigationService.GoBack();
        }

        private void cancelButton_Click(object sender, System.EventArgs e)
        {
        	// TODO: Add event handler implementation here.
            App.ViewModel.Stations.IsFilter = false;
            NavigationService.GoBack();
        }

    }
}