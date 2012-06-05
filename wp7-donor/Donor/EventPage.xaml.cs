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
    public partial class EventPage : PhoneApplicationPage
    {
        public EventPage()
        {
            InitializeComponent();
        }
        private string _eventid_current;
        private EventViewModel _currentEvent;
        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (this.NavigationContext.QueryString.ContainsKey("id"))
            {
                try
                {
                    string _eventid = this.NavigationContext.QueryString["id"];
                    _eventid_current = _eventid;
                    _currentEvent = App.ViewModel.Events.Items.FirstOrDefault(c => c.Id == _eventid.ToString());
                    DataContext = _currentEvent;

                    if (_currentEvent.Type == "Праздник")
                    {
                        this.AppBar.Visibility = Visibility.Collapsed;
                        this.AppBar.IsVisible = false;
                    };
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

        private void DeleteButton_Click(object sender, EventArgs e)
        {
            try
            {
                App.ViewModel.Events.Items.Remove(_currentEvent);
                NavigationService.GoBack();
            }
            catch
            {
                NavigationService.GoBack();
            };
        }

        private void EditButton_Click(object sender, EventArgs e)
        {
            try {
                NavigationService.Navigate(new Uri("/EventEditPage.xaml?id=" + _currentEvent.Id, UriKind.Relative));
            }
            catch {
            };
        }
    }
}