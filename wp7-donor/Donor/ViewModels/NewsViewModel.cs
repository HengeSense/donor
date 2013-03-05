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
using System.Text.RegularExpressions;
using System.Runtime.Serialization;
using System.Xml;
using System.Xml.Linq;

namespace Donor.ViewModels
{
    public class NewsListViewModel: INotifyPropertyChanged
    {
        public NewsListViewModel()
        {
            this.Items = new ObservableCollection<NewsViewModel>();
        }

        public void LoadNewsParse()
        {
            if ((App.ViewModel.News.Items.Count() == 0) || (App.ViewModel.Settings.NewsUpdated.AddHours(1) < DateTime.Now))
            {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/classes/News?order=-createdTimestamp&limit=50", Method.GET);
                request.Parameters.Clear();
                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        //var bw = new BackgroundWorker();
                        //bw.DoWork += delegate
                        //{
                            try
                            {
                                ObservableCollection<NewsViewModel> newslist1 = new ObservableCollection<NewsViewModel>();
                                JObject o = JObject.Parse(response.Content.ToString());
                                newslist1 = JsonConvert.DeserializeObject<ObservableCollection<NewsViewModel>>(o["results"].ToString());                                

                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                {
                                    App.ViewModel.Settings.NewsUpdated = DateTime.Now;
                                    App.ViewModel.SaveSettingsToStorage();

                                    this.Items = new ObservableCollection<NewsViewModel>(newslist1);                                
                                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<NewsViewModel>>(App.ViewModel.News.Items, "news.xml");
                                });
                            }
                            catch { };
                        //};
                        //bw.RunWorkerAsync();
                    }
                    catch
                    {
                    };
                });
            };
            bw.RunWorkerAsync();
            };
        }

        public void LoadNews()
        {
            if ((App.ViewModel.News.Items.Count() == 0) || (App.ViewModel.Settings.NewsUpdated.AddHours(1) < DateTime.Now))
            {
                var bw = new BackgroundWorker();
                bw.DoWork += delegate
                {
                    var client = new RestClient("http://yadonor.ru");
                    var request = new RestRequest("ru/news_rss/", Method.GET);
                    request.Parameters.Clear();
                    //request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                    //request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                    client.ExecuteAsync(request, response =>
                    {
                        try
                        {
                            try
                            {
                                ObservableCollection<NewsViewModel> newslist1 = new ObservableCollection<NewsViewModel>();
                                //JObject o = JObject.Parse(response.Content.ToString());
                                //newslist1 = JsonConvert.DeserializeObject<ObservableCollection<NewsViewModel>>(o["results"].ToString());
                                try
                                {
                                    var xdoc = XDocument.Parse(response.Content.ToString());
                                    foreach (XElement item in xdoc.Descendants("item"))
                                    {
                                        var itemnews = new NewsViewModel();
                                        itemnews.Nid = 0;
                                        itemnews.Url = item.Element("guid").Value.ToString();
                                        itemnews.Title = item.Element("title").Value.ToString();
                                        itemnews.Body = item.Element("description").Value.ToString();
                                        itemnews.ObjectId = item.Element("guid").Value.ToString();
                                        itemnews.Created = item.Element("pubDate").Value.ToString();
                                        DateTime origin = new DateTime(1970, 1, 1, 0, 0, 0, 0);
                                        DateTime date = DateTime.Parse(item.Element("pubDate").Value.ToString());
                                        TimeSpan diff = date - origin;
                                        itemnews.CreatedTimestamp = (long)Math.Round(Math.Floor(diff.TotalSeconds));
                                        //itemnews.DateText = (string)item.Element("pubDate").Value.ToString();
                                        newslist1.Add(itemnews);
                                    };
                                }
                                catch
                                {
                                };

                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                {
                                    App.ViewModel.Settings.NewsUpdated = DateTime.Now;
                                    App.ViewModel.SaveSettingsToStorage();

                                    this.Items = new ObservableCollection<NewsViewModel>(newslist1);
                                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<NewsViewModel>>(App.ViewModel.News.Items, "news.xml");
                                });
                            }
                            catch { };
                        }
                        catch
                        {
                        };
                    });
                };
                bw.RunWorkerAsync();
            };
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
                               select news).Take(6);
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


    [DataContract]
    public class NewsViewModel
    {
        public NewsViewModel()
        {
        }

        /// <summary>
        /// news title
        /// </summary>
        private string _title;
        [DataMember] 
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

        /*[DataMember] 
        public string Description
        {
            get
            {
                return _body;
            }
            set
            {
                _body = value;
            }
        }*/

        private string _body;
        public string Body {
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

                pattern = @"\*.*\*";
                rgx = new Regex(pattern);
                items = rgx.Matches(_outbody);
                foreach (var item in items)
                {
                    string item1 = "<i>" + item.ToString().Trim('*') + "</i>";
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
        }

        private string _url;
        public string Url
        {
            get
            {
                if (this.Nid != 0)
                {
                    return "http://www.pdari-zhizn.ru/main/node/" + this.Nid.ToString();
                } else {
                    return _url;
                };
            }
            set {
                _url = value;
                //NotifyPropertyChanged("Url");
            }
        }
        public int Nid { get; set; }

        private string _sbody = "";
        public string ShortBody {
            private set { }
            get
            {
                if (_sbody == "")
                {
                    string sbody = this.Body;
                    HtmlAgilityPack.HtmlDocument htmlDoc = new HtmlAgilityPack.HtmlDocument();
                    htmlDoc.OptionFixNestedTags = true;
                    htmlDoc.LoadHtml(sbody);
                    var text = htmlDoc.DocumentNode.InnerText;
                    sbody = text.Trim();
                    try
                    {
                        _sbody = sbody.Substring(0, 60) + "...";
                    }
                    catch { _sbody = sbody+ "..."; };
                };
                return _sbody;
            }
        }

        private string _mbody = "";
        public string MediumBody
        {
            private set { }
            get
            {
                if (_mbody == "")
                {
                    string sbody = this.Body;
                    HtmlAgilityPack.HtmlDocument htmlDoc = new HtmlAgilityPack.HtmlDocument();
                    htmlDoc.OptionFixNestedTags = true;
                    htmlDoc.LoadHtml(sbody);
                    var text = htmlDoc.DocumentNode.InnerText;
                    sbody = text.Trim();
                    try
                    {
                        if (sbody.Length <= 800)
                        {
                            _mbody = sbody;
                        }
                        else
                        {
                            _mbody = sbody.Substring(0, 800) + "...";
                        }
                        
                    }
                    catch { _mbody = sbody; };
                };
                return _mbody;
            }
        }

        public string CreatedAtText
        {
            private set { }
            get
            {
                DateTime created1 = DateTime.Now;
                try
                {
                    created1 = DateTime.Parse(this.Created);
                }
                catch {  };
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
