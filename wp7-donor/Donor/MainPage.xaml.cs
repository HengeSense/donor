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
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using RestSharp;

namespace Donor
{
    public partial class MainPage : PhoneApplicationPage
    {
        // Constructor
        public MainPage()
        {
            InitializeComponent();

            // Set the data context of the listbox control to the sample data
            DataContext = App.ViewModel;
            this.Loaded += new RoutedEventHandler(MainPage_Loaded);
        }

        // Load data for the ViewModel Items
        private void MainPage_Loaded(object sender, RoutedEventArgs e)
        {
            if (!App.ViewModel.IsDataLoaded)
            {
                App.ViewModel.LoadData();
            }

            if (App.ViewModel.User.IsLoggedIn == true)
            {
                this.LoginForm.Visibility = Visibility.Collapsed;
                this.UserProfile.Visibility = Visibility.Visible;
            }
            else
            {
                this.LoginForm.Visibility = Visibility.Visible;
                this.UserProfile.Visibility = Visibility.Collapsed;
            };
        }

        private void TextBlock_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            //NavigationService.Navigate(new Uri("/ProfileLogin.xaml", UriKind.Relative));
            NavigationService.Navigate(new Uri("/ProfileLogin.xaml?task=edit", UriKind.Relative));
        }

        private void Stations_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/StationsSearch.xaml?task=edit", UriKind.Relative));
        }

        private void ListBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as NewsViewModel).ObjectId;
                NavigationService.Navigate(new Uri("/NewsPage.xaml?id=" + id, UriKind.Relative));
            }
            catch
            {
            }
        }

        private void NewMenuItem_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/NewsList.xaml", UriKind.Relative));
        }

        private void EventsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as EventViewModel).Id;
                NavigationService.Navigate(new Uri("/EventPage.xaml?id=" + id, UriKind.Relative));
            }
            catch
            {
            }
        }

        private void CalendarMenuText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            //NavigationService.Navigate(new Uri("/CalendarMonthPage.xaml", UriKind.Relative));
            if (App.ViewModel.User.IsLoggedIn)
            {
                NavigationService.Navigate(new Uri("/CalendarYearPage.xaml", UriKind.Relative));
            }
            else
            {
                MessageBox.Show("Please enter if you wish to add events to yofur calendar.");
            };
        }

        private void EventsList_Loaded(object sender, RoutedEventArgs e)
        {
            //this.NewsList.DataContext = App.ViewModel.News;
            //this.EventsList.DataContext = App.ViewModel;
            //this.NewsList.ItemsSource = App.ViewModel.News.NewItems;
            //this.EventsList.ItemsSource = App.ViewModel.Events.Items;
        }

        private void UserLoaded(object sender, EventArgs e)
        {
            try
            {
                if (App.ViewModel.User.IsLoggedIn == true)
                {
                    try
                    {
                        this.ProfileName.Text = App.ViewModel.User.Name.ToString();
                        this.ProfileSex.Text = App.ViewModel.User.OutSex.ToString();
                        this.ProfileBloodGroup.Text = App.ViewModel.User.OutBloodGroup.ToString();
                    }
                    catch { };
                    this.UserProfile.Visibility = Visibility.Visible;
                    this.LoginForm.Visibility = Visibility.Collapsed;
                }
                else
                {
                };
            }
            catch
            {
            };
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            App.ViewModel.UserEnter += new MainViewModel.UserEnterEventHandler(this.UserLoaded);

            try
            {
                if (App.ViewModel.User.IsLoggedIn == true)
                {
                    try
                    {
                        this.ProfileName.Text = App.ViewModel.User.Name.ToString();
                        this.ProfileSex.Text = App.ViewModel.User.OutSex.ToString();
                        this.ProfileBloodGroup.Text = App.ViewModel.User.OutBloodGroup.ToString();
                    }
                    catch { };
                    this.UserProfile.Visibility = Visibility.Visible;
                }
                else
                {
                };
            }
            catch { 
            };
        }

        private void TextBlock_Tap_1(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/ProfileLogin.xaml", UriKind.Relative));
        }

        private void Login_Click(object sender, RoutedEventArgs e)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/login", Method.GET);
            request.Parameters.Clear();
            string strJSONContent = "{\"username\":\"" + this.email.Text.ToLower() + "\",\"password\":\"" + this.password.Password + "\"}";
            request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
            request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");

            request.AddParameter("username", this.email.Text.ToLower());
            request.AddParameter("password", this.password.Password);
            this.LoginLoadingBar.IsIndeterminate = true;

            client.ExecuteAsync(request, response =>
            {
                this.LoginLoadingBar.IsIndeterminate = false;
                JObject o = JObject.Parse(response.Content.ToString());
                if (o["error"] == null)
                {
                    App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                    App.ViewModel.User.IsLoggedIn = true;

                    App.ViewModel.User.Password = this.password.Password;
                    App.ViewModel.SaveUserToStorage();

                    this.LoginForm.Visibility = Visibility.Collapsed;
                    this.UserProfile.Visibility = Visibility.Visible;

                    try
                    {
                        this.ProfileName.Text = App.ViewModel.User.Name.ToString();
                        this.ProfileSex.Text = App.ViewModel.User.OutSex.ToString();
                        this.ProfileBloodGroup.Text = App.ViewModel.User.OutBloodGroup.ToString();                       
                    }
                    catch { };
                }
                else
                {
                    //MessageBox.Show("Ошибка входа: " + o["error"].ToString());
                    App.ViewModel.User.IsLoggedIn = false;

                    this.LoginForm.Visibility = Visibility.Visible;
                    this.UserProfile.Visibility = Visibility.Collapsed;

                    NavigationService.Navigate(new Uri("/ProfileLogin.xaml?task=register", UriKind.Relative));
                };
            });
        }

        private void adsMenuText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/AdsList.xaml", UriKind.Relative));
        }

        private void HelpMenuText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/HelpPage.xaml", UriKind.Relative));
        }

    }
}