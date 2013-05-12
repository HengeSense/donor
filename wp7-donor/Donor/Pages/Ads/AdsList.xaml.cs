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
            DataContext = ViewModelLocator.MainStatic;
        }

        private void RadJumpList_ItemTap_1(object sender, Telerik.Windows.Controls.ListBoxItemTapEventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Ads.CurrentAd = (e.Item.Content as AdsViewModel);
                NavigationService.Navigate(new Uri("/Pages/Ads/AdsPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }
    }
}