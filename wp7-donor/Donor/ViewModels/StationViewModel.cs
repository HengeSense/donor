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
using GART.Data;
using System.Collections.Generic;

namespace Donor.ViewModels
{
    public class StationsLitViewModel : INotifyPropertyChanged
    {
        public StationsLitViewModel()
        {
        }

        public GeoCoordinateWatcher myCoordinateWatcher;
        private bool _getCoordinates = false;
        void myCoordinateWatcher_PositionChanged(object sender, GeoPositionChangedEventArgs<GeoCoordinate> e)
        {

            if ((!e.Position.Location.IsUnknown) && (_getCoordinates == false))
            {                
                Latitued = e.Position.Location.Latitude;
                Longitude = e.Position.Location.Longitude;

                _getCoordinates = true;
            }
        }

        public double Latitued, Longitude; 

        //выбранный город
        public string SelectedCity { get; set; }
        //требуется прописка
        public bool IsRegional { get; set; }
        //работает по субботам
        public bool IsSaturdayWork { get; set; }
        //участвует в доноры-детям
        public bool IsChildrenDonor { get; set; }

        public bool IsFilter { get; set; }

        public void LoadStations()
        {
            myCoordinateWatcher = new GeoCoordinateWatcher(GeoPositionAccuracy.Default);
            myCoordinateWatcher.PositionChanged += new EventHandler<GeoPositionChangedEventArgs<GeoCoordinate>>(myCoordinateWatcher_PositionChanged);
            myCoordinateWatcher.Start();

            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Stations", Method.GET);
            request.Parameters.Clear();

            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

            client.ExecuteAsync(request, response =>
            {
                try
                {
                    ObservableCollection<StationViewModel> eventslist1 = new ObservableCollection<StationViewModel>();
                    JObject o = JObject.Parse(response.Content.ToString());
                    foreach (var item in o["results"])
                    {
                        StationViewModel station = new StationViewModel();
                        station.Adress = item["adress"].ToString();
                        try
                        {
                            station.BloodFor = item["bloodfor"].ToString();
                        }
                        catch
                        {
                            station.BloodFor = "";
                        };
                        station.City = item["city"].ToString();
                        station.Description = item["description"].ToString();
                        try
                        {
                            station.DonorsForChildrens = bool.Parse(item["donorsForChildrens"].ToString());
                        }
                        catch
                        {
                            station.DonorsForChildrens = false;
                        };

                        station.Nid = Int64.Parse(item["nid"].ToString());

                        station.Lat = item["latlon"]["latitude"].ToString();
                        station.Lon = item["latlon"]["longitude"].ToString();
                        station.objectId = item["objectId"].ToString();
                        station.Phone = item["phone"].ToString();
                        try
                        {
                            station.ReceiptTime = item["receiptTime"].ToString();
                        }
                        catch
                        {
                            station.ReceiptTime = "";
                        };
                        try
                        {
                            station.RegionalRegistration = bool.Parse(item["regionalRegistration"].ToString());
                        }
                        catch
                        {
                            station.RegionalRegistration = false;
                        };
                        try
                        {
                            station.SaturdayWork = bool.Parse(item["saturdayWork"].ToString());
                        }
                        catch
                        {
                            station.SaturdayWork = false;
                        };
                        station.Title = item["title"].ToString();
                        station.Transportaion = item["transportation"].ToString();
                        try
                        {
                            station.Url = item["url"].ToString();
                        }
                        catch
                        {
                            station.Url = "http://www.podari-zhizn.ru/main";
                        };
                        eventslist1.Add(station);
                    };
                    this.Items = eventslist1;
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<StationViewModel>>(App.ViewModel.Stations.Items, "stations.xml");
                }
                catch
                {
                };
                this.NotifyPropertyChanged("Items");
            });
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

        private ObservableCollection<StationViewModel> _items;
        public ObservableCollection<StationViewModel> Items
        {
            get
            {
                return _items;
            }
            set
            {
                _items = value;
                NotifyPropertyChanged("DistanceItems");
                NotifyPropertyChanged("Items");
            }
        }

        public List<StationViewModel> DistanceItems
        {
            get
            {
                List<StationViewModel> distance = (from station in this.Items
                        orderby station.Distance ascending
                        select station).ToList();
                return distance;
            }
            private set { }
        }

        public string FilteredText { get; set; }
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

    public class StationViewModel
    {
        public StationViewModel() {
        }

        /// <summary>
        /// Station title
        /// </summary>
        private string _title;
        public string Title
        {
            get { return _title; }
            set { _title = value; }
        }

        //public ReviewsListViewModel Reviews { get; set; }

        /// <summary>
        /// City name for station
        /// </summary>
        private string _city;
        public string City {
            get { return _city; }
            set { _city = value; }
        }

        /// <summary>
        /// Station street
        /// </summary>
        private string _adress;
        public string Adress
        {
            get { return _adress; }
            set { _adress = value; }
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
                try
                {
                    
                }
                catch { };
                _lat = value;
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
                try
                {
                    
                }
                catch { };
                _lon = value;
            }
        }

        public string Distance
        {
            get
            {
                double distanceInMeter;

                GeoCoordinate currentLocation = new GeoCoordinate(Convert.ToDouble(App.ViewModel.Stations.Latitued.ToString()), Convert.ToDouble(App.ViewModel.Stations.Longitude.ToString()));
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
            set { _url = value; }
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
            set { _description = value; }
        }

        /// <summary>
        /// Station phone
        /// </summary>
        private string _phone;
        public string Phone
        {
            get { return _phone; }
            set { _phone = value; }
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
                    return "Не указано"; 
                }
                else
                {
                    return _bloodFor; 
                };
                
            }
            set { _bloodFor = value; }
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
                    return "Не указано";
                }
                else
                {
                    return _receiptTime;
                };
            }
            set { _receiptTime = value; }
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
                        return "Не указано";
                    }
                    else
                    {
                        return _transportation;
                    };
                }
            set { _transportation = value; }
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
            set { _regionalRegistration = value; }
        }

        public string RegionalRegistrationString
        {
            get {
                if (true)
                {
                    return "Требуется регистрация в Москве или Московской области.";
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

    public class ARStation : ARItem
    {
        public ARStation()
        {

        }

        public string Title { get; set; }
        public string Adress { get; set; }        
    }
}
