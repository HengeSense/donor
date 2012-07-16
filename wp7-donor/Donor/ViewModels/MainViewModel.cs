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
using Microsoft.Phone.Shell;
using System.Linq;
using System.Globalization;
using Microsoft.Phone.Scheduler;


namespace Donor
{   
    public class MainViewModel : INotifyPropertyChanged
    {
        public const string APPLICATION_ID = "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu";
        public const string REST_API_KEY = "uNarhakSf1on8lJjrAVs1VWmPlG1D6ZJf9dO5QZY";


        public MainViewModel()
        {            
            this.Items = new ObservableCollection<ItemViewModel>();

            News = new NewsListViewModel();
            Events = new EventsListViewModel();
            Stations = new StationsLitViewModel();
            Ads = new AdsListViewModel();
            User = new DonorUser();
            Reviews = new ReviewsListViewModel();
            Contras = new ContraListViewModel();

            Settings = new SettingsViewModel();            
            
            this.LoadFromIsolatedStorage();
        }


        /// <summary>
        /// A collection for ItemViewModel objects.
        /// </summary>
        public ObservableCollection<ItemViewModel> Items { get; private set; }

        //PeriodicTask periodicTask;
        //string periodicTaskName = "PeriodicAgent";

        public ReviewsListViewModel Reviews { get; set; }
        public NewsListViewModel News { get; set; }
        public AdsListViewModel Ads { get; set; }
        public EventsListViewModel Events { get; set; }
        public StationsLitViewModel Stations { get; set; }
        public DonorUser User { get; set; }
        public ContraListViewModel Contras { get; set; }
        public SettingsViewModel Settings { get; set; }

        public bool IsDataLoaded
        {
            get;
            private set;
        }

        public void CreateApplicationTile(EventViewModel eventData)
        {
            var appTile = ShellTile.ActiveTiles.FirstOrDefault();

            if (appTile != null)
            {
                StandardTileData standardTile;
                if (eventData != null)
                {
                    standardTile = new StandardTileData
                    {
                        Title = "Доноры",
                        Count = App.ViewModel.Events.Items.Count(),
                        BackTitle = eventData.Date.ToShortDateString(),
                        BackContent = eventData.Title
                    };
                }
                else
                {
                    if (App.ViewModel.Events.NearestEventsAll() != null)
                    {
                        standardTile = new StandardTileData
                        {
                            Title = "Доноры",
                            Count = App.ViewModel.Events.Items.Count(),
                            BackTitle = App.ViewModel.Events.NearestEventsAll().Date.ToShortDateString(),
                            BackContent = App.ViewModel.Events.NearestEventsAll().Title.ToString()
                        };
                    }
                    else
                    {
                        standardTile = new StandardTileData
                        {
                            Title = "Доноры",
                            Count = App.ViewModel.Events.Items.Count(),
                            BackContent = "Нет событий",
                        };
                    };
                };

                appTile.Update(standardTile);
            }
        }

        /// <summary>
        /// Creates and adds a few ItemViewModel objects into the Items collection.
        /// </summary>
        public void LoadData()
        {
            var bw = new BackgroundWorker();
            
            bw.DoWork += delegate
            {
            System.Threading.Thread.Sleep(700);

                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    this.LoadUserFromStorage();

                    App.ViewModel.Events.LoadDonorsSaturdays();
                    App.ViewModel.Stations.LoadStations();
                    this.NotifyPropertyChanged("Events");
                });

                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    App.ViewModel.News.LoadNews();
                    App.ViewModel.Ads.LoadAds();
                    App.ViewModel.Contras.LoadContras();
                    this.NotifyPropertyChanged("News");

                    CreateApplicationTile(App.ViewModel.Events.NearestEvents());
                });


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
        }

        public void SaveSettingsToStorage()
        {
            IsolatedStorageHelper.SaveSerializableObject<SettingsViewModel>(App.ViewModel.Settings, "settings.xml");
        }
        public void LoadSettingsFromStorage()
        {
            try
            {
                this.Settings = IsolatedStorageHelper.LoadSerializableObject<SettingsViewModel>("settings.xml");
            }
            catch
            {
                this.Settings = new SettingsViewModel();
            };
        }

        public void LoadUserFromStorage()
        {
            if (this.Settings.Password == false)
            {
                try
                {
                    App.ViewModel.User = IsolatedStorageHelper.LoadSerializableObject<DonorUser>("user.xml");

                    var client = new RestClient("https://api.parse.com");
                    var request = new RestRequest("1/login", Method.GET);
                    request.Parameters.Clear();
                    string strJSONContent = "{\"username\":\"" + App.ViewModel.User.UserName + "\",\"password\":\"" + App.ViewModel.User.Password + "\"}";
                    request.AddHeader("X-Parse-Application-Id", APPLICATION_ID);
                    request.AddHeader("X-Parse-REST-API-Key", REST_API_KEY);

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

            this.LoadSettingsFromStorage();

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
                    ObservableCollection<AdsViewModel> adslist1 = new ObservableCollection<AdsViewModel>();
                    adslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<AdsViewModel>>("ads.xml");
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Ads.Items = adslist1;
                        this.NotifyPropertyChanged("Ads");
                    });
                }
                catch //(System.IO.FileNotFoundException)
                {
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Ads.Items = new ObservableCollection<AdsViewModel>();
                        this.NotifyPropertyChanged("Ads");
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

        private void RemoveAgent(string name)
        {
            try
            {
                ScheduledActionService.Remove(name);

            }
            catch (Exception)
            {
            }
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