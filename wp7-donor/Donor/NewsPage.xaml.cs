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
            //App.ViewModel.SendToShare(_currentNews.Title, _currentNews.Link, _currentNews.Description, 130);
        }

        private void AdvancedApplicationBarIconButton_Click(object sender, EventArgs e)
        {
            WebBrowserTask webTask = new WebBrowserTask();
            //webTask.Uri = new Uri(_currentNews.Link);
            webTask.Show();
        }
    }
}