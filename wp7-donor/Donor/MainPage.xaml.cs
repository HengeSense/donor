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
using Microsoft.Phone.Net.NetworkInformation;

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

            bool hasNetworkConnection =
              NetworkInterface.NetworkInterfaceType != NetworkInterfaceType.None;
            if (hasNetworkConnection) {
            this.progressOverlay.Visibility = Visibility.Visible;
            this.progressOverlay.IsEnabled = true;
            } else {
                /// DWP-95
                //MessageBox.Show("Не удается выполнить выход. Проверьте подключение к интернет-сети");
            };
        }

        // Load data for the ViewModel Items
        private void MainPage_Loaded(object sender, RoutedEventArgs e)
        {
            try {
                if (!App.ViewModel.IsDataLoaded)
                {
                    App.ViewModel.LoadData();
                }

                if (App.ViewModel.User.IsLoggedIn == true)
                {
                    this.LoginForm.Visibility = Visibility.Collapsed;
                    this.UserProfile.Visibility = Visibility.Visible;
                    this.GivedBlood.Text = App.ViewModel.User.GivedBlood.ToString();

                    this.EventsChanged(this, EventArgs.Empty);
                }
                else
                {
                    this.LoginForm.Visibility = Visibility.Visible;
                    this.UserProfile.Visibility = Visibility.Collapsed;
                };

                this.email.Text = "";
                this.password.Password = "";

                bool hasNetworkConnection =
      NetworkInterface.NetworkInterfaceType != NetworkInterfaceType.None;
                if (hasNetworkConnection)
                {
                }
                else
                {
                    MessageBox.Show("Не удается выполнить вход. Убедитесь, что режим \"в самолете\" выключен и имеется сетевое соединение.");
                };
            } catch {};
        }

        private void TextBlock_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
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
            OpenEvent(sender);
        }

        private void CalendarMenuText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            if (App.ViewModel.User.IsLoggedIn)
            {
                NavigationService.Navigate(new Uri("/CalendarYearPage.xaml", UriKind.Relative));
            }
            else
            {
                MessageBox.Show("Пожалуйста войдите, чтобы иметь возможность работать с календарем событий.");
                
            };
        }

        private void EventsList_Loaded(object sender, RoutedEventArgs e)
        {
        }

        private void EventsChanged(object sender, EventArgs e)
        {
            if (App.ViewModel.User.IsLoggedIn)
            {
                this.EventsList.ItemsSource = App.ViewModel.Events.WeekItems;
            }
            else
            {
                this.EventsList.ItemsSource = null;
            };
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
                        this.ProfileBloodGroup.Text = App.ViewModel.User.OutBloodDataString.ToString();
                        this.GivedBlood.Text = App.ViewModel.User.GivedBlood.ToString();
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

            App.ViewModel.Events.UpdateItems();
        }

        private void DataFLoaded(object sender, EventArgs e)
        {
            if (this.NavigationContext.QueryString.ContainsKey("eventid"))
            {
                try
                {
                    string _eventid = this.NavigationContext.QueryString["eventid"];
                    // проверяем, есть ли это событие среди событие среди событий пользователя
                    if (App.ViewModel.Events.UserItems.FirstOrDefault(c => c.Id == _eventid) !=null)
                    {
                    NavigationService.Navigate(new Uri("/EventPage.xaml?id=" + _eventid, UriKind.Relative));
                    };
                }
                catch
                {
                };
            };

            if (this.NavigationContext.QueryString.ContainsKey("editeventid"))
            {
                try
                {
                    string _editeventid = this.NavigationContext.QueryString["editeventid"];
                    NavigationService.Navigate(new Uri("/EditEventPage.xaml?id=" + _editeventid, UriKind.Relative));
                }
                catch
                {
                };
            };

            this.progressOverlay.Visibility = Visibility.Collapsed;
            this.progressOverlay.IsEnabled = false;

            App.ViewModel.Events.UpdateItems();
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                App.ViewModel.UserEnter += new MainViewModel.UserEnterEventHandler(this.UserLoaded);
                App.ViewModel.Events.EventsChanged += new EventsListViewModel.EventsChangedEventHandler(this.EventsChanged);
                App.ViewModel.DataFLoaded += new MainViewModel.DataFLoadedEventHandler(this.DataFLoaded); 
            }
            catch { };

            try
            {
                if (App.ViewModel.User.IsLoggedIn == true)
                {
                    try
                    {
                        this.ProfileName.Text = App.ViewModel.User.Name.ToString();
                        this.ProfileSex.Text = App.ViewModel.User.OutSex.ToString();
                        this.ProfileBloodGroup.Text = App.ViewModel.User.OutBloodDataString.ToString();
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

            App.ViewModel.Events.UpdateItems();
        }

        private void TextBlock_Tap_1(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/ProfileLogin.xaml", UriKind.Relative));
        }



        private void Login_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/login?username=" + Uri.EscapeUriString(this.email.Text.ToString().ToLower()) + "&password=" + Uri.EscapeUriString(this.password.Password), Method.GET);
                request.Parameters.Clear();
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                App.ViewModel.User.IsLoggedIn = false;

                this.LoginLoadingBar.IsIndeterminate = true;

                client.ExecuteAsync(request, response =>
                {
                    this.LoginLoadingBar.IsIndeterminate = false;
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                            App.ViewModel.User.IsLoggedIn = true;

                            App.ViewModel.User.Password = this.password.Password;
                            App.ViewModel.SaveUserToStorage();

                            this.LoginForm.Visibility = Visibility.Collapsed;
                            this.UserProfile.Visibility = Visibility.Visible;

                            App.ViewModel.Events.WeekItemsUpdated();

                            App.ViewModel.Events.LoadEventsParse();

                            App.ViewModel.OnUserEnter(EventArgs.Empty);

                            try
                            {
                                this.ProfileName.Text = App.ViewModel.User.Name.ToString();
                                this.ProfileSex.Text = App.ViewModel.User.OutSex.ToString();
                                this.ProfileBloodGroup.Text = App.ViewModel.User.OutBloodDataString.ToString();
                                this.GivedBlood.Text = App.ViewModel.User.GivedBlood.ToString();
                            }
                            catch { };
                        }
                        else
                        {
                            App.ViewModel.User.IsLoggedIn = false;

                            this.LoginForm.Visibility = Visibility.Visible;
                            this.UserProfile.Visibility = Visibility.Collapsed;

                            MessageBox.Show("Указаны некорректные данные.");
                        };
                    }
                    catch { };
                });
            }
            catch { };
        }

        private void adsMenuText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/AdsList.xaml", UriKind.Relative));
        }

        private void HelpMenuText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            NavigationService.Navigate(new Uri("/HelpPage.xaml", UriKind.Relative));
        }

        private void EditProfile_Click(object sender, System.Windows.RoutedEventArgs e)
        {
        	NavigationService.Navigate(new Uri("/ProfileLogin.xaml?task=edit", UriKind.Relative));
        }

        private void AddEvent_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (App.ViewModel.User.IsLoggedIn)
                {
                    NavigationService.Navigate(new Uri("/EventEditPage.xaml", UriKind.Relative));
                }
                else
                {
                    MessageBox.Show("Пожалуйста войдите, чтобы иметь возможность работать с календарем событий.");
                };
            }
            catch { };
        }

        private void Register_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/ProfileLogin.xaml?task=register&email=" + this.email.Text.ToString() + "&password=" + this.password.Password.ToString(), UriKind.Relative));
            }
            catch { };
        }

        private void EventsList_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            OpenEvent(sender);
        }

        private void OpenEvent(object sender) {
            try
            {
                string id = ((sender as ListBox).SelectedItem as EventViewModel).Id;
                if (((sender as ListBox).SelectedItem as EventViewModel).Type == "PossibleBloodGive")
                {
                    NavigationService.Navigate(new Uri("/EventEditPage.xaml?id=" + id, UriKind.Relative));
                }
                else
                {
                    NavigationService.Navigate(new Uri("/EventPage.xaml?id=" + id, UriKind.Relative));
                };
            }
            catch
            {
            };
        }

        private void NewsList_Tap(object sender, System.Windows.Input.GestureEventArgs e)
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
    }
}