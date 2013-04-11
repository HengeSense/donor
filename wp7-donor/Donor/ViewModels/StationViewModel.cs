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
using RestSharp;
using System.ComponentModel;
using Newtonsoft.Json.Linq;
using System.Linq;
using Newtonsoft.Json;
using MSPToolkit.Utilities;
using System.Device.Location;
//using GART.Data;
using System.Collections.Generic;
using GalaSoft.MvvmLight;
using System.Text.RegularExpressions;

namespace Donor.ViewModels
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

        public void UpdateCoordinatesWatcher()
        {
            try
            {
                myCoordinateWatcher.Stop();
                myCoordinateWatcher = new GeoCoordinateWatcher(GeoPositionAccuracy.Default);
                myCoordinateWatcher.PositionChanged += new EventHandler<GeoPositionChangedEventArgs<GeoCoordinate>>(myCoordinateWatcher_PositionChanged);
                myCoordinateWatcher.Start();
            }
            catch { };
        }

        public GeoCoordinateWatcher myCoordinateWatcher;
        private bool _getCoordinates = false;
        /// <summary>
        /// Обновилось положение устройства
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void myCoordinateWatcher_PositionChanged(object sender, GeoPositionChangedEventArgs<GeoCoordinate> e)
        {
            if (ViewModelLocator.MainStatic.Settings.Location == true)
            {
                if (((!e.Position.Location.IsUnknown) && (_getCoordinates == false)))
                {
                    Latitued = e.Position.Location.Latitude;
                    Longitude = e.Position.Location.Longitude;

                    _getCoordinates = true;
                    GetPlaceInfo(Latitued, Longitude);
                };
            }
            else
            {
                Latitued = 55.45;
                Longitude = 37.36;                
            };
            
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
        /// Получаем информацию по координатам о местонахождении пользователя
        /// </summary>
        /// <param name="lat"></param>
        /// <param name="lon"></param>
        public void GetPlaceInfo(double lat, double lon)
        {
            ///reverse?format=json&lat=58.17&lon=38.6&zoom=18&addressdetails=1
            var client = new RestClient("http://nominatim.openstreetmap.org");
            var request = new RestRequest("reverse?format=json&zoom=18&addressdetails=1&lat=" + lat.ToString().Replace(",", ".") + "&lon=" + lon.ToString().Replace(",", "."), Method.GET);
            request.Parameters.Clear();
            client.ExecuteAsync(request, response =>
            {
                try
                {                    
                    JObject o = JObject.Parse(response.Content.ToString());
                    string state = o["address"]["state"].ToString();
                    string town = "";
                    try
                    {                        
                        town = o["address"]["city"].ToString();
                        if (town=="Москва") {
                            state = town;
                        };                        
                    }
                    catch {
                        //MessageBox.Show(ex.Message.ToString());
                    };
                    //MessageBox.Show("Регион - " + state + "\nгород - " + town + "\nlat=" + lat.ToString().Replace(",", ".") + "\nlon=" + lon.ToString().Replace(",", "."));
                    CurrentState = state;
                    UpdateDistanceItems();
                }
                catch
                {
                };

            });
        }

        public double Latitued =  55.45;
        public double Longitude = 37.36; 

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

        /// <summary>
        /// Загрузка станций с parse.com
        /// </summary>
        public void LoadStations()
        {
            myCoordinateWatcher = new GeoCoordinateWatcher(GeoPositionAccuracy.Default);
            myCoordinateWatcher.PositionChanged += new EventHandler<GeoPositionChangedEventArgs<GeoCoordinate>>(myCoordinateWatcher_PositionChanged);
            myCoordinateWatcher.Start();

            try
            {
                ObservableCollection<YAStationItem> stationslist1 = new ObservableCollection<YAStationItem>();
                stationslist1 = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<YAStationItem>>("yastations.xml");
                this.Items = stationslist1;
            }
            catch { 
                this.Items = new ObservableCollection<YAStationItem>(); 
            };

            // загружаем станции если их нет или дата последнего обновления была более чем одни сутки в прошлом
            //(ViewModelLocator.MainStatic.Settings.StationsUpdated.AddDays(1) < DateTime.Now)
            //ViewModelLocator.MainStatic.Loadin
            if ((ViewModelLocator.MainStatic.Stations.Items.Count() == 0) && (ViewModelLocator.MainStatic.Settings.StationsUpdated.AddDays(7) < DateTime.Now))
            {            
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/YAStations?limit=1000", Method.GET);
            request.Parameters.Clear();

            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

            client.ExecuteAsync(request, response =>
            {
                try
                {
                    ObservableCollection<YAStationItem> eventslist1 = new ObservableCollection<YAStationItem>();
                    JObject o = JObject.Parse(response.Content.ToString());
                    eventslist1 = JsonConvert.DeserializeObject<ObservableCollection<YAStationItem>>(o["results"].ToString());

                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            ViewModelLocator.MainStatic.Settings.StationsUpdated = DateTime.Now;
                            ViewModelLocator.MainStatic.SaveSettingsToStorage();
                            this.Items = eventslist1;

                            IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<YAStationItem>>(this.Items, "yastations.xml");

                            RaisePropertyChanged("Items");
                            UpdateDistanceItems();
                            RaisePropertyChanged("DistrictItems");  
                        });                       
                    
                }
                catch
                {
                };
                
            });
            };
            bw.RunWorkerAsync();
            } else {
                var bw = new BackgroundWorker();
                bw.DoWork += delegate
                {
                    var client = new RestClient("https://api.parse.com");
                    var request = new RestRequest("1/classes/YAStations?limit=1000&where={\"updatedAt\":{\"$gte\":{\"__type\":\"Date\",\"iso\":\"" + ViewModelLocator.MainStatic.Settings.StationsUpdated.ToUniversalTime().ToString("s") + "\"}}}", Method.GET);
                    request.Parameters.Clear();

                    request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                    request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                    client.ExecuteAsync(request, response =>
                    {
                        try
                        {
                            ObservableCollection<YAStationItem> eventslist1 = new ObservableCollection<YAStationItem>();
                            JObject o = JObject.Parse(response.Content.ToString());
                            eventslist1 = JsonConvert.DeserializeObject<ObservableCollection<YAStationItem>>(o["results"].ToString());

                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                                ViewModelLocator.MainStatic.Settings.StationsUpdated = DateTime.Now;
                                ViewModelLocator.MainStatic.SaveSettingsToStorage();
                                foreach (var item in eventslist1)
                                {
                                    try
                                    {
                                        if (this.Items.FirstOrDefault(c => c.ObjectId == item.ObjectId) != null)
                                        {
                                            this.Items.Remove(this.Items.FirstOrDefault(c => c.ObjectId == item.ObjectId));
                                            this.Items.Add(item);
                                        }
                                        else
                                        {
                                            this.Items.Add(item);
                                        };
                                    }
                                    catch { };
                                };

                                IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<YAStationItem>>(this.Items, "yastations.xml");

                                RaisePropertyChanged("Items");
                                UpdateDistanceItems();
                                RaisePropertyChanged("DistrictItems");
                            });

                        }
                        catch
                        {
                        };

                    });
                };
                bw.RunWorkerAsync();
            };
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
                        _districtItems = districtItems;
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

        /// <summary>
        /// Название станции
        /// </summary>
        private string _name = "";
        public string Name {
            get
            {
                return _name;
            }
            set
            {
                _name = value;
                RaisePropertyChanged("Name");
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
                    return Town+", "+Shortaddress;
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

                GeoCoordinate currentLocation = new GeoCoordinate(curLat, curLon);
                GeoCoordinate clientLocation = new GeoCoordinate(Lat, Lon);
                distanceInMeter = currentLocation.GetDistanceTo(clientLocation);

                return (Math.Round(distanceInMeter / 1000)).ToString();
            }

            private set { }
        }
    }

    public class StationViewModel: ViewModelBase
    {
        public StationViewModel() {
        }

        /// <summary>
        /// Station title
        /// </summary>
        private string _title;
        public string Title
        {
            get {
                return Char.ToLowerInvariant(_title[0]) + _title.Substring(1);
                //return _title; 
            }
            set { _title = value; RaisePropertyChanged("Title"); }
        }

        //public ReviewsListViewModel Reviews { get; set; }

        /// <summary>
        /// City name for station
        /// </summary>
        private string _city;
        public string City {
            get { return _city; }
            set { _city = value; RaisePropertyChanged("City"); }
        }

        /// <summary>
        /// Station street
        /// </summary>
        private string _adress;
        public string Adress
        {
            get { return _adress; }
            set { _adress = value; RaisePropertyChanged("Adress"); }
        }

        private string _lat;
        public string Lat
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

        private string _lon;
        public string Lon
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

        public string Distance
        {
            get
            {
                double distanceInMeter;

                GeoCoordinate currentLocation = new GeoCoordinate(Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Latitued.ToString()), Convert.ToDouble(ViewModelLocator.MainStatic.Stations.Longitude.ToString()));
                GeoCoordinate clientLocation = new GeoCoordinate(Convert.ToDouble(this.Lat.ToString()), Convert.ToDouble(this.Lon.ToString()));
                distanceInMeter = currentLocation.GetDistanceTo(clientLocation);

                return (Math.Round(distanceInMeter / 1000)).ToString();
            }

            private set { }
        }

        public string LatLon
        {
            get;
            set;
        }

        /// <summary>
        /// Station site url
        /// </summary>
        private string _url;
        public string Url
        {
            get { return _url; }
            set { _url = value; RaisePropertyChanged("Url");  }
        }

        public string NidUrl
        {
            get { return "http://www.podari-zhizn.ru/main/node/"+this.Nid.ToString(); }
            private set {}
        }

        /// <summary>
        /// Station description
        /// </summary>
        private string _description;
        public string Description
        {
            get { return _description; }
            set { _description = value; RaisePropertyChanged("Description"); }
        }

        /// <summary>
        /// Station phone
        /// </summary>
        private string _phone;
        public string Phone
        {
            get { return _phone; }
            set { _phone = value; RaisePropertyChanged("Phone"); }
        }

        /// <summary>
        /// Blood for ...
        /// </summary>
        private string _bloodFor;
        public string BloodFor
        {
            get {
                if (_bloodFor == "")
                {
                    return Donor.AppResources.DontFilledData; 
                }
                else
                {
                    return _bloodFor; 
                };
                
            }
            set { _bloodFor = value; RaisePropertyChanged("BloodFor"); }
        }        

        /// <summary>
        /// Время приема
        /// </summary>
        private string _receiptTime;
        public string ReceiptTime
        {
            get {
                if (_receiptTime == "")
                {
                    return Donor.AppResources.DontFilledData;
                }
                else
                {
                    return _receiptTime;
                };
            }
            set { _receiptTime = value; RaisePropertyChanged("ReceiptTime"); }
        }

        /// <summary>
        /// проезд
        /// </summary>
        private string _transportation;
        public string Transportaion
        {
            get {
                    if (_transportation == "")
                    {
                        return Donor.AppResources.DontFilledData;
                    }
                    else
                    {
                        return _transportation;
                    };
                }
            set { _transportation = value; RaisePropertyChanged("Transportaion"); }
        }

        private string _objectId;
        public string objectId
        {
            get { return _objectId; }
            set { _objectId = value; }
        }

        /// <summary>
        /// работа по субботам
        /// </summary>
        private bool _saturdayWork;
        public bool SaturdayWork
        {
            get { return _saturdayWork; }
            set { _saturdayWork = value; }
        }

        private bool _donorsForChildrens;
        public bool DonorsForChildrens
        {
            get { return _donorsForChildrens; }
            set { _donorsForChildrens = value; }
        }

        private bool _regionalRegistration;
        public bool RegionalRegistration
        {
            get { return _regionalRegistration; }
            set { _regionalRegistration = value; RaisePropertyChanged("RegionalRegistration"); }
        }

        public string RegionalRegistrationString
        {
            get {
                if (true)
                {
                    return Donor.AppResources.NeedRegistrationInMoscow;
                }
                else
                {
                    //return "Не требуется регистрация в Москве или Московской области.";
                };
            }
            private set {}
        }

        public Int64 Nid { get; set; }
        
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
