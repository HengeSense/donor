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
        private string _newsid_current;
        private NewsViewModel _currentNews;
        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _newsid = this.NavigationContext.QueryString["id"];
                    _newsid_current = _newsid;
                    _currentNews = App.ViewModel.News.Items.FirstOrDefault(c => c.ObjectId == _newsid.ToString());

                    _currentNews.Body = _currentNews.Body.Replace("<br />"," ");
                    _currentNews.Body = _currentNews.Body.Replace("color=\"FF0000\"","color=\"#FF0000\"");
                    

                    DataContext = _currentNews;
                }
                catch
                {
                    NavigationService.GoBack();
                };
            }
            else
            {
                NavigationService.GoBack();
            };
        }

        private void ShareButton_Click(object sender, EventArgs e)
        {
            App.ViewModel.SendToShare(_currentNews.Title, _currentNews.Url, _currentNews.ShortBody, 130);
        }

        private void AdvancedApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            WebBrowserTask webTask = new WebBrowserTask();
            webTask.Uri = new Uri(_currentNews.Url);
            webTask.Show();
        }

        private void ReadMore_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            WebBrowserTask webTask = new WebBrowserTask();
            webTask.Uri = new Uri(_currentNews.Url);
            webTask.Show();
        }
    }
}