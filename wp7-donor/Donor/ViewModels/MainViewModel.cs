using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;
using System.Collections.ObjectModel;
using Parse;
using Parse.Queries;
using Donor.ViewModels;

namespace Donor
{   
    public class MainViewModel : INotifyPropertyChanged
    {
        public const string APPLICATION_ID = "EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu";
        public const string REST_API_KEY = "uNarhakSf1on8lJjrAVs1VWmPlG1D6ZJf9dO5QZY";

        //public Driver Parse;

        public MainViewModel()
        {            
            this.Items = new ObservableCollection<ItemViewModel>();

            ParseConfiguration.Configure(APPLICATION_ID, REST_API_KEY);
            //this.Parse = new Driver();
            //var parse = new Driver();

            News = new NewsListViewModel();
        }

        /// <summary>
        /// A collection for ItemViewModel objects.
        /// </summary>
        public ObservableCollection<ItemViewModel> Items { get; private set; }

        public NewsListViewModel News { get; set; }

        /*private string _sampleProperty = "Sample Runtime Property Value";
        /// <summary>
        /// Sample ViewModel property; this property is used in the view to display its value using a Binding
        /// </summary>
        /// <returns></returns>
        public string SampleProperty
        {
            get
            {
                return _sampleProperty;
            }
            set
            {
                if (value != _sampleProperty)
                {
                    _sampleProperty = value;
                    NotifyPropertyChanged("SampleProperty");
                }
            }
        }*/

        public bool IsDataLoaded
        {
            get;
            private set;
        }

        /// <summary>
        /// Creates and adds a few ItemViewModel objects into the Items collection.
        /// </summary>
        public void LoadData()
        {
            // Sample data; replace with real data
            /*this.Items.Add(new ItemViewModel() { LineOne = "runtime one", LineTwo = "Maecenas praesent accumsan bibendum", LineThree = "Facilisi faucibus habitant inceptos interdum lobortis nascetur pharetra placerat pulvinar sagittis senectus sociosqu" });
            this.Items.Add(new ItemViewModel() { LineOne = "runtime two", LineTwo = "Dictumst eleifend facilisi faucibus", LineThree = "Suscipit torquent ultrices vehicula volutpat maecenas praesent accumsan bibendum dictumst eleifend facilisi faucibus" });
            this.Items.Add(new ItemViewModel() { LineOne = "runtime three", LineTwo = "Habitant inceptos interdum lobortis", LineThree = "Habitant inceptos interdum lobortis nascetur pharetra placerat pulvinar sagittis senectus sociosqu suscipit torquent" });*/

            this.News.Items.Add(new NewsViewModel() { Title = "runtime one", Description = "Maecenas praesent accumsan bibendum", Id = "1" });
            this.News.Items.Add(new NewsViewModel() { Title = "runtime two", Description = "Dictumst eleifend facilisi faucibus", Id = "2" });
            this.News.Items.Add(new NewsViewModel() { Title = "runtime three", Description = "Habitant inceptos interdum lobortis", Id = "3" });

            this.IsDataLoaded = true;
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
    }
}