using System;
using System.Net;
using System.Windows;
using System.Windows.Input;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.ComponentModel;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Linq;
using System.Text.RegularExpressions;
using GalaSoft.MvvmLight;
using DonorAppW8.ViewModel;
using Parse;
using DonorAppW8.DataModel;

namespace DonorAppW8.ViewModels
{
    public class AdsListViewModel: ViewModelBase
    {
        public AdsListViewModel()
        {
            _items = new ObservableCollection<AdsViewModel>();
        }

        private AdsViewModel _currentAd = null;
        public AdsViewModel CurrentAd
        {
            get
            {
                return _currentAd;
            }
            set
            {
                _currentAd = value;
                RaisePropertyChanged("CurrentAd");
            }
        }

        public async void LoadAds()
        {
            ParseQuery<ParseObject> query = ParseObject.GetQuery("Ads");
            query = query.Limit(30);
            IEnumerable<ParseObject> results = await query.FindAsync();
            foreach (var advert in results)
            {
                AdsViewModel aditem =  new AdsViewModel();
                aditem.Title = advert.Get<string>("title");
                aditem.Body = advert.Get<string>("body");
                aditem.Url = advert.Get<string>("url");
                aditem.CreatedTimestamp = advert.Get<long>("createdTimestamp");
                aditem.ObjectId = advert.ObjectId;
                aditem.UniqueId = advert.ObjectId;

                this.Items.Add(aditem);
            };
            RssDataGroup adgroup = new RssDataGroup();
            adgroup.Title = "Объявления";
            adgroup.UniqueId = "Ads";
            adgroup.Order = 2;
            
            adgroup.Items = new ObservableCollection<object>(this.Items);
            ViewModelLocator.MainStatic.Groups.Add(adgroup);
            ViewModelLocator.MainStatic.GroupUpdated();
            RaisePropertyChanged("Items");
            /*if ((ViewModelLocator.MainStatic.Ads.Items.Count() == 0) || (ViewModelLocator.MainStatic.Settings.AdsUpdated.AddHours(1) < DateTime.Now))
            {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Ads?order=-createdTimestamp&limit=50", Method.GET);
            request.Parameters.Clear();
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            client.ExecuteAsync(request, response =>
            {
                try
                {
                        ObservableCollection<AdsViewModel> adslist1 = new ObservableCollection<AdsViewModel>();
                        JObject o = JObject.Parse(response.Content.ToString());
                        adslist1 = JsonConvert.DeserializeObject<ObservableCollection<AdsViewModel>>(o["results"].ToString());

                        var sortedAds = (from ads in adslist1
                                         orderby ads.CreatedTimestamp descending
                                         select ads);
                        

                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            ViewModelLocator.MainStatic.Settings.AdsUpdated = DateTime.Now;
                            ViewModelLocator.MainStatic.SaveSettingsToStorage();

                            this.Items = new ObservableCollection<AdsViewModel>(sortedAds);
                            IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<AdsViewModel>>(ViewModelLocator.MainStatic.Ads.Items, "ads.xml");
                        });                      
                }
                catch
                {
                };
                Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    RaisePropertyChanged("Items");
                });  
            });
            };
            bw.RunWorkerAsync();
            };*/
        }

        public List<AdsViewModel> LoadStationAds(string objectid)
        {
            List<AdsViewModel> outads = new List<AdsViewModel>();
            try
            {
                var aditems = (from ads in Items
                               where ads.Station_nid.ToString() == objectid.ToString() 
                               orderby ads.CreatedAt descending
                               select ads).Take(10);
                outads = aditems.ToList();
            }
            catch { };
            return outads;
        }

        private ObservableCollection<AdsViewModel> _items;
        public ObservableCollection<AdsViewModel> Items
        {
            get {
                return _items; 
            }
            set
            {
                if (_items != value)
                {
                    _items = value;
                    RaisePropertyChanged("Items");
                    RaisePropertyChanged("NewItems");
                    RaisePropertyChanged("SortedItems");
                };
            }
        }

        public List<AdsViewModel> SortedItems
        {
            private set
            {
            }
            get
            {
                return (from ads in Items
                       orderby ads.CreatedTimestamp descending
                       select ads).ToList();
            }
        }

        public List<AdsViewModel> NewItems
        {
            get
            {
                var newitems = (from ads in Items
                                orderby ads.CreatedAt descending
                                select ads).Take(10);
                List<AdsViewModel> outnews = newitems.ToList();
                return outnews;
            }
            private set { }
        }
    }

    public class AdsViewModel : NewsViewModel
    {
        public AdsViewModel()
        {
        }

        public string Station_id { get; set; }
        public string CreatedAt { get; set; }

        private string _created = DateTime.Now.ToString();

        public string Station_nid { get; set; }
    }
}
