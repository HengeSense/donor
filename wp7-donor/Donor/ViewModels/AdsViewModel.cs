﻿using System;
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
            var request = new RestRequest("1/classes/Ads", Method.GET);
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
                    App.ViewModel.Ads.Items = new ObservableCollection<AdsViewModel>();
                    foreach (var item in sortedAds)
                    {
                        App.ViewModel.Ads.Items.Add(item);
                    }

                    //save to isolated storage
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<AdsViewModel>>(App.ViewModel.Ads.Items, "ads.xml");
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

        public string ObjectId { get; set; }
        /*public string Title { get; set; }
        private string _body;
        public string Body
        {
            set
            {
                _body = value;
            }
            get
            {
                string _outbody = _body;

                string pattern = @"\*\*.*\*\*";
                Regex rgx = new Regex(pattern);
                var items = rgx.Matches(_outbody);
                foreach (var item in items)
                {
                    string item1 = "<br/><b>" + item.ToString().Trim('*') + "</b><br/>";
                    _outbody = _outbody.Replace(item.ToString(), item1);
                };

                pattern = @"\[([^]]*)\]\s*\(([^)]*)\)";
                rgx = new Regex(pattern);
                var items2 = rgx.Matches(_outbody);
                foreach (Match item in items2)
                {
                    string item1 = item.ToString();
                    _outbody = _outbody.Replace(item.ToString(), item.Groups[1].Value.ToString());
                };

                pattern = @"\[inline([^]]*)\]";
                rgx = new Regex(pattern);
                _outbody = rgx.Replace(_outbody, "");

                _outbody = _outbody.Replace("<!--break-->", "");

                return _outbody;
            }
        }*/
        public string Station_id { get; set; }
        public string Url { get; set; }
        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }

        public string CreatedAtText
        {
            private set { }
            get
            {
                DateTime created = DateTime.Parse(this.Created);
                return created.ToShortDateString();
            }
        }

        public Int64 CreatedTimestamp { get; set; }
        public string Created
        {
            get
            {
                return _created;
            }
            set
            {
                _created = value;
            }
        }
        private string _created = DateTime.Now.ToString();

        public string Station_nid { get; set; }
        public string Nid { get; set; }
    }
}
