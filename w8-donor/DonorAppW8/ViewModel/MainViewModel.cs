using DonorAppW8.DataModel;
using DonorAppW8.ViewModels;
using GalaSoft.MvvmLight;
using System.Collections.ObjectModel;

namespace DonorAppW8.ViewModel
{
    /// <summary>
    /// This class contains properties that the main View can data bind to.
    /// <para>
    /// Use the <strong>mvvminpc</strong> snippet to add bindable properties to this ViewModel.
    /// </para>
    /// <para>
    /// You can also use Blend to data bind with the tool's support.
    /// </para>
    /// <para>
    /// See http://www.galasoft.ch/mvvm
    /// </para>
    /// </summary>
    public class MainViewModel : ViewModelBase
    {
        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel()
        {
            News = new NewsListViewModel();
            Stations = new StationsListViewModel();
            Ads = new AdsListViewModel();

            this.IsDataStartLoaded = false;
            this.FbId = "";
            this.FbToken = "";
        }
        private ObservableCollection<RssDataGroup> _groups = new ObservableCollection<RssDataGroup>();
        public ObservableCollection<RssDataGroup> Groups
        {
            set
            {
                _groups = value;
                RaisePropertyChanged("Groups");
            }
            get
            {
                return _groups;
            }
        }

        public void LoadData()
        {
            if (IsDataLoaded == false)
            {
                ViewModelLocator.MainStatic.News.LoadNews();
                ViewModelLocator.MainStatic.Ads.LoadAds();
                ViewModelLocator.MainStatic.Stations.LoadStations();
                this.IsDataLoaded = true;
            };
        }

        //PeriodicTask periodicTask;
        //string periodicTaskName = "PeriodicAgent";

        private bool _eventChanging = false;
        public bool EventChanging
        {
            get
            {
                return _eventChanging;
            }
            set
            {
                _eventChanging = value;
                RaisePropertyChanged("EventChanging");
            }
        }

        private bool _loading = false;
        public bool Loading
        {
            get
            {
                return _loading;
            }
            set
            {
                _loading = value;
                RaisePropertyChanged("Loading");
            }
        }

        public NewsListViewModel News { get; set; }
        public AdsListViewModel Ads { get; set; }
        public StationsListViewModel Stations { get; set; }

        public bool IsSettings = false;

        public string FbId = "";
        public string FbToken = "";

        public bool IsDataLoaded
        {
            get;
            set;
        }

        public bool IsDataStartLoaded
        {
            get;
            set;
        }
    }
}