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
    public partial class StationsSearchFilterOld : PhoneApplicationPage
    {
        public StationsSearchFilterOld()
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
            ViewModelLocator.MainStatic.Stations.IsFilter = true;

            if (this.childrens.IsChecked == true)
            {
                ViewModelLocator.MainStatic.Stations.IsChildrenDonor = true;
            }
            else { ViewModelLocator.MainStatic.Stations.IsChildrenDonor = false; };

            if (this.saturdays.IsChecked == true)
            {
                ViewModelLocator.MainStatic.Stations.IsSaturdayWork = true;
            }
            else { ViewModelLocator.MainStatic.Stations.IsSaturdayWork = false; };

            if (this.regional.IsChecked == true)
            {
                ViewModelLocator.MainStatic.Stations.IsRegional = true;
            }
            else { ViewModelLocator.MainStatic.Stations.IsRegional = false; };

            if (LoadedCity)
            {
                try
                {
                    ViewModelLocator.MainStatic.Stations.SelectedCity = (this.CitySelect.SelectedItem as ListBoxItem).Content.ToString();
                }
                catch { 
                };
            };

            NavigationService.GoBack();
        }

        private void cancelButton_Click(object sender, System.EventArgs e)
        {
        	// TODO: Add event handler implementation here.
            ViewModelLocator.MainStatic.Stations.IsFilter = false;
            NavigationService.GoBack();
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (ViewModelLocator.MainStatic.Stations.IsChildrenDonor == true)
            {
                this.childrens.IsChecked = true;
            }
            else { this.childrens.IsChecked = false; };

            if (ViewModelLocator.MainStatic.Stations.IsSaturdayWork == true)
            {
              this.saturdays.IsChecked  = true;
            }
            else { this.saturdays.IsChecked = false; };

            if (ViewModelLocator.MainStatic.Stations.IsRegional == true)
            {
                this.regional.IsChecked = true;
            }
            else { this.regional.IsChecked = false; };
        }

        private bool LoadedCity = false;

        private void CitySelect_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
            if (ViewModelLocator.MainStatic.Stations.IsFilter == true)
            {
                switch (ViewModelLocator.MainStatic.Stations.SelectedCity)
                {
                    case "Москва": this.CitySelect.SelectedIndex = 0; break;
                    case "Санкт-Петербург": this.CitySelect.SelectedIndex = 1; break;
                };
            }
            else
            {
            };
            }
            catch
            {
            };

            LoadedCity = true;
        }

        private void CitySelect_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            if (LoadedCity)
            {
                ViewModelLocator.MainStatic.Stations.SelectedCity = ((sender as ListPicker).SelectedItem as ListBoxItem).Content.ToString();
            };
        }

    }
}