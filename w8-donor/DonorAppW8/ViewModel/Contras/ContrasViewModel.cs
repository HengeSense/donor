using DonorAppW8.DataModel;
using GalaSoft.MvvmLight;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace DonorAppW8.ViewModel.Contras
{
    public class ContraViewModel: ViewModelBase
    {
        public ContraViewModel()
        {
        }

        private string _objectId = "";
        public string ObjectId
        {
            get
            {
                return _objectId;
            }
            set
            {
                _objectId = value;
                _uniqueId = value;
                RaisePropertyChanged("ObjectId");
                RaisePropertyChanged("UniqueId");
            }
        }

        private string _uniqueId = "";
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

        public string Description { get; set; }
        public bool Absolute { get; set; }
        public string Parent_id { get; set; }
        public string Title { get; set; }

        public string CreatedAt { get; set; }
        public string UpdatedAt { get; set; }

        public DateTime Date { get; set; }
    }


    /// <summary>
    /// Управление списком противопоказаний
    /// </summary>
    public class ContraListViewModel: ViewModelBase
    {
        public ContraListViewModel()
        {
            Items = new ObservableCollection<ContraViewModel>();
        }

        public ObservableCollection<ContraViewModel> Items { get; set; }

        public void CreateHelpGroup()
        {
            try
            {
                RssDataGroup adgroup = new RssDataGroup();
                adgroup.Title = "Справка";
                adgroup.UniqueId = "Help";

                adgroup.Items = new ObservableCollection<object>();

                var item = new HelpItem();
                item.Title = "Перед кроводачей";
                item.UniqueId = "before";
                item.ImagePath = "ms-appx:///Assets/donor_news_images (1).jpg";
                adgroup.Items.Add(item);

                /*item = new HelpItem();
                item.Title = "После кроводачей";
                item.UniqueId = "after";
                item.ImagePath = "ms-appx:///Assets/donor_news_images (2).jpg";
                adgroup.Items.Add(item);*/

                item = new HelpItem();
                item.Title = "Противопоказания";
                item.UniqueId = "contras";
                item.ImagePath = "ms-appx:///Assets/donor_news_images (3).jpg";
                adgroup.Items.Add(item);



                /*item = new HelpItem();
                item.Title = "Перед кроводачей";
                item.UniqueId = "before";
                item.ImagePath = "ms-appx:///Assets/donor_news_images (1).jpg";
                adgroup.Items.Add(item);

                item = new HelpItem();
                item.Title = "После кроводачей";
                item.UniqueId = "after";
                item.ImagePath = "ms-appx:///Assets/donor_news_images (2).jpg";
                adgroup.Items.Add(item);

                item = new HelpItem();
                item.Title = "Противопоказания";
                item.UniqueId = "contras";
                item.ImagePath = "ms-appx:///Assets/donor_news_images (3).jpg";
                adgroup.Items.Add(item);*/


                ViewModelLocator.MainStatic.Groups.Add(adgroup);
            }
            catch { };
        }

        public async void LoadContras()
        {           

            try
            {
                ObservableCollection<ContraViewModel> contraslist1 = new ObservableCollection<ContraViewModel>();
                //contraslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<ContraViewModel>>("contras.xml");
                this.Items = contraslist1;
            }
            catch { 
                this.Items = new ObservableCollection<ContraViewModel>(); 
            };

            if (ViewModelLocator.MainStatic.Contras.Items.Count == 0)
            {
                try
                {
                    HttpClient http = new System.Net.Http.HttpClient();
                    http.DefaultRequestHeaders.Add("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                    http.DefaultRequestHeaders.Add("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                    HttpResponseMessage response = await http.GetAsync("https://api.parse.com/1/classes/Contras?limit=1000");
                    response.Headers.Add("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                    response.Headers.Add("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                    string json = await response.Content.ReadAsStringAsync();

                    ObservableCollection<ContraViewModel> contraslist1 = new ObservableCollection<ContraViewModel>();
                    JObject o = JObject.Parse(json.ToString());
                    contraslist1 = JsonConvert.DeserializeObject<ObservableCollection<ContraViewModel>>(o["results"].ToString());

                    this.Items = contraslist1;

                    /*try
                    {
                        RssDataGroup adgroup = new RssDataGroup();
                        adgroup.Title = "Противопоказания";
                        adgroup.UniqueId = "Contras";

                        adgroup.Items = new ObservableCollection<object>(this.Items);
                        ViewModelLocator.MainStatic.Groups.Add(adgroup);
                    }
                    catch { };*/

                }
                catch { };

                RaisePropertyChanged("Items");
                CreateHelpGroup();
            }
            else { };
        }
    }
}
