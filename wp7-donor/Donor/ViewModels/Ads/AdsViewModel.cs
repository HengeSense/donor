using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Collections.ObjectModel;
using System.Collections.Generic;
using System.ComponentModel;
using RestSharp;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using MSPToolkit.Utilities;
using System.Linq;
using System.Text.RegularExpressions;
using GalaSoft.MvvmLight;
using System.Net.Http;

namespace Donor.ViewModels
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
            if ((ViewModelLocator.MainStatic.Ads.Items.Count() == 0) || (ViewModelLocator.MainStatic.Settings.AdsUpdated.AddHours(1) < DateTime.Now))
            {

                HttpClient http = new System.Net.Http.HttpClient();
                http.DefaultRequestHeaders.Add("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                http.DefaultRequestHeaders.Add("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                HttpResponseMessage httpresponse =
                    await http.GetAsync("https://api.parse.com/1/classes/Ads?order=-createdTimestamp&limit=50");
                string output = await httpresponse.Content.ReadAsStringAsync();

                try
                {
                        ObservableCollection<AdsViewModel> adslist1 = new ObservableCollection<AdsViewModel>();
                        JObject o = JObject.Parse(output); //response.Content.ToString());
                        adslist1 = JsonConvert.DeserializeObject<ObservableCollection<AdsViewModel>>(o["results"].ToString());

                        var sortedAds = (from ads in adslist1
                                         orderby ads.CreatedTimestamp descending
                                         select ads);

                            ViewModelLocator.MainStatic.Settings.AdsUpdated = DateTime.Now;
                            ViewModelLocator.MainStatic.SaveSettingsToStorage();

                            this.Items = new ObservableCollection<AdsViewModel>(sortedAds);
                            IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<AdsViewModel>>(ViewModelLocator.MainStatic.Ads.Items, "ads.xml");                   
                }
                catch
                {
                };
                RaisePropertyChanged("Items");
            };
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
