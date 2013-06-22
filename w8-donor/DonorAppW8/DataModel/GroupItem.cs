using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DonorAppW8.DataModel
{
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
