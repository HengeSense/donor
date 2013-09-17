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
using GalaSoft.MvvmLight;
using System.Threading.Tasks;
using ButtonLibrary;



namespace Donor
{


    public class MainViewModel : ViewModelBase
    {
        public const string XParseApplicationId = "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu";
        public const string XParseRESTAPIKey = "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf";


        public MainViewModel()
        {            
            News = new NewsListViewModel();
            Events = new EventsListViewModel();
            Stations = new StationsListViewModel();
            Ads = new AdsListViewModel();
            User = new DonorUser();
            Reviews = new ReviewsListViewModel();
            Contras = new ContraListViewModel();

            Settings = new SettingsViewModel();

            Qr = new QRViewModel();           

            this.IsDataStartLoaded = false;

            this.FbId = "";
            this.FbToken = "";
        }


        //PeriodicTask periodicTask;
        //string periodicTaskName = "PeriodicAgent";

        private bool _eventChanging = false;
        public bool EventChanging
        {
            get
            {
                return _eventChanging;
            }
            set
            {
                _eventChanging = value;
                RaisePropertyChanged("EventChanging");
            }
        }

        private bool _loading = false;
        public bool Loading
        {
            get
            {
                return _loading;
            }
            set
            {
                _loading = value;
                RaisePropertyChanged("Loading");
            }
        }

        public ReviewsListViewModel Reviews { get; set; }
        public NewsListViewModel News { get; set; }
        public AdsListViewModel Ads { get; set; }
        public EventsListViewModel Events { get; set; }
        public StationsListViewModel Stations { get; set; }
        public DonorUser User { get; set; }
        public ContraListViewModel Contras { get; set; }
        public SettingsViewModel Settings { get; set; }
        public QRViewModel Qr { get; set; }
        public bool IsSettings = false;

        public string FbId = "";
        public string FbToken = "";

        public bool IsDataLoaded
        {
            get;
            set;
        }

        public bool IsDataStartLoaded
        {
            get;
            set;
        }

        /// <summary>
        /// Обновляем ApplicationTile - выводим колическтво событий и ближайшее событие в будущем
        /// </summary>
        /// <param name="eventData"></param>
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
                        Count = ViewModelLocator.MainStatic.Events.UserItems.Where(c => ((c.Type=="0") || (c.Type=="1")) && (c.Date>DateTime.Now)).Count(),
                        BackTitle = eventData.Date.ToShortDateString(),
                        BackContent = eventData.Title
                    };
                }
                else
                {
                    standardTile = new StandardTileData
                    {
                        Title = "",
                        Count = ViewModelLocator.MainStatic.Events.UserItems.Where(c => (c.Type == "0") || (c.Type == "1")).Count()
                    };
                };

                appTile.Update(standardTile);
            }
        }

        public PizzaButtonControl HintButton = new PizzaButtonControl();

        /// <summary>
        /// Creates and adds a few ItemViewModel objects into the Items collection.
        /// </summary>
        public async Task<bool> LoadData()
        {
            await this.LoadFromIsolatedStorage();

            var bw = new BackgroundWorker();
            this.IsDataStartLoaded = true;

            await ViewModelLocator.MainStatic.News.LoadNews();
            ViewModelLocator.MainStatic.Ads.LoadAds();
            await ViewModelLocator.MainStatic.Contras.LoadContras();
            await ViewModelLocator.MainStatic.Stations.LoadStations();

            HintButton.IsAppBarEnabled = true;
            HintButton.Open();
            HintButton.IsAppBarEnabled = true;

            bw.DoWork += delegate
            {
                //System.Threading.Thread.Sleep(400);                
                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    this.LoadUserFromStorage();
                    ViewModelLocator.MainStatic.Events.LoadDonorsSaturdays();                   
                    RaisePropertyChanged("Events");
                });               

                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    CreateApplicationTile(ViewModelLocator.MainStatic.Events.NearestEvents());
                });            
            };
            bw.RunWorkerAsync();
            return true;
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
                IsolatedStorageHelper.SaveSerializableObject<DonorUser>(ViewModelLocator.MainStatic.User, "user.xml");
            }
            catch
            {
            };
            ViewModelLocator.MainStatic.SaveSettingsToStorage();
        }

        public void SaveSettingsToStorage()
        {
            try
            {
                IsolatedStorageHelper.SaveSerializableObject<SettingsViewModel>(ViewModelLocator.MainStatic.Settings, "settings.xml");
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
                //ViewModelLocator.MainStatic.SaveSettingsToStorage();
                IsSettings = false;                
            };
        }

        public void LoadUserFromStorage()
        {
            if (this.Settings.Password == false)
            {
                try
                {
                    ViewModelLocator.MainStatic.User = IsolatedStorageHelper.LoadSerializableObject<DonorUser>("user.xml");

                    bool hasNetworkConnection =
  NetworkInterface.NetworkInterfaceType != NetworkInterfaceType.None;

                    if ((ViewModelLocator.MainStatic.User.objectId != "") && (!hasNetworkConnection))
                    {
                        ViewModelLocator.MainStatic.User.IsLoggedIn = true;
                        ViewModelLocator.MainStatic.OnUserEnter(EventArgs.Empty);
                    }
                    else {
                        ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                        if (ViewModelLocator.MainStatic.User.Password != "" && ViewModelLocator.MainStatic.User.Password != null)
                        {
                            ViewModelLocator.MainStatic.User.LoginAction(null);
                        }
                        else
                        {
                            if ((ViewModelLocator.MainStatic.User.FacebookId != "") && (ViewModelLocator.MainStatic.User.FacebookToken != "") && (ViewModelLocator.MainStatic.User.FacebookToken != null) && (ViewModelLocator.MainStatic.User.FacebookId != null))
                            {
                                ViewModelLocator.MainStatic.User.FacebookLogin(ViewModelLocator.MainStatic.User.FacebookId, ViewModelLocator.MainStatic.User.FacebookToken);
                            };
                        };
                };
                }
                catch
                {
                    ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                    ViewModelLocator.MainStatic.OnUserEnter(EventArgs.Empty);
                };
            }
            else
            {
                ViewModelLocator.MainStatic.User.IsLoggedIn = false;
                ViewModelLocator.MainStatic.OnUserEnter(EventArgs.Empty);
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


        public delegate void EventsChangedCalendarEventHandler(object sender, EventArgs e);
        public event EventsChangedCalendarEventHandler EventsChangedCalendar;
        public virtual void OnEventsChangedCalendar(EventArgs e)
        {
            if (EventsChangedCalendar != null)
                EventsChangedCalendar(this, e);
        }

        /// <summary>
        /// 
        /// </summary>
        public async Task<bool> LoadFromIsolatedStorage()
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
                        RaisePropertyChanged("Events");

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

                            RaisePropertyChanged("Events");

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
                        RaisePropertyChanged("News");
                        RaisePropertyChanged("NewItems"); 
                    });
                }
                catch //(System.IO.FileNotFoundException)
                {                    
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.News.Items = new ObservableCollection<NewsViewModel>();
                        RaisePropertyChanged("News");
                    });
                };

                try
                {
                    ObservableCollection<AdsViewModel> adslist1 = new ObservableCollection<AdsViewModel>();
                    adslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<AdsViewModel>>("ads.xml");
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Ads.Items = adslist1;
                        RaisePropertyChanged("Ads");
                    });
                }
                catch //(System.IO.FileNotFoundException)
                {
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        this.Ads.Items = new ObservableCollection<AdsViewModel>();
                        RaisePropertyChanged("Ads");
                    });
                };

            };
            bw.RunWorkerAsync();
            return true;
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
    }
}