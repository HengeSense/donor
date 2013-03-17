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
using MyToolkit.Controls;


namespace Donor
{
    public partial class AdsPage : PhoneApplicationPage 
    {
        public AdsPage()
        {
            InitializeComponent();

            //FixedHtmlTextBlock item;
        }

        private string _adsid_current;
        private AdsViewModel _currentAds;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (ViewModelLocator.MainStatic.Ads.CurrentAd!=null) {
            /*if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _newsid = this.NavigationContext.QueryString["id"];
                    _adsid_current = _newsid;
                    _currentAds = ViewModelLocator.MainStatic.Ads.Items.FirstOrDefault(c => c.ObjectId == _newsid.ToString());
                    DataContext = _currentAds;
                }
                catch
                {
                    NavigationService.GoBack();
                };*/
            }
            else
            {
                NavigationService.GoBack();
            };
        }

        private void ShareButton_Click(object sender, System.EventArgs e)
        {
            ViewModelLocator.MainStatic.SendToShare(ViewModelLocator.MainStatic.Ads.CurrentAd.Title, 
                ViewModelLocator.MainStatic.Ads.CurrentAd.Url, 
                ViewModelLocator.MainStatic.Ads.CurrentAd.ShortBody, 130);
        }
    }
}