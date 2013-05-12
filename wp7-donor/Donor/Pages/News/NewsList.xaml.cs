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
    public partial class NewsList : PhoneApplicationPage
    {
        // Constructor
        public NewsList()
        {
            InitializeComponent();
            DataContext = ViewModelLocator.MainStatic;
        }

        private void RadJumpList_ItemTap(object sender, Telerik.Windows.Controls.ListBoxItemTapEventArgs e)
        {
            try
            {
                string id = ((NewsViewModel)e.Item.Content).ObjectId;
                ViewModelLocator.MainStatic.News.CurrentNews = ViewModelLocator.MainStatic.News.Items.FirstOrDefault(c => c.ObjectId == id);
                NavigationService.Navigate(new Uri("/Pages/News/NewsPage.xaml", UriKind.Relative));
            }
            catch
            {
            }
        }
    }
}