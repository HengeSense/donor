using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.ComponentModel;
using Microsoft.Phone.Controls;
using System.Windows.Media.Imaging;
using Donor.ViewModels;

namespace Donor.Controls
{
    public partial class DayInCalendarControl : UserControl, INotifyPropertyChanged
    {
        public DayInCalendarControl()
        {
            InitializeComponent();
            this.DataContext = this;

            var gl = GestureService.GetGestureListener(this.MainBorder);
            gl.Tap += new EventHandler<Microsoft.Phone.Controls.GestureEventArgs>(GestureListener_Tap);
        }

        private void GestureListener_Tap(object sender, Microsoft.Phone.Controls.GestureEventArgs e)
        {
            if (this.EventDay != null)
            {
                (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventPage.xaml?id=" + this.EventDay.Id, UriKind.Relative));
            }
            else
            {
                (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventEditPage.xaml?month=" + this.MonthNumber + "&day=" + this.DayNumber + "&year=" + this.YearNumber, UriKind.Relative));
            };
        }

        private string _imagePath;
        public string ImagePath
        {
            get
            {
                return _imagePath;
            }
            set
            {
                _imagePath = value;
                NotifyPropertyChanged("ImagePath");
            }
        }
        private string _dayNumber;
        public string DayNumber { 
            get
            {
                return _dayNumber;
            }
            set
            {
                _dayNumber = value;
                NotifyPropertyChanged("DayNumber");
            }
        }
        private int _monthNumber;
        public int MonthNumber
        {
            get
            {
                return _monthNumber;
            }
            set
            {
                _monthNumber = value;
                NotifyPropertyChanged("MonthNumber");
            }
        }
        private int _yearNumber;
        public int YearNumber
        {
            get
            {
                return _yearNumber;
            }
            set
            {
                _yearNumber = value;
                NotifyPropertyChanged("YearNumber");
            }
        }


        private Brush _textColor;
        public Brush TextColor
        {
            get
            {
                return _textColor;
            }
            set
            {
                _textColor = value;
                NotifyPropertyChanged("TextColor");
            }
        }

        private EventViewModel _eventDay;
        public EventViewModel EventDay
        {
            get
            {
                return _eventDay;
            }
            set
            {
                if (value != null)
                {
                    _eventDay = value;
                    this.ImagePath = _eventDay.Image;
                    NotifyPropertyChanged("EventDay");
                };
            }
        }

        private Brush _bgColor;
        public Brush BgColor
        {
            get
            {
                return _bgColor;
            }
            set
            {
                _bgColor = value;
                NotifyPropertyChanged("BgColor");
            }
        }

        public event EventHandler<Microsoft.Phone.Controls.GestureEventArgs> Tap;

        public event PropertyChangedEventHandler PropertyChanged;

        private void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }

    }
}
