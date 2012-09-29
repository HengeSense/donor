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
            if (LoadedCity)
            {
                App.ViewModel.Stations.SelectedCity = ((sender as ListPicker).SelectedItem as ListBoxItem).Content.ToString();
            };
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
            App.ViewModel.Stations.IsFilter = true;

            if (this.childrens.IsChecked == true)
            {
                App.ViewModel.Stations.IsChildrenDonor = true;
            }
            else { App.ViewModel.Stations.IsChildrenDonor = false; };

            if (this.saturdays.IsChecked == true)
            {
                App.ViewModel.Stations.IsSaturdayWork = true;
            }
            else { App.ViewModel.Stations.IsSaturdayWork = false; };

            if (this.regional.IsChecked == true)
            {
                App.ViewModel.Stations.IsRegional = true;
            }
            else { App.ViewModel.Stations.IsRegional = false; };

            if (LoadedCity)
            {
                try
                {
                    App.ViewModel.Stations.SelectedCity = (this.CitySelect.SelectedItem as ListBoxItem).Content.ToString();
                }
                catch { 
                };
            };

            NavigationService.GoBack();
        }

        private void cancelButton_Click(object sender, System.EventArgs e)
        {
        	// TODO: Add event handler implementation here.
            App.ViewModel.Stations.IsFilter = false;
            NavigationService.GoBack();
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (App.ViewModel.Stations.IsChildrenDonor == true)
            {
                this.childrens.IsChecked = true;
            }
            else { this.childrens.IsChecked = false; };

            if (App.ViewModel.Stations.IsSaturdayWork == true)
            {
              this.saturdays.IsChecked  = true;
            }
            else { this.saturdays.IsChecked = false; };

            if (App.ViewModel.Stations.IsRegional == true)
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
            if (App.ViewModel.Stations.IsFilter == true)
            {
                switch (App.ViewModel.Stations.SelectedCity)
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
                App.ViewModel.Stations.SelectedCity = ((sender as ListPicker).SelectedItem as ListBoxItem).Content.ToString();
            };
        }

    }
}