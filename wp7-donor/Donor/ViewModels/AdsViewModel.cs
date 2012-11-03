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

namespace Donor.ViewModels
{
    public class AdsListViewModel : INotifyPropertyChanged
    {
        public AdsListViewModel()
        {
        }

        public void LoadAds()
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Ads?order=-createdTimestamp", Method.GET);
            request.Parameters.Clear();
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            client.ExecuteAsync(request, response =>
            {
                try
                {
                    var bw = new BackgroundWorker();
                    bw.DoWork += delegate
                    {
                        ObservableCollection<AdsViewModel> adslist1 = new ObservableCollection<AdsViewModel>();
                        JObject o = JObject.Parse(response.Content.ToString());
                        adslist1 = JsonConvert.DeserializeObject<ObservableCollection<AdsViewModel>>(o["results"].ToString());

                        var sortedAds = (from ads in adslist1
                                         orderby ads.CreatedTimestamp descending
                                         select ads);
                        /*
                        foreach (var item in sortedAds)
                        {
                            App.ViewModel.Ads.Items.Add(item);
                        };*/

                        //save to isolated storage
                        

                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            //App.ViewModel.Ads.Items = new ObservableCollection<AdsViewModel>();
                            this.Items = new ObservableCollection<AdsViewModel>(sortedAds);
                        });

                        IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<AdsViewModel>>(App.ViewModel.Ads.Items, "ads.xml");
                    };
                    bw.RunWorkerAsync();
                }
                catch
                {
                };
                this.NotifyPropertyChanged("Items");
            });
        }

        public List<AdsViewModel> LoadStationAds(string objectid)
        {
            var aditems = (from ads in Items
                           where ads.Station_nid == objectid
                            orderby ads.CreatedAt descending
                            select ads).Take(10);
            List<AdsViewModel> outads = aditems.ToList();
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
                    NotifyPropertyChanged("Items");
                    NotifyPropertyChanged("NewItems");
                    NotifyPropertyChanged("SortedItems");
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

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (null != handler)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public void RaisePropertyChanged(string property)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(property));
            }
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
