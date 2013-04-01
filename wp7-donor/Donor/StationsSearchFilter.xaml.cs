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
    public partial class StationsSearchFilter : PhoneApplicationPage
    {
        public StationsSearchFilter()
        {
            InitializeComponent();
        }

        private void CitySelect_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (LoadedCity)
            {
                ViewModelLocator.MainStatic.Stations.SelectedCity = ((sender as ListPicker).SelectedItem as ListBoxItem).Content.ToString();
            };
        }

        private void regional_Unchecked(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.Stations.IsRegional = false;
        }

        private void regional_Checked(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.Stations.IsRegional = true;
        }

        private void saturdays_Checked(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.Stations.IsSaturdayWork = true;
        }

        private void saturdays_Unchecked(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.Stations.IsSaturdayWork = false;
        }

        private void childrens_Unchecked(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.Stations.IsChildrenDonor = false;
        }

        private void childrens_Checked(object sender, RoutedEventArgs e)
        {
            ViewModelLocator.MainStatic.Stations.IsChildrenDonor = true;
        }

        private void SaveButton1_Click(object sender, System.EventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Stations.IsFilter = true;
                NavigationService.GoBack();
            }
            catch { };
        }

        private void cancelButton_Click(object sender, System.EventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Stations.IsFilter = false;
                NavigationService.GoBack();
            }
            catch { };
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
        }

        private bool LoadedCity = false;

        private void CitySelect_Loaded(object sender, RoutedEventArgs e)
        {
        }

    }
}