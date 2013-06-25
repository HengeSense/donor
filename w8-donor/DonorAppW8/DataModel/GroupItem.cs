using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Windows.UI.Xaml.Media;
using Windows.UI.Xaml.Media.Imaging;

namespace DonorAppW8.DataModel
{

    public class RegionItem : ViewModelBase
    {
        public RegionItem()
        {
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
        public string UniqueId = "";
    }

    public class HelpItem : ViewModelBase
    {
        public HelpItem()
        {
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

        private ImageSource _image = null;

        private string _imagePath = string.Empty;
        public string ImagePath
        {
            get { return this._imagePath; }
            set
            {
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

        public string UniqueId = "";
    }

    public class RssDataGroup: ViewModelBase
    {
        public RssDataGroup()
        {
        }
        public int itemsCount = 6;

        private int _order = 0;
        public int Order
        {
            get
            {
                return _order;
            }
            set
            {
                if (_order != value)
                {
                    _order = value;
                };
            }
        }

        private string _title = "";
        public string Title {
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
        public string UniqueId = "";

        private ImageSource _image = null;

        private string _imagePath = string.Empty;
        public string ImagePath
        {
            get { return this._imagePath; }
            set
            {
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

        private ObservableCollection<object> _items = new ObservableCollection<object>();
        public ObservableCollection<object> Items
        {
            get { return this._items; }
            set
            {
                this._items = value;
                RaisePropertyChanged("Items");
                RaisePropertyChanged("TopItems");
            }
        }

        private ObservableCollection<object> _topItem = new ObservableCollection<object>();
        public ObservableCollection<object> TopItems
        {
            get {
                _topItem = new ObservableCollection<object>();
                foreach (var item in this._items.Take(itemsCount)) {
                    _topItem.Add(item);
                };
                return _topItem; 
            }
        }
    }
}
