﻿using System;
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

namespace Donor.Controls
{
    public partial class MonthCalendar : UserControl
    {
        public MonthCalendar()
        {
            InitializeComponent();
        }

        public DateTime Date { get; set; }
        public ObservableCollection<EventViewModel> Items { get; set; }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            this.CalendarDays.Children.Clear();
            Date = DateTime.Now;
            DateTime FirstDayPrev = new DateTime(DateTime.Now.AddMonths(-1).Year, DateTime.Now.AddMonths(-1).Month, 1);
            DateTime FirstDay = new DateTime(Date.Year, Date.Month, 1);
            int daysbefore = (int)FirstDay.DayOfWeek;

            for (var i = (DateTime.DaysInMonth(FirstDayPrev.Year, FirstDayPrev.Month) - daysbefore); i < (DateTime.DaysInMonth(FirstDayPrev.Year, FirstDayPrev.Month) - 1); i++)
            {
                DayInCalendarControl day = new DayInCalendarControl();
                day.ImagePath = "/images/x.png";
                day.DayNumber = i.ToString();
                day.TextColor = new SolidColorBrush(Colors.Gray);
                this.CalendarDays.Children.Add(day);
            };

            for (var i = 1; i <= DateTime.DaysInMonth(Date.Year, Date.Month); i++)
            {
                DayInCalendarControl day2 = new DayInCalendarControl();
                day2.ImagePath = null;
                day2.Tap += ClickDay;
                day2.EventDay = App.ViewModel.Events.Items.FirstOrDefault(a => a.Date == new DateTime(Date.Year, Date.Month, i));
                if ((day2.EventDay != null) && (day2.EventDay.Type=="Праздник"))
                {
                    day2.BgColor = new SolidColorBrush(Colors.DarkGray);
                };
                day2.MonthNumber = Date.Month;
                day2.YearNumber = Date.Year;
                day2.DayNumber = i.ToString();
                day2.TextColor = new SolidColorBrush(Colors.White);
                this.CalendarDays.Children.Add(day2);
            };    
        }

        private void ClickDay(object sender, Microsoft.Phone.Controls.GestureEventArgs e)
        {
            //(Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventEditPage.xaml", UriKind.Relative));
        }
    }
}