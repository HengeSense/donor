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
using System.Linq;
using System.ComponentModel;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using RestSharp;
using Newtonsoft.Json;
using MSPToolkit.Utilities;

namespace Donor.ViewModels
{
    public class NewsListViewModel: INotifyPropertyChanged
    {
        public NewsListViewModel()
        {
            this.Items = new ObservableCollection<NewsViewModel>();
        }

        public void LoadNews()
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/News", Method.GET);
            request.Parameters.Clear();
            request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
            request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");
            string strJSONContent = "limit=100\norder=-createdTimestamp";
            request.AddBody(strJSONContent);

            client.ExecuteAsync(request, response =>
            {
                try
                {
                    ObservableCollection<NewsViewModel> newslist1 = new ObservableCollection<NewsViewModel>();
                    JObject o = JObject.Parse(response.Content.ToString());
                    newslist1 = JsonConvert.DeserializeObject<ObservableCollection<NewsViewModel>>(o["results"].ToString());
                    var newslist2 = (from news in newslist1
                               orderby news.CreatedTimestamp descending
                               select news);
                    this.Items = new ObservableCollection<NewsViewModel>(newslist2);
                    //save to isolated storage
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<NewsViewModel>>(App.ViewModel.News.Items, "news.xml");
                }
                catch
                {
                };
                this.NotifyPropertyChanged("Items");
            });
        }

        private ObservableCollection<NewsViewModel> _items;
        public ObservableCollection<NewsViewModel> Items { 
            get { return _items; } 
            set { 
                if (_items != value) {
                    _items = value;
                    NotifyPropertyChanged("Items");
                    NotifyPropertyChanged("NewItems");
                }; 
            } }
        public List<NewsViewModel> NewItems { 
            get 
            {
                var newitems = (from news in this.Items
                               orderby news.CreatedTimestamp descending
                               select news).Take(10);
                List<NewsViewModel> outnews = newitems.ToList();
                return outnews;
            }
            private set { } }

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


    public class NewsViewModel
    {
        public NewsViewModel()
        {
        }

        /// <summary>
        /// news title
        /// </summary>
        private string _title;
        public string Title
        {
            get
            {
                return _title;
            }
            set 
            {
                _title = value;
            }
        }

        public string ObjectId { get; set; }
        public string Body { get; set; }
        public string Url { get; set; }

        public string ShortBody {
            private set { }
            get
            {
                string sbody = this.Body;
                return sbody;
            }
        }

        public string CreatedAtText
        {
            private set { }
            get
            {
                DateTime created1 = DateTime.Parse(this.Created);
                return created1.ToShortDateString();
            }
        }

        public Int64 CreatedTimestamp { get; set; }

        public string UpdatedAt { get; set; }
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

        public DateTime Date { get; set; }
    }
}
