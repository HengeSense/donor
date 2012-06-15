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

namespace Donor.ViewModels
{
    public class StationsLitViewModel : INotifyPropertyChanged
    {
        public StationsLitViewModel()
        {
        }

        public void LoadStations()
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Stations", Method.GET);
            request.Parameters.Clear();
            //string strJSONContent = "{\"type\":2}";
            request.AddHeader("X-Parse-Application-Id", "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu");
            request.AddHeader("X-Parse-REST-API-Key", "wPvwRKxX2b2vyrRprFwIbaE5t3kyDQq11APZ0qXf");
            //request.AddParameter("where", strJSONContent);
            client.ExecuteAsync(request, response =>
            {
                try
                {
                    ObservableCollection<StationViewModel> eventslist1 = new ObservableCollection<StationViewModel>();
                    JObject o = JObject.Parse(response.Content.ToString());
                    eventslist1 = JsonConvert.DeserializeObject<ObservableCollection<StationViewModel>>(o["results"].ToString());
                    this.Items = eventslist1;

                    //save to isolated storage
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

        public ObservableCollection<StationViewModel> Items { get; set; }
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
                _lon = value;
            }
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
            get { return _bloodFor; }
            set { _bloodFor = value; }
        }        

        /// <summary>
        /// Время приема
        /// </summary>
        private string _receiptTime;
        public string ReceiptTime
        {
            get { return _receiptTime; }
            set { _receiptTime = value; }
        }

        /// <summary>
        /// проезд
        /// </summary>
        private string _transportation;
        public string Transportaion
        {
            get { return _transportation; }
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
                    return "Не требуется регистрация в Москве или Московской области.";
                };
            }
            private set {}
        }
    }
}
