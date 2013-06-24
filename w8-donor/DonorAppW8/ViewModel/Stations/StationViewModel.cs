using System;
using System.Net;
using System.Windows;
using System.Windows.Input;
using System.Collections.ObjectModel;

using System.ComponentModel;
using Newtonsoft.Json.Linq;
using System.Linq;
using Newtonsoft.Json;
//using GART.Data;
using System.Collections.Generic;
using GalaSoft.MvvmLight;
using System.Text.RegularExpressions;
using DonorAppW8.ViewModel;
using Parse;
using DonorAppW8.DataModel;
using System.Threading.Tasks;
using System.Net.Http;
using Windows.Devices.Geolocation;

namespace DonorAppW8.ViewModels
{
    public class StationsListViewModel: ViewModelBase
    {
        public StationsListViewModel()
        {
            this.FilteredText = "";
            this.IsChildrenDonor = false;
            this.IsFilter = false;
            this.IsSaturdayWork = false;
            this.IsRegional = false;

            this.Items = new ObservableCollection<YAStationItem>();
        }

        private string _currentState = "";
        public string CurrentState {
            get
            {
                return _currentState;
            }
            set
            {
                if (_currentState != value)
                {
                    _currentState = value;
                    UpdateDistanceItems();
                };
            }
        }
        private string _currentDistrict = "";
        public string CurrentDistrict
        {
            get
            {
                return _currentDistrict;
            }
            set
            {
                if (_currentDistrict != value)
                {
                    _currentDistrict = value;
                    UpdateDistanceItems();
                };
            }
        }
        private string _filterText = "";
        public string FilterText
        {
            get
            {
                return _filterText;
            }
            set
            {
                if (_filterText!=value)
                {
                _filterText = value;
                RaisePropertyChanged("FilterText");
                RaisePropertyChanged("DistrictItems");
                UpdateDistanceItems();
                };
            }
        }

        /// <summary>
        /// выбранный город
        /// </summary>
        public string SelectedCity { get; set; }
        /// <summary>
        /// требуется прописка
        /// </summary>
        public bool IsRegional { get; set; }
        /// <summary>
        /// работает по субботам
        /// </summary>
        public bool IsSaturdayWork { get; set; }
        /// <summary>
        /// участвует в доноры-детям
        /// </summary>
        public bool IsChildrenDonor { get; set; }
        /// <summary>
        /// Есть ил фильтрация
        /// </summary>
        public bool IsFilter { get; set; }

        //selected station for edit
        public string SelectedStation { get; set; }

        private string _town = "Москва";
        public string Town
        {
            get
            {
                return _town;
            }
            set
            {
                if (_town!=value)
                {
                _town = value;
                RaisePropertyChanged("Town");
                };
            }
        }

        private string _street = "Арбат";
        public string Street
        {
            get
            {
                return _street;
            }
            set
            {
                if (_street != value)
                {
                    _street = value;
                    RaisePropertyChanged("Street");
                };
            }
        }

        private string _state = "Москва";
        public string State
        {
            get
            {
                return _state;
            }
            set
            {
                if (_state != value)
                {
                    _state = value;
                    RaisePropertyChanged("State");
                };
            }
        }

        public async Task<string> MakeWebRequest(string url = "")
        {
            HttpClient http = new System.Net.Http.HttpClient();
            HttpResponseMessage response = await http.GetAsync(url);
            return await response.Content.ReadAsStringAsync();
        }

        public async Task<bool> GetPlaceInfo(double lat, double lon)
        {
            var roamingSettings = Windows.Storage.ApplicationData.Current.RoamingSettings;
            //if (roamingSettings.Values["street"].ToString() == "")
            //{
            var responseText = await MakeWebRequest("http://nominatim.openstreetmap.org/reverse?format=json&zoom=18&addressdetails=1&lat=" + lat.ToString().Replace(",", ".") + "&lon=" + lon.ToString().Replace(",", "."));
            try
            {
                JObject o = JObject.Parse(responseText.ToString());
                string town = "Москва";
                try {
                    town = o["address"]["city"].ToString(); } catch {};
                string road = "";
                try
                {
                    road = o["address"]["road"].ToString();
                } catch {};
                string state = o["address"]["state"].ToString();
                ViewModelLocator.MainStatic.Stations.Street = road;
                ViewModelLocator.MainStatic.Stations.Town = town;
                ViewModelLocator.MainStatic.Stations.State = state;
            }
            catch
            {
            };
            return true;
            //};
        }
        public double Latitued = 55.45;
        public double Longitude = 37.36; 

        public async void LoadCurrentRegion()
        {
            try
            {
                var geolocator = new Geolocator();
                Geoposition position = await geolocator.GetGeopositionAsync();
                var str = position.ToString();
                Latitued = position.Coordinate.Latitude;
                Longitude = position.Coordinate.Longitude;
                await GetPlaceInfo(Latitued, Longitude);

                LoadStations();
            }
            catch { };
        }

        /// <summary>
        /// Загрузка станций с parse.com
        /// </summary>
        public async void LoadStations()
        {
            ParseQuery<ParseObject> query = from yastation in ParseObject.GetQuery("YAStations")
                                            where yastation.Get<string>("region_name").StartsWith(this.State.Trim())
                                            select yastation;
            //ParseObject.GetQuery("YAStations");
            query = query.Limit(100);
            IEnumerable<ParseObject> results = await query.FindAsync();
            foreach (var station in results)
            {
                try
                {
                    YAStationItem stationitem = new YAStationItem();
                    stationitem.Name = station.Get<string>("name");
                    stationitem.ObjectId = station.ObjectId;
                    stationitem.UniqueId = station.ObjectId;
                    stationitem.Address = station.Get<string>("address");
                    stationitem.District_name = station.Get<string>("district_name");
                    stationitem.Region_name = station.Get<string>("region_name");
                    stationitem.Town = station.Get<string>("town");

                    try { stationitem.Work_time = station.Get<string>("work_time"); } catch {};
                    try { stationitem.Site = station.Get<string>("site");} catch {};
                    try { stationitem.Phone = station.Get<string>("phone");} catch {};
                    try { stationitem.Chief = station.Get<string>("chief");} catch {};
                    try { stationitem.Shortaddress = station.Get<string>("shortaddress");} catch {};
                    try { stationitem.Email = station.Get<string>("email");} catch {};
                    try { stationitem.Lat = station.Get<double>("lat");} catch {};
                    try { stationitem.Lon = station.Get<double>("lon"); } catch { };

                    ViewModelLocator.MainStatic.Stations.Items.Add(stationitem);
                }
                catch { };
            };
            RssDataGroup adgroup = new RssDataGroup();
            adgroup.Title = "Станции";
            adgroup.UniqueId = "CurrentStations";

            adgroup.Items = new ObservableCollection<object>(this.Items);
            ViewModelLocator.MainStatic.Groups.Add(adgroup);
            RaisePropertyChanged("Items");
        }

        private ObservableCollection<TownItem> _districtItems = new ObservableCollection<TownItem>();
        public ObservableCollection<TownItem> DistrictItems
        {
            private set
            {
            }
            get
            {
                ObservableCollection<TownItem> districtItems = new ObservableCollection<TownItem>();
                if (_districtItems.Count() == 0)
                {                    
                    foreach (var item in Items)
                    {
                        if (districtItems.FirstOrDefault(c => c.DistrictName == item.District_name) == null)
                        {
                            districtItems.Add(new TownItem()
                            {
                                TownName = item.Town,
                                DistrictName = item.District_name,
                                RegionName = item.Region_name
                            });
                        };
                    };
                    if (FilterText != "")
                    {
                        ObservableCollection<TownItem> districtItems2 = districtItems;
                        districtItems = new ObservableCollection<TownItem>();
                        var itemsFilter = from townItem in districtItems2
                                          where townItem.DistrictName.ToLower().Contains(FilterText.ToLower())
                                          select townItem;
                        foreach (var item in itemsFilter)
                        {
                            districtItems.Add(item);
                        };
                    };
                    _districtItems = districtItems;
                }
                else
                {
                    if (FilterText != "")
                    {
                        ObservableCollection<TownItem> districtItems2 = districtItems;
                        districtItems = new ObservableCollection<TownItem>();
                        var itemsFilter = from townItem in _districtItems
                                          where townItem.DistrictName.ToLower().Contains(FilterText.ToLower())
                                          select townItem;
                        foreach (var item in itemsFilter)
                        {
                            districtItems.Add(item);
                        };
                    }
                    else
                    {
                        districtItems = _districtItems;
                    };
                };
                return districtItems;
            }
        }

        private ObservableCollection<YAStationItem> _items;
        public ObservableCollection<YAStationItem> Items
        {
            get
            {
                return _items;
            }
            set
            {
                _items = value;
                UpdateDistanceItems();
                RaisePropertyChanged("Items");
            }
        }

        /// <summary>
        /// Обновляем список станций в связи с изменением списка фильтров
        /// </summary>
        private void UpdateDistanceItems()
        {
            List<YAStationItem> distance = new List<YAStationItem>();
            if ((CurrentState == "") && (CurrentDistrict == ""))
            {
                distance = Items.ToList();
            }
            else
            {
                if (CurrentDistrict == "")
                {
                    distance = (from station in Items
                                where station.Region_name.ToLower() == CurrentState.ToLower()
                                select station).ToList();
                };
                if (CurrentState == "")
                {
                    distance = (from station in Items
                                where station.District_name.ToLower() == CurrentDistrict.ToLower()
                                select station).ToList();
                };
                if ((CurrentState != "") && (CurrentDistrict != ""))
                {
                    distance = (from station in Items
                                where ((station.District_name.ToLower() == CurrentDistrict.ToLower())
                                && (station.Region_name.ToLower() == CurrentState.ToLower()))
                                select station).ToList();
                };
                if (distance.Count() == 0)
                {
                    distance = Items.ToList();
                };
            };
            _distanceItems = distance;
            RaisePropertyChanged("DistanceItems");
        }

        private List<YAStationItem> _distanceItems = new List<YAStationItem>();
        /// <summary>
        /// Список отфильтрованных станций (по удаленности)
        /// </summary>
        public List<YAStationItem> DistanceItems
        {
            get
            {
                return _distanceItems;
            }
            private set { }
        }

        public string FilteredText { get; set; }

        private YAStationItem _currentStation = null;
        public YAStationItem CurrentStation
        {
            get {
                return _currentStation;
            }
            set {
                _currentStation = value;
                RaisePropertyChanged("CurrentStation");
            }
        }
    }


    public class TownItem : ViewModelBase
    {
        public TownItem()
        {
        }

        private string _townName = "";
        public string TownName {
            get
            {
                return _townName;
            }
            set
            {
                _townName = value;
                RaisePropertyChanged("TownName");
            }
        }

        private string _districtName = "";
        public string DistrictName
        {
            get
            {
                return _districtName;
            }
            set
            {
                _districtName = value;
                RaisePropertyChanged("DistrictName");
            }
        }
        public string RegionName = "";
    }

    public class LatLonItem
    {
        public LatLonItem()
        {
        }

        public string __type { get; set; }
        public string latitude { get; set; }
        public string longitude { get; set; }
    }

    public class YAStationItem : ViewModelBase
    {
        public YAStationItem()
        {
        }

        private string _name = "";
        /// <summary>
        /// Название станции
        /// </summary>
        public string Name {
            get
            {
                return _name;
            }
            set
            {
                _name = value;
                _title = value;
                RaisePropertyChanged("Name");
                RaisePropertyChanged("Title");
            }
        }

        private string _title = "";
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

        private bool _foursquareExists = false;
        /// <summary>
        /// Существует ли станция переливания на foursquare (для оставления отзыва к ней)
        /// </summary>
        public bool FoursquareExists
        {
            get
            {
                return _foursquareExists;
            }
            set
            {
                _foursquareExists = value;
                RaisePropertyChanged("FoursquareExists");
            }
        }

        private string _foursquareId = "";
        /// <summary>
        /// Идентификатор станции на foursquare
        /// </summary>
        public string FoursquareId
        {
            get
            {
                return _foursquareId;
            }
            set
            {
                _foursquareId = value;
                RaisePropertyChanged("FoursquareId");
            }
        }
        
        private string _region_name = "";
        /// <summary>
        /// название региона
        /// </summary>
        public string Region_name {
            get
            {
                return _region_name.Trim();
            }
            set
            {
                _region_name = value;
                RaisePropertyChanged("Region_name");
            }
        }

        private string _phone = "";
        /// <summary>
        /// телефон станции
        /// </summary>
        public string Phone {
            get
            {
                return _phone;
            }
            set
            {
                _phone = value;
                RaisePropertyChanged("Phone");
            }
        }

        private string _district_name = "";
        /// <summary>
        /// название района
        /// </summary>
        public string District_name {
            get
            {
                return _district_name;
            }
            set
            {
                _district_name = value;
                RaisePropertyChanged("District_name");
            }
        }

        private string _site = "";
        /// <summary>
        /// сайт станции
        /// </summary>
        public string Site {
            get
            {
                return _site;
            }
            set
            {
                _site = value;
                RaisePropertyChanged("Site");
            }
        }

        private int _region_id = 0;
        /// <summary>
        /// идентификатор региона
        /// </summary>
        public int Region_id
        {
            get
            {
                return _region_id;
            }
            set
            {
                _region_id = value;
                RaisePropertyChanged("Region_id");
            }
        }

        private int _district_id = 0;
        /// <summary>
        /// идентификатор района
        /// </summary>
        public int District_id
        {
            get
            {
                return _district_id;
            }
            set
            {
                _district_id = value;
                RaisePropertyChanged("District_id");
            }
        }

        private string _address = "";
        /// <summary>
        /// Адрес станции переливания
        /// </summary>
        public string Address
        {
            get
            {
                return _address;
            }
            set
            {
                _address = value;
                /// пытаемся очистить индекс из строки адреса станции переливания
                try
                {
                    _address = Regex.Replace(_address, "^\\d{6}[,]", "");
                    _address = Regex.Replace(_address, "^\\d{5}[,]", "");
                }
                catch { };
                _address = _address.Trim();
                RaisePropertyChanged("Address");
            }
        }

        public string ShowAddress
        {
            private set
            {
            }
            get
            {
                if (Shortaddress == "")
                {
                    return Address;
                }
                else
                {
                    if ((ViewModelLocator.MainStatic.Stations.CurrentDistrict == "") && (ViewModelLocator.MainStatic.Stations.CurrentState != "Москва") && (ViewModelLocator.MainStatic.Stations.CurrentState != "Санкт-Петербург"))
                    {
                        return Town + ", " + Shortaddress;
                    }
                    else
                    {
                        return Shortaddress;
                    };                    
                };
            }
        }

        private string _shortaddress = "";
        /// <summary>
        /// Короткий адрес
        /// </summary>
        public string Shortaddress
        {
            get
            {
                return _shortaddress;
            }
            set
            {
                _shortaddress = value;
                RaisePropertyChanged("Shortaddress");
            }
        }

        private string _objectId = "";
        /// <summary>
        /// Идентификатор объекта станции
        /// </summary>
        public string ObjectId
        {
            get
            {
                return _objectId;
            }
            set
            {
                _objectId = value;
                RaisePropertyChanged("ObjectId");
            }
        }

        private string _email = "";
        /// <summary>
        /// Email станции переливания крови
        /// </summary>
        public string Email
        {
            get
            {
                return _email;
            }
            set
            {
                _email = value;
                RaisePropertyChanged("Email");
            }
        }

        private string _chief = "";
        /// <summary>
        /// руководитель станции переливания
        /// </summary>
        public string Chief
        {
            get
            {
                return _chief;
            }
            set
            {
                _chief = value;
                RaisePropertyChanged("Chief");
            }
        }

        private string _work_time = "";
        /// <summary>
        /// время работы станции
        /// </summary>
        public string Work_time
        {
            get
            {
                return _work_time;
            }
            set
            {
                _work_time = value;
                RaisePropertyChanged("Work_time");
            }
        }

        private string _town = "";
        /// <summary>
        /// город, в котором находится станция
        /// </summary>
        public string Town
        {
            get
            {
                return _town;
            }
            set
            {
                _town = value;
                RaisePropertyChanged("Town");
            }
        }

        private double _lat = 0;//"33";
        public double Lat
        {
            get
            {
                return _lat;
            }
            set
            {
                _lat = value;
                RaisePropertyChanged("Lat");
            }
        }
        public double LatDouble
        {
            private set
            {
            }
            get
            {
                double itemLat = 0.0;
                try
                {
                    itemLat = Convert.ToDouble(Lat.ToString().Replace(".", ","));
                }
                catch { };
                return itemLat;
            }
        }

        private double _lon = 0;//"30";
        public double Lon
        {
            get
            {
                return _lon;
            }
            set
            {
                _lon = value;
                RaisePropertyChanged("Lon");
            }
        }
        public double LonDouble
        {
            private set
            {
            }
            get
            {
                double itemLon = 0.0;
                try
                {
                    itemLon = Convert.ToDouble(Lon.ToString().Replace(".", ","));
                }
                catch { };
                return itemLon;
            }
        }

        public string Distance
        {
            get
            {
                double distanceInMeter;

                double curLat = 0.0;
                double curLon = 0.0;

                try {
                    curLat = Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Latitued.ToString());
                } catch {};
                try
                {
                    curLon = Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Longitude.ToString());
                }
                catch { };

                //GeoCoordinate currentLocation = new GeoCoordinate(curLat, curLon);
                //GeoCoordinate clientLocation = new GeoCoordinate(Lat, Lon);
                distanceInMeter = 1;// currentLocation.GetDistanceTo(clientLocation);

                return (Math.Round(distanceInMeter / 1000)).ToString();
            }

            private set { }
        }
    }

    public class ARStation //: ARItem
    {
        public ARStation()
        {
        }
        public string Title { get; set; }
        public string Adress { get; set; }        
    }
}
