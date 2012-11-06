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
using System.Globalization;
using System.Windows.Navigation;
using Microsoft.Phone.Controls;
using System.Windows.Media.Imaging;
using System.Collections.ObjectModel;
using Donor.ViewModels;
using System.ComponentModel;

namespace Donor.Controls
{
    public partial class MonthCalendar : UserControl
    {
        public MonthCalendar()
        {
            InitializeComponent();

            UpdateCalendar();
        }

        //List<DayInCalendarControl> DaysList = new List<DayInCalendarControl>();
        
        public void UpdateCalendar() {

            //this.CalendarDays.ItemsSource = null;

            var bw = new BackgroundWorker();
            bw.DoWork += delegate
            {

            int dayscount = 0;
            this.Items = App.ViewModel.Events.ThisMonthItems;
            List<DaysModel> DaysList = new List<DaysModel>();
            DaysList = new List<DaysModel>();

            Date = App.ViewModel.Events.CurrentMonth;

            DateTime Date2 = Date;
            DateTime FirstDayPrev = new DateTime(Date2.AddMonths(-1).Year, Date2.AddMonths(-1).Month, 1);
            DateTime FirstDay = new DateTime(Date.Year, Date.Month, 1);
            int daysbefore = (int)FirstDay.DayOfWeek;

            for (var i = (DateTime.DaysInMonth(FirstDayPrev.Year, FirstDayPrev.Month) - daysbefore + 2); i < (DateTime.DaysInMonth(FirstDayPrev.Year, FirstDayPrev.Month) +1); i++)
            {
                DaysModel day = new DaysModel();

                    day.DayNumber = i.ToString();
                    day.MonthNumber = FirstDayPrev.Month;
                    day.YearNumber = FirstDayPrev.Year;
                    day.Inactive = false;
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        day.TextColor = new SolidColorBrush(Colors.Gray);
                    });

                dayscount++;
                DaysList.Add(day);
            };

            for (var i = 1; i <= DateTime.DaysInMonth(Date.Year, Date.Month); i++)
            {
                DaysModel day2 = new DaysModel();
               
                day2.EventDay = this.Items.FirstOrDefault(a => a.Date == new DateTime(Date.Year, Date.Month, i));
                day2.EventDayList = this.Items.Where(a => a.Date == new DateTime(Date.Year, Date.Month, i)).ToList();

                if (day2.EventDay != null) {
                    day2.ImagePath = day2.EventDay.SmallImage.ToString();
                };

                    /// show border for current day
                    if ((DateTime.Now.Day == i) && (Date.Month == DateTime.Now.Month))
                    {
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            day2.CurrentColor = new SolidColorBrush(new Color() { A = 1, B = 238, G = 31, R = 173 });
                            day2.BorderColor = new SolidColorBrush(Colors.Red);
                        });
                    };

                    day2.MonthNumber = Date.Month;
                    day2.YearNumber = Date.Year;
                    day2.DayNumber = i.ToString();
                    Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        day2.TextColor = new SolidColorBrush(Colors.Black);
                    });
                    day2.Inactive = false;

                    if ((day2.EventDay != null) && (day2.EventDay.Type == "Праздник"))
                    {
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            Color darkred = new Color() { A = 255, B = 111, G = 63, R = 209 };
                            day2.TextColor = new SolidColorBrush(darkred);
                        });
                    };

                    day2.PossibleBloodGive = 0;
                    if (day2.EventDayList.Count() > 0)
                    {
                        foreach (var dayitem in day2.EventDayList)
                        {
                            Deployment.Current.Dispatcher.BeginInvoke(() =>
                            {
                            Uri uri = new Uri(dayitem.SmallImage, UriKind.Relative);
                            ImageSource imgSource = new BitmapImage(uri);
                            
                            if ((dayitem.Type == "PossibleBloodGive"))
                            {
                                if (dayitem.GiveType != "Гранулоциты")
                                {
                                    switch (day2.PossibleBloodGive)
                                    {
                                        case 0: day2.DayImageRT = imgSource; break;
                                        case 1: day2.DayImageRT1 = imgSource; break;
                                        case 2: day2.DayImageRT2 = imgSource; break;
                                        case 3:
                                            break;
                                        default: day2.DayImageRT = imgSource; break;
                                    };
                                };
                                day2.PossibleBloodGive++;
                            }
                            else
                            {
                                if (dayitem.Finished == true)
                                {
                                    day2.DayImageRB = imgSource;
                                }
                                else
                                {
                                    day2.DayImageLB = imgSource;
                                };
                            };
                            });
                        }                        
                        if (day2.PossibleBloodGive > 2)
                        {
                        };
                    };


                dayscount++;
                DaysList.Add(day2);
            };

            int dayscount2 = (int)(dayscount % 7);
            if (dayscount2 != 0)
            {
                for (var i = 1; i <= (7-dayscount2); i++)
                {
                    DaysModel day3 = new DaysModel();
                    day3.ImagePath = "";


                        day3.DayNumber = i.ToString();
                        day3.MonthNumber = Date.AddMonths(1).Month;
                        day3.YearNumber = FirstDayPrev.AddMonths(1).Year;
                        day3.Inactive = true;
                        Deployment.Current.Dispatcher.BeginInvoke(() =>
                        {
                            day3.TextColor = new SolidColorBrush(Colors.Gray);
                        });
                        DaysList.Add(day3);
                };
            };



            Deployment.Current.Dispatcher.BeginInvoke(() =>
                {
                    this.CalendarDays.ItemsSource = DaysList;
                });            
            };

            bw.RunWorkerAsync();  
        }

        public DateTime Date { get; set; }
        public List<EventViewModel> Items { get; set; }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            //UpdateCalendar();
        }

        private void CalendarDays_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            DaysModel day = (DaysModel)(sender as ListBox).SelectedItem;
            if ((day.deleted == false) || (day.checkedEvent == false))
            {
                if (day.EventDay != null)
                {
                    if (day.PossibleBloodGive == 1)
                    {
                        (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventEditPage.xaml?id=" + day.EventDay.Id, UriKind.Relative));
                    }
                    else
                    {
                        if (day.PossibleBloodGive > 1)
                        {
                            (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventEditPage.xaml?month=" + day.MonthNumber.ToString() + "&day=" + day.DayNumber.ToString() + "&year=" + day.YearNumber.ToString(), UriKind.Relative));
                        };
                    };

                    if (day.PossibleBloodGive == 0)
                    {
                        (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventPage.xaml?id=" + day.EventDay.Id, UriKind.Relative));
                    };
                }
                else
                {
                    (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventEditPage.xaml?month=" + day.MonthNumber.ToString() + "&day=" + day.DayNumber.ToString() + "&year=" + day.YearNumber.ToString(), UriKind.Relative));
                };
                day.checkedEvent = false;
            }
            else
            {
                day.deleted = false;
                day.checkedEvent = false;
            };
        }

        private void CalendarDays_Loaded(object sender, RoutedEventArgs e)
        {
            foreach (var item in (sender as ListBox).Items)
            {
            try
            {
            }
            catch { };
        };
        }
    }
}
