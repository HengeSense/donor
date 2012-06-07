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
using MSPToolkit.Utilities;
using Newtonsoft.Json;
using System.Reflection;
using System.IO;
using System.Windows.Resources;

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

            News = new NewsListViewModel();
            Events = new EventsListViewModel();

            User = new DonorUser();

            this.LoadFromIsolatedStorage();
        }

        /// <summary>
        /// A collection for ItemViewModel objects.
        /// </summary>
        public ObservableCollection<ItemViewModel> Items { get; private set; }

        public NewsListViewModel News { get; set; }
        public EventsListViewModel Events { get; set; }
        public DonorUser User { get; set; }

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

            try
            {
                var user = new DonorUser { UserName = "Test1", Password = "pass" };
                //this.Parse.Objects.Save(user);
            }
            catch
            {
            };
           
            if (this.Events.Items.Count == 0)
            {
                StreamResourceInfo info = Application.GetResourceStream(new Uri("/Donor;component/holidays.json", UriKind.Relative));
                StreamReader reader = new StreamReader(info.Stream, System.Text.Encoding.Unicode);
                string json ="";
                json = reader.ReadToEnd();
                this.Events.Items = JsonConvert.DeserializeObject<ObservableCollection<EventViewModel>>(json);
            };

            if (this.News.Items.Count == 0)
            {
                this.News.Items.Add(new NewsViewModel() { Title = "runtime one", Description = "Maecenas praesent accumsan bibendum", Id = "1" });
                this.News.Items.Add(new NewsViewModel() { Title = "runtime two", Description = "Dictumst eleifend facilisi faucibus", Id = "2" });
                this.News.Items.Add(new NewsViewModel() { Title = "runtime three", Description = "Habitant inceptos interdum lobortis", Id = "3" });
            };

            this.IsDataLoaded = true;
        }

        /// <summary>
        /// Save data to isolated storage to use when there is no network and faster show data in app
        /// </summary>
        public void SaveToIsolatedStorage()
        {
            //var bw = new BackgroundWorker();
            //bw.DoWork += delegate
            //{
            try
            {
                if (this.Events.Items.Count > 0)
                {
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<EventViewModel>>(this.Events.Items, "events.xml");
                };
            }
            catch
            {
            };
            try
            {
                if (this.News.Items.Count > 0)
                {
                    IsolatedStorageHelper.SaveSerializableObject<ObservableCollection<NewsViewModel>>(this.News.Items, "news.xml");
                };
            }
            catch
            {
            };
            //};
            //bw.RunWorkerAsync();  
        }
        /// <summary>
        /// 
        /// </summary>
        public void LoadFromIsolatedStorage()
        {
            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {

                try
                {
                    this.Events.Items = new ObservableCollection<EventViewModel>();
                    this.Events.Items = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<EventViewModel>>("events.xml");
                    
                    //NotifyPropertyChanged("Events");
                }
                catch //(System.IO.FileNotFoundException)
                {
                    this.Events.Items = new ObservableCollection<EventViewModel>();
                }
                try
                {
                    this.News.Items = new ObservableCollection<NewsViewModel>();
                    this.News.Items = IsolatedStorageHelper.LoadSerializableObject<ObservableCollection<NewsViewModel>>("news.xml");
                }
                catch //(System.IO.FileNotFoundException)
                {
                    this.News.Items = new ObservableCollection<NewsViewModel>();
                };
            };
            bw.RunWorkerAsync();
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