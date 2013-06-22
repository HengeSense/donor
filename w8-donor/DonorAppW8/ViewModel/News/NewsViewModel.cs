using System;
using System.Net;
using System.Windows;
using System.Windows.Input;
using System.Collections.ObjectModel;
using System.Linq;
using System.ComponentModel;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;
using Newtonsoft.Json;
using System.Text.RegularExpressions;
using System.Runtime.Serialization;
using System.Xml;
using System.Xml.Linq;
using GalaSoft.MvvmLight;
using Parse;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Media.Imaging;
using Windows.Web.Syndication;
using System.Threading.Tasks;
using Windows.Storage;
using DonorAppW8.DataModel;
using DonorAppW8.ViewModel;
using System.IO;


namespace DonorAppW8.ViewModels
{
    public class NewsListViewModel: ViewModelBase
    {
        public NewsListViewModel()
        {
            this.Items = new ObservableCollection<NewsViewModel>();
        }

        public async Task<bool> AddGroupForFeedAsync(string feedUrl, string ID = "1", string titleRss = "")
        {
            string clearedContent = String.Empty;

            if (ViewModelLocator.MainStatic.Groups.FirstOrDefault(c => c.UniqueId == ID) != null) return false;

            var feed = await new SyndicationClient().RetrieveFeedAsync(new Uri(feedUrl));
            //var localFolder = await ApplicationData.Current.LocalFolder.CreateFolderAsync("Data", CreationCollisionOption.OpenIfExists);
            //получаем/перезаписываем файл с именем "ID".rss
            //var fileToSave = await localFolder.CreateFileAsync(ID + ".rss", CreationCollisionOption.ReplaceExisting);

            //сохраняем фид в этот файл
            //await feed.GetXmlDocument(SyndicationFormat.Rss20).SaveToFileAsync(fileToSave);

            var feedGroup = new RssDataGroup();
            feedGroup.UniqueId = ID;
            feedGroup.Title = titleRss;
            //feedGroup.subtitle = feed.Subtitle != null ? feed.Subtitle.Text : null;
            //feedGroup.imagePath = feed.ImageUri != null ? feed.ImageUri.ToString() : null;

            foreach (var i in feed.Items)
            {
                string imagePath = null;
                try
                {
                    imagePath = GetImageFromPostContents(i); ;
                }
                catch { };

                if (i.Summary != null)
                    clearedContent = Windows.Data.Html.HtmlUtilities.ConvertToText(i.Summary.Text);
                else
                    if (i.Content != null)
                        clearedContent = Windows.Data.Html.HtmlUtilities.ConvertToText(i.Content.Text);

                /*if (imagePath != null && feedGroup.Image == null)
                    feedGroup.SetImage(imagePath);*/

                if (imagePath == null) imagePath = "ms-appx:///Assets/DarkGray.png";

                try
                {
                    NewsViewModel news = new NewsViewModel();
                    news.ObjectId = i.Id;
                    news.UniqueId = i.Id;
                    news.Title = i.Title.Text;
                    news.Body = clearedContent;
                    news.ImagePath = imagePath;
                    news.Url = i.Id.ToString();
                    this.Items.Add(news);
                    /*new RssDataItem(
                        uniqueId: i.Id, title: i.Title.Text, subtitle: null, imagePath: imagePath,
                        description: null, content: clearedContent, @group: feedGroup))*/
                    feedGroup.Items.Add(news);
                }
                catch { };
            }

            ViewModelLocator.MainStatic.Groups.Remove(ViewModelLocator.MainStatic.Groups.FirstOrDefault(c => c.UniqueId == feedGroup.UniqueId));
            ViewModelLocator.MainStatic.Groups.Add(feedGroup);
            //AllGroups = SortItems();
            return true;
        }

        private static string GetImageFromPostContents(SyndicationItem item)
        {
            string text2search = "";

            if (item.Content != null) text2search += item.Content.Text;
            if (item.Summary != null) text2search += item.Summary.Text;

            return Regex.Matches(text2search,
                    @"(?<=<img\s+[^>]*?src=(?<q>['""]))(?<url>.+?)(?=\k<q>)",
                    RegexOptions.IgnoreCase)
                .Cast<Match>()
                .Where(m =>
                {
                    Uri url;
                    if (Uri.TryCreate(m.Groups[0].Value, UriKind.Absolute, out url))
                    {
                        string ext = Path.GetExtension(url.AbsolutePath).ToLower();
                        if (ext == ".png" || ext == ".jpg" || ext == ".bmp") return true;
                    }
                    return false;
                })
                .Select(m => m.Groups[0].Value)
                .FirstOrDefault();
        }

        private NewsViewModel _currentNews = null;
        public NewsViewModel CurrentNews
        {
            set
            {
                _currentNews = value;
                RaisePropertyChanged("CurrentNews");
            }
            get
            {
                return _currentNews;
            }
        }

        public async void LoadNews()
        {
            await AddGroupForFeedAsync("http://yadonor.ru/rss/news.rss", "News", "Новости");
            /*if ((ViewModelLocator.MainStatic.News.Items.Count() == 0) || (ViewModelLocator.MainStatic.Settings.NewsUpdated.AddHours(1) < DateTime.Now))
            {
                var bw = new BackgroundWorker();
                bw.DoWork += delegate
                {
                    var client = new RestClient("http://yadonor.ru");
                    var request = new RestRequest("ru/news_rss/", Method.GET);
                    request.Parameters.Clear();

                    client.ExecuteAsync(request, response =>
                    {
                        try
                        {
                            try
                            {
                                ObservableCollection<NewsViewModel> newslist1 = new ObservableCollection<NewsViewModel>(); 
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
                                        newslist1.Add(itemnews);
                                    };
                                }
                                catch
                                {
                                };

                                Deployment.Current.Dispatcher.BeginInvoke(() =>
                                {
                                    ViewModelLocator.MainStatic.Settings.NewsUpdated = DateTime.Now;
                                    ViewModelLocator.MainStatic.SaveSettingsToStorage();
                                    this.Items = new ObservableCollection<NewsViewModel>(newslist1);
                                    RaisePropertyChanged("Items");
                                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<NewsViewModel>>(ViewModelLocator.MainStatic.News.Items, "news.xml");
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
            };*/
        }


        private ObservableCollection<NewsViewModel> _items;
        public ObservableCollection<NewsViewModel> Items { 
            get { return _items; } 
            set { 
                if (_items != value) {
                    _items = value;
                    RaisePropertyChanged("Items");
                    RaisePropertyChanged("NewItems");
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
    }


    public class NewsViewModel: ViewModelBase
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
                RaisePropertyChanged("Title");
            }
        }

        private string _uniqueId;
        public string UniqueId
        {
            get
            {
                return _uniqueId;
            }
            set
            {
                _uniqueId = value;
                RaisePropertyChanged("UniqueId");
            }
        }

        public string ObjectId { get; set; }


        private ImageSource _image = null;

        private string _imagePath = string.Empty;
        public string ImagePath
        {
            get { return this._imagePath; }
            set {
                _imagePath = value;
                RaisePropertyChanged("ImagePath");
            }
        }

        private static Uri _baseUri = new Uri("ms-appx:///");
        public ImageSource Image
        {
            get
            {
                if (this._image == null && this.ImagePath != null)
                {
                    this._image = new BitmapImage(new Uri(_baseUri, this.ImagePath));
                }
                return this._image;
            }

            set
            {
                this.ImagePath = null;
                this._image = value;
                RaisePropertyChanged("Image");                
            }
        }

        public void SetImage(String path)
        {
            this._image = null;
            this.ImagePath = path;
            RaisePropertyChanged("Image");
        }


        private string _body;
        public string Body {
            set
            {
                _body = value;
                RaisePropertyChanged("Body");
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
                RaisePropertyChanged("Url");
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
                    /*HtmlAgilityPack.HtmlDocument htmlDoc = new HtmlAgilityPack.HtmlDocument();
                    htmlDoc.OptionFixNestedTags = true;
                    htmlDoc.LoadHtml(sbody);
                    var text = htmlDoc.DocumentNode.InnerText;*/
                    sbody = sbody.Trim();
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
                    /*HtmlAgilityPack.HtmlDocument htmlDoc = new HtmlAgilityPack.HtmlDocument();
                    htmlDoc.OptionFixNestedTags = true;
                    htmlDoc.LoadHtml(sbody);
                    var text = htmlDoc.DocumentNode.InnerText;*/
                    sbody = sbody.Trim();
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
                return created1.ToString();
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
                RaisePropertyChanged("Created");
            }
        }
        private string _created = DateTime.Now.ToString();

        public DateTime Date { get; set; }
    }
}
