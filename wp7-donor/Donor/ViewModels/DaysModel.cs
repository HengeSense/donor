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
using System.ComponentModel;
using System.Collections.Generic;

namespace Donor.ViewModels
{
    public partial class DaysModel // : INotifyPropertyChanged
    {
        public DaysModel()
        {
            if (EventDay == null)
            {
            }
            else
            {
            };
        }

        public bool deleted;
        public bool checkedEvent = false;

        private string _imagePath = "";
        public string ImagePath
        {
            get
            {
                return _imagePath;
            }
            set
            {
                _imagePath = value;
                //NotifyPropertyChanged("ImagePath");
            }
        }
        private string _dayNumber;
        public string DayNumber
        {
            get
            {
                return _dayNumber;
            }
            set
            {
                _dayNumber = value;
                //NotifyPropertyChanged("DayNumber");
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
                //NotifyPropertyChanged("MonthNumber");
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
                //NotifyPropertyChanged("YearNumber");
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
                //NotifyPropertyChanged("TextColor");
            }
        }

        public List<EventViewModel> EventDayList
        {
            get;
            set;
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

                    if ((_eventDay.Type != "Праздник") && (_eventDay.Type != "2"))
                    {
                        if (_eventDay.Finished == false)
                        {
                        };
                    }
                    else
                    {
                    };

                    this.ImagePath = _eventDay.Image;
                    //NotifyPropertyChanged("EventDay");
                }
                else
                {
                };
            }
        }

        private Brush _borderColor;
        public Brush BorderColor
        {
            get
            {
                return _borderColor;
            }
            set
            {
                _borderColor = value;
                //NotifyPropertyChanged("BorderColor");
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
                //NotifyPropertyChanged("BgColor");
            }
        }

        private Brush _currentColor;
        public Brush CurrentColor
        {
            get
            {
                return _currentColor;
            }
            set
            {
                if (value != null)
                {
                    _currentColor = value;
                    //NotifyPropertyChanged("CurrentColor");
                };
            }
        }

        public bool Inactive { get; set; }

        /*public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }*/
        
        public int PossibleBloodGive;


        public ImageSource DayImageRT { get; set; }

        public ImageSource DayImageRT1 { get; set; }

        public ImageSource DayImageRT2 { get; set; }



        public ImageSource DayImageRB { get; set; }

        public ImageSource DayImageLB { get; set; }
    }
}
