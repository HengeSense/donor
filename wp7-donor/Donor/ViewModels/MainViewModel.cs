using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Collections.ObjectModel;
using Parse;
using Parse.Queries;
using Donor.ViewModels;
using MSPToolkit.Utilities;
using Newtonsoft.Json;
using System.Reflection;
using System.IO;
using System.Windows.Resources;
using System.Windows.Threading;
using Newtonsoft.Json.Linq;
using RestSharp;

namespace Donor
{   
    public class MainViewModel : INotifyPropertyChanged
    {
        public const string APPLICATION_ID = "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu";
        public const string REST_API_KEY = "uNarhakSf1on8lJjrAVs1VWmPlG1D6ZJf9dO5QZY";

        //public Driver Parse;

        public MainViewModel()
        {            
            this.Items = new ObservableCollection<ItemViewModel>();

            News = new NewsListViewModel();
            Events = new EventsListViewModel();
            Stations = new StationsLitViewModel();

            User = new DonorUser();
            
            this.LoadFromIsolatedStorage();
        }

        /// <summary>
        /// A collection for ItemViewModel objects.
        /// </summary>
        public ObservableCollection<ItemViewModel> Items { get; private set; }

        public NewsListViewModel News { get; set; }
        public EventsListViewModel Events { get; set; }
        public StationsLitViewModel Stations { get; set; }
        public DonorUser User { get; set; }

        public bool IsDataLoaded
        {
            get;
            private set;
        }

        /// <summary>
        /// Creates and adds a few ItemViewModel objects into the Items collection.
        /// </summary>
        public void LoadData()
        {
            var bw = new BackgroundWorker();
            
            bw.DoWork += delegate
            {
            System.Threading.Thread.Sleep(500);

                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    this.LoadUserFromStorage();

                    App.ViewModel.Events.LoadDonorsSaturdays();
                    App.ViewModel.Stations.LoadStations();
                    this.NotifyPropertyChanged("Events");
                });

            if (this.News.Items.Count == 0)
            {
                ObservableCollection<NewsViewModel> newslist1 = new ObservableCollection<NewsViewModel>();
                newslist1.Add(new NewsViewModel() { Title = "runtime one", Description = "Maecenas praesent accumsan bibendum", Id = "1", Date = DateTime.Parse("6/10/2012 12:00:00 AM") });
                newslist1.Add(new NewsViewModel() { Title = "runtime two", Description = "Dictumst eleifend facilisi faucibus", Id = "2", Date = DateTime.Parse("5/12/2012 12:00:00 AM") });
                newslist1.Add(new NewsViewModel() { Title = "runtime three", Description = "Habitant inceptos interdum lobortis", Id = "3", Date = DateTime.Parse("6/12/2012 12:00:00 AM") });

                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    this.News.Items = newslist1;
                    this.NotifyPropertyChanged("News");
                });
            };

            this.IsDataLoaded = true;
            };
            bw.RunWorkerAsync();  
        }

        /// <summary>
        /// Save data to isolated storage to use when there is no network and faster show data in app
        /// </summary>
        public void SaveToIsolatedStorage()
        {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
            try
            {
                if (this.Events.Items.Count > 0)
                {
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<EventViewModel>>(this.Events.Items, "events.xml");
                };
            }
            catch
            {
            };

            try
            {
                if (this.Stations.Items.Count > 0)
                {
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<StationViewModel>>(this.Stations.Items, "stations.xml");
                };
            }
            catch
            {
            };

            try
            {
                if (this.News.Items.Count > 0)
                {
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<NewsViewModel>>(this.News.Items, "news.xml");
                };
            }
            catch
            {
            };
            };
            bw.RunWorkerAsync();  
        }

        public void SaveUserToStorage()
        {
            IsolatedStorageHelper.SaveSerializableObject<DonorUser>(App.ViewModel.User, "user.xml");
            //IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<EventViewModel>>("events.xml");
        }

        public void LoadUserFromStorage()
        {
            try
            {
                App.ViewModel.User = IsolatedStorageHelper.LoadSerializableObject<DonorUser>("user.xml");

                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/login", Method.GET);
                request.Parameters.Clear();
                string strJSONContent = "{\"username\":\"" + App.ViewModel.User.UserName + "\",\"password\":\"" + App.ViewModel.User.Password + "\"}";
                request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
                request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");

                request.AddParameter("username", App.ViewModel.User.UserName.ToLower());
                request.AddParameter("password", App.ViewModel.User.Password);

                client.ExecuteAsync(request, response =>
                {
                    JObject o = JObject.Parse(response.Content.ToString());
                    if (o["error"] == null)
                    {
                        App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                        App.ViewModel.User.IsLoggedIn = true;
                        App.ViewModel.OnUserEnter(EventArgs.Empty);
                    }
                    else
                    {
                        //MessageBox.Show("Ошибка входа: " + o["error"].ToString());
                        App.ViewModel.User.IsLoggedIn = false;
                    };
                });
            }
            catch
            {
            };
        }

        public delegate void UserEnterEventHandler(object sender, EventArgs e);
        public event UserEnterEventHandler UserEnter;
        protected virtual void OnUserEnter(EventArgs e)
        {
            if (UserEnter != null)
                UserEnter(this, e);
        }

        /// <summary>
        /// 
        /// </summary>
        public void LoadFromIsolatedStorage()
        {

            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {

                try
                {
                    ObservableCollection<EventViewModel> eventslist1 = new ObservableCollection<EventViewModel>();
                    eventslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<EventViewModel>>("events.xml");
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Events.Items = eventslist1;
                        this.NotifyPropertyChanged("Events");
                    });
                }
                catch
                {
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Events.Items = new ObservableCollection<EventViewModel>();

                        StreamResourceInfo info = Application.GetResourceStream(new Uri("/Donor;component/holidays.json", UriKind.Relative));
                        StreamReader reader = new StreamReader(info.Stream, System.Text.Encoding.Unicode);
                        string json = "";
                        json = reader.ReadToEnd();
                        ObservableCollection<EventViewModel> eventslist1 = new ObservableCollection<EventViewModel>();
                        eventslist1 = JsonConvert.DeserializeObject<ObservableCollection<EventViewModel>>(json);

                            this.Events.Items = eventslist1;
                            //App.ViewModel.Events.LoadDonorsSaturdays();
                        
                        this.NotifyPropertyChanged("Events");
                    });
                }
                try
                {
                    ObservableCollection<NewsViewModel> newslist1 = new ObservableCollection<NewsViewModel>();
                    newslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<NewsViewModel>>("news.xml");
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.News.Items = newslist1;
                        this.NotifyPropertyChanged("News");
                    });
                }
                catch //(System.IO.FileNotFoundException)
                {                    
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.News.Items = new ObservableCollection<NewsViewModel>();
                        this.NotifyPropertyChanged("News");
                    });
                };

                try
                {
                    ObservableCollection<StationViewModel> stationslist1 = new ObservableCollection<StationViewModel>();
                    stationslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<StationViewModel>>("stations.xml");
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Stations.Items = stationslist1;
                        this.NotifyPropertyChanged("Stations");
                    });
                }
                catch //(System.IO.FileNotFoundException)
                {
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Stations.Items = new ObservableCollection<StationViewModel>();
                        this.NotifyPropertyChanged("Stations");
                    });
                };

            };
            bw.RunWorkerAsync();
            
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (null != handler)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}