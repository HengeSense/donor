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
using Microsoft.Phone.Tasks;

namespace Donor
{
    public partial class NewsPage : PhoneApplicationPage
    {
        public NewsPage()
        {
            InitializeComponent();
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (ViewModelLocator.MainStatic.News.CurrentNews==null)
            {
                NavigationService.GoBack();
            };
        }

        private void ShareButton_Click(object sender, EventArgs e)
        {
            ViewModelLocator.MainStatic.SendToShare(ViewModelLocator.MainStatic.News.CurrentNews.Title, ViewModelLocator.MainStatic.News.CurrentNews.Url, ViewModelLocator.MainStatic.News.CurrentNews.ShortBody, 130);
        }

        private void AdvancedApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            WebBrowserTask webTask = new WebBrowserTask();
            webTask.Uri = new Uri(ViewModelLocator.MainStatic.News.CurrentNews.Url);
            webTask.Show();
        }

        private void ReadMore_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            WebBrowserTask webTask = new WebBrowserTask();
            webTask.Uri = new Uri(ViewModelLocator.MainStatic.News.CurrentNews.Url);
            webTask.Show();
        }
    }
}