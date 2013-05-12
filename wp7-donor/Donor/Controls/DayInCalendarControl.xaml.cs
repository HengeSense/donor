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

            if (EventDay == null)
            {
                this.EditContextMenu.Visibility = Visibility.Collapsed;
                this.DeleteContextMenu.Visibility = Visibility.Collapsed;
                this.AddContextMenu.Visibility = Visibility.Collapsed;
            }
            else
            {
                this.EditContextMenu.Visibility = Visibility.Visible;
                this.DeleteContextMenu.Visibility = Visibility.Visible;
                this.AddContextMenu.Visibility = Visibility.Collapsed;
            };            
        }

        //public DaysModel DayData { get; set; }

        public bool deleted;
        public bool checkedEvent = false;
        private void GestureListener_Tap(object sender, Microsoft.Phone.Controls.GestureEventArgs e)
        {
            if ((deleted == false) || (checkedEvent == false))
            {
                if (this.EventDay != null)
                {
                    if (PossibleBloodGive == 1)
                    {
                        (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/Pages/Events/EventEditPage.xaml?id=" + this.EventDay.Id, UriKind.Relative));
                     }
                    else
                    {
                        if (PossibleBloodGive > 1)
                        {
                            (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/Pages/Events/EventEditPage.xaml?month=" + this.MonthNumber.ToString() + "&day=" + this.DayNumber.ToString() + "&year=" + this.YearNumber.ToString(), UriKind.Relative));
                        };
                    };

                    if (PossibleBloodGive == 0)
                    {
                        (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/Pages/Events/EventPage.xaml?id=" + this.EventDay.Id, UriKind.Relative));
                    };
                }
                else
                {
                    (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/Pages/Events/EventEditPage.xaml?month=" + this.MonthNumber.ToString() + "&day=" + this.DayNumber.ToString() + "&year=" + this.YearNumber.ToString(), UriKind.Relative));
                };
                checkedEvent = false;
            }
            else
            {
                deleted = false;
                checkedEvent = false;
            };
        }

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
                        this.EditContextMenu.Visibility = Visibility.Visible;
                        this.DeleteContextMenu.Visibility = Visibility.Visible;
                        this.AddContextMenu.Visibility = Visibility.Collapsed;
                        if (_eventDay.Finished == false)
                        {
                            this.FinishedContextMenu.Visibility = Visibility.Visible;
                        };
                    }
                    else
                    {
                        this.EditContextMenu.Visibility = Visibility.Collapsed;
                        this.DeleteContextMenu.Visibility = Visibility.Collapsed;
                        this.AddContextMenu.Visibility = Visibility.Collapsed;
                        this.ContextMenu.Visibility = Visibility.Collapsed;
                        this.FinishedContextMenu.Visibility = Visibility.Collapsed;
                    };

                    this.ImagePath = _eventDay.Image;
                    NotifyPropertyChanged("EventDay");
                }
                else
                {
                    this.EditContextMenu.Visibility = Visibility.Collapsed;
                    this.DeleteContextMenu.Visibility = Visibility.Collapsed;
                    this.FinishedContextMenu.Visibility = Visibility.Collapsed;
                    this.AddContextMenu.Visibility = Visibility.Visible;
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
                NotifyPropertyChanged("BorderColor");
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
		
        private Brush _currentColor;
        public Brush CurrentColor
        {
            get
            {
                return _currentColor;
            }
            set
            {
                if (value != null) {
                _currentColor = value;
                NotifyPropertyChanged("CurrentColor");
                };
            }
        }

        public bool Inactive { get; set; }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String info)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(info));
            }
        }

        private void AddContextMenu_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (EventDay == null)
                {
                    //(Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/Pages/Events/EventEditPage.xaml?month=" + this.MonthNumber + "&day=" + this.DayNumber + "&year=" + this.YearNumber, UriKind.Relative));
                };
            }
            catch { };
        }

        private void EditContextMenu_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (EventDay != null)
                {
                    (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/Pages/Events/EventPage.xaml?id=" + this.EventDay.Id, UriKind.Relative));
                };
            }
            catch
            {
            };
        }
        
        private void DeleteContextMenu_Click(object sender, RoutedEventArgs e)
        {
            //delete event
            try
            {
                if (EventDay != null)
                {
                    ViewModelLocator.MainStatic.Events.DeleteEvent(EventDay);
                    //ViewModelLocator.MainStatic.Events.Items.Remove(EventDay);
                    EventDay = null;
                    this.ImagePath = "";
                    deleted = true;
                }
            }
            catch { 
            };
        }

        private void FinishedContextMenu_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                if (EventDay != null)
                {
                    ViewModelLocator.MainStatic.Events.Items.Remove(EventDay);
                    EventDay.Finished = true;
                    ViewModelLocator.MainStatic.Events.Items.Add(EventDay);
                    checkedEvent = true;
                }
            }
            catch
            {
            };
        }

        public int PossibleBloodGive;


        void initializePage() {
            try
            {
                this.DayImageRB.Visibility = Visibility.Visible;

                PossibleBloodGive = 0;
                if (EventDayList.Count()>0)
                {
                    foreach (var dayitem in EventDayList)
                    {
                        Uri uri = new Uri(dayitem.SmallImage, UriKind.Relative);
                        ImageSource imgSource = new BitmapImage(uri);
                        if ((dayitem.Type == "PossibleBloodGive"))
                        {
                            if (dayitem.GiveType != "Гранулоциты")
                            {
                                switch (PossibleBloodGive)
                                {
                                    case 0: this.DayImageRT.Source = imgSource; break;
                                    case 1: this.DayImageRT1.Source = imgSource; break;
                                    case 2: this.DayImageRT2.Source = imgSource; break;
                                    case 3: 
                                        break;
                                    default: this.DayImageRT.Source = imgSource; break;
                                };
                            };
                            PossibleBloodGive++;
                        }
                        else
                        {
                            if ((dayitem.Finished == true) && (dayitem.Type!="0"))
                            {
                                this.DayImageRB.Source = imgSource;
                            }
                            else
                            {
                                this.DayImageLB.Source = imgSource;
                            };
                        };
                    };
                    if (PossibleBloodGive > 2)
                    {
                    };
                        
                };
            }
            catch { };
        }

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            initializePage();
        }

    }
}
