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

namespace Donor.ViewModels
{
    public class StationsLitViewModel
    {
        public StationsLitViewModel()
        {
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
        private string _street;
        public string Street
        {
            get { return _street; }
            set { _street = value; }
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
    }
}
