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
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using Microsoft.Phone.Tasks;
using Microsoft.Phone.Net.NetworkInformation;



namespace Donor
{


    public class MainViewModel : INotifyPropertyChanged
    {
        public const string XParseApplicationId = "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu";
        public const string XParseRESTAPIKey = "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf";


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

            Qr = new QRViewModel();
            
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
        public QRViewModel Qr { get; set; }
        public bool IsSettings = false;

        public bool IsDataLoaded
        {
            get;
            set;
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
                        Title = "",
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
                            Title = "",
                            Count = App.ViewModel.Events.Items.Count(),
                            BackTitle = App.ViewModel.Events.NearestEventsAll().Date.ToShortDateString(),
                            BackContent = App.ViewModel.Events.NearestEventsAll().Title.ToString()
                        };
                    }
                    else
                    {
                        standardTile = new StandardTileData
                        {
                            Title = "",
                            Count = App.ViewModel.Events.Items.Count(),
                            BackContent = Donor.AppResources.NoEvents,
                        };
                    };
                };

                // hidden in current version
                //appTile.Update(standardTile);
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
            System.Threading.Thread.Sleep(400);

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
            try
            {
                IsolatedStorageHelper.SaveSerializableObject<DonorUser>(App.ViewModel.User, "user.xml");
            }
            catch
            {
            };
            App.ViewModel.SaveSettingsToStorage();
        }

        public void SaveSettingsToStorage()
        {
            try
            {
                IsolatedStorageHelper.SaveSerializableObject<SettingsViewModel>(App.ViewModel.Settings, "settings.xml");
            }
            catch { };
        }

        public void LoadSettingsFromStorage()
        {
            try
            {
                this.Settings = IsolatedStorageHelper.LoadSerializableObject<SettingsViewModel>("settings.xml");
                IsSettings = true;
            }
            catch
            {
                this.Settings = new SettingsViewModel();
                try
                {
                    IsolatedStorageHelper.SaveSerializableObject<SettingsViewModel>(this.Settings, "settings.xml");
                }
                catch { };
                //App.ViewModel.SaveSettingsToStorage();
                IsSettings = false;                
            };
        }

        public void LoadUserFromStorage()
        {
            if (this.Settings.Password == false)
            {
                try
                {
                    App.ViewModel.User = IsolatedStorageHelper.LoadSerializableObject<DonorUser>("user.xml");

                    bool hasNetworkConnection =
  NetworkInterface.NetworkInterfaceType != NetworkInterfaceType.None;

                    if ((App.ViewModel.User.objectId != "") && (!hasNetworkConnection))
                    {
                        App.ViewModel.User.IsLoggedIn = true;
                        App.ViewModel.OnUserEnter(EventArgs.Empty);
                    }
                    else {
                    App.ViewModel.User.IsLoggedIn = false;

                    var client = new RestClient("https://api.parse.com");
                    var request = new RestRequest("1/login?include=events&username=" + Uri.EscapeUriString(App.ViewModel.User.UserName.ToLower()) + "&password=" + Uri.EscapeUriString(App.ViewModel.User.Password), Method.GET);
                    request.Parameters.Clear();
                    request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                    request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                    client.ExecuteAsync(request, response =>
                    {
                        try
                        {
                            JObject o = JObject.Parse(response.Content.ToString());
                            if (o["error"] == null)
                            {
                                App.ViewModel.User = JsonConvert.DeserializeObject<DonorUser>(response.Content.ToString());
                                App.ViewModel.User.IsLoggedIn = true;
                                App.ViewModel.Events.WeekItemsUpdated();
                                App.ViewModel.OnUserEnter(EventArgs.Empty);

                                App.ViewModel.Events.LoadEventsParse();

                            }
                            else
                            {
                                App.ViewModel.User.IsLoggedIn = false;
                                App.ViewModel.OnUserEnter(EventArgs.Empty);
                            };
                        }
                        catch { };
                    });
                };
                }
                catch
                {
                    App.ViewModel.User.IsLoggedIn = false;
                    App.ViewModel.OnUserEnter(EventArgs.Empty);
                };
            }
            else
            {
                App.ViewModel.User.IsLoggedIn = false;
                App.ViewModel.OnUserEnter(EventArgs.Empty);
            };
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public delegate void UserEnterEventHandler(object sender, EventArgs e);
        public event UserEnterEventHandler UserEnter;
        public virtual void OnUserEnter(EventArgs e)
        {
            if (UserEnter != null)
                UserEnter(this, e);
        }

        /// <summary>
        /// Event, when data from parse and so on is loaded
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        public delegate void DataFLoadedEventHandler(object sender, EventArgs e);
        public event DataFLoadedEventHandler DataFLoaded;
        public virtual void OnDataFLoaded(EventArgs e)
        {
            if (DataFLoaded != null)
                DataFLoaded(this, e);
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

                        this.Events.UpdateItems();
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
                        
                        this.NotifyPropertyChanged("Events");

                        this.Events.UpdateItems();
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

                        if (this.IsSettings == false)
                        {
                            //(Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/ProfileLogin.xaml", UriKind.Relative));
                            
                        };
                    });
                };
            };
            bw.RunWorkerAsync();            
        }

        public void SendToShare(string title, string link, string description, int length)
        {
            try
            {
                int length2 = length;
                if (length2 > title.Length)
                {
                    length2 = title.Length - 1;
                }
                string _short_title = title.Substring(0, length2) + "...";

                int length3 = length;
                if (length3 > description.Length)
                {
                    length3 = description.Length - 1;
                }
                string _short = description.Substring(0, length3) + "...";

                if ((length2 + length3) < length)
                {
                    this.ShareLink(_short_title, link, _short);
                }
                else
                {
                    this.ShareLink(_short_title, link, "");
                };
            }
            catch
            {
            };
        }

        /// <summary>
        /// Share link method
        /// </summary>
        /// <param name="title"></param>
        /// <param name="link"></param>
        /// <param name="message"></param>
        public void ShareLink(string title, string link, string message)
        {
            if ((title != null) & (link != null))
            {
                ShareLinkTask shareLinkTask = new ShareLinkTask();
                shareLinkTask.Title = title;
                shareLinkTask.LinkUri = new Uri(link, UriKind.Absolute);
                shareLinkTask.Show();
            };
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