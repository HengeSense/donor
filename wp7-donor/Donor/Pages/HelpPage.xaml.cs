﻿using System;
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
using Microsoft.Phone.Tasks;
using Donor.ViewModels;
using System.Collections.ObjectModel;
using Coding4Fun.Phone.Controls;
using MSPToolkit.Controls;

namespace Donor
{
    public partial class HelpPage : PhoneApplicationPage
    {
        public HelpPage()
        {
            InitializeComponent();

            this.AbsContra.DataContext = ViewModelLocator.MainStatic;
            this.AbsContra.ItemsSource = ViewModelLocator.MainStatic.Contras.Items;

            this.RelativeContra.DataContext = ViewModelLocator.MainStatic;
            this.RelativeContra.ItemsSource = ViewModelLocator.MainStatic.Contras.Items;
        }

        bool CustomFilter(string search, string value)
        {
            return (value.Length > 2);
        }
        bool SearchBank(string search, object value)
        {
            if (value != null)
            {
                if ((value as ContraViewModel).Title.ToString().ToLower().Contains(search))
                    return true;
            }
            return false;
        }

        private void PhoneNumber_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                PhoneCallTask callTask = new PhoneCallTask();
                callTask.PhoneNumber = (sender as TextBlock).Text; //"88002505222";
                callTask.DisplayName = (sender as TextBlock).Text;
                callTask.Show();
            }
            catch { 
            };
        }

        private void TextBlock_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                EmailComposeTask emilTask = new EmailComposeTask();
                emilTask.To = (sender as TextBlock).Text;
                emilTask.Subject = "WP7 Донор";
                emilTask.Body = "";
                emilTask.Show();
            }
            catch
            {
            };
        }

        private void Site_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                WebBrowserTask webbrowser = new WebBrowserTask();
                webbrowser.Uri = new Uri((sender as TextBlock).Text);
                webbrowser.Show();
            }
            catch
            {
            };
        }

        private void Rate_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                var marketplaceReviewTask = new MarketplaceReviewTask();
                marketplaceReviewTask.Show();
            }
            catch
            {
            };
        }

        private void TextBlock_Tap_1(object sender, System.Windows.Input.GestureEventArgs e)
        {
            if (this.AbsContra.Visibility == Visibility.Visible)
            {
                this.AbsContra.Visibility = Visibility.Collapsed;
            }
            else
            {
                var absitems = (from item in ViewModelLocator.MainStatic.Contras.Items
                                where item.Absolute == true
                                select item);
                this.AbsContra.ItemsSource = absitems;
                this.AbsContra.Visibility = Visibility.Visible;
            };
        }

        private void RelText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            if (this.RelativeContra.Visibility == Visibility.Visible)
            {
                this.RelativeContra.Visibility = Visibility.Collapsed;
                this.RelText.Height = 180;
            }
            else
            {
                var relitems = (from item in ViewModelLocator.MainStatic.Contras.Items
                                where (item.Absolute == false) || (item.Absolute != true)
                                select item);

                this.RelText.Height = 110;

                this.RelativeContra.ItemsSource = relitems;
                this.RelativeContra.Visibility = Visibility.Visible;
            };
        }

        private void StationsSearchText_Populating(object sender, PopulatingEventArgs e)
        {
            try
            {
                string searchtext = this.ContraSearchText.Text;
                if (searchtext != "")
                {
                    this.SearchContra.ItemsSource = from item in ViewModelLocator.MainStatic.Contras.Items
                                                    where (item.Title.ToString().ToLower().Contains(searchtext.ToLower()))
                                                    select item;
                }
                else
                {
                    this.SearchContra.ItemsSource = new ObservableCollection<ContraViewModel>();
                };
            }
            catch
            {
            };
        }

        private void ContraSearchText_Populated(object sender, PopulatedEventArgs e)
        {
            try
            {
                string searchtext = this.ContraSearchText.Text;
                if (searchtext == "")
                {
                    this.SearchContra.ItemsSource = new ObservableCollection<ContraViewModel>();
                };
            }
            catch { };
        }

        private void ContraSearchText_LostFocus(object sender, RoutedEventArgs e)
        {
            try
            {
                string searchtext = this.ContraSearchText.Text;
                if (searchtext == "")
                {
                    this.SearchContra.ItemsSource = new ObservableCollection<ContraViewModel>();
                };
            }
            catch { };
        }

        private void PrivacyMenu_Click(object sender, System.EventArgs e)
        {
            var messagePrompt = new MessagePrompt
            {
                Title = AppResources.PrivacyPolicy,
                Body = new HTMLViewer { Html = AppResources.PrivacyPolicyDescription, MaxHeight = 500 },
                IsAppBarVisible = false,
                IsCancelVisible = false
            };
            messagePrompt.Show();
        }

        private void RateButton_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var marketplaceReviewTask = new MarketplaceReviewTask();
                marketplaceReviewTask.Show();
            }
            catch
            {
            };
        }

    }
}