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

namespace Donor.Controls
{
    public partial class MonthCalendar : UserControl
    {
        public MonthCalendar()
        {
            InitializeComponent();

            UpdateCalendar();
        }

        public void UpdateCalendar() {
            int dayscount = 0;

            this.CalendarDays.Children.Clear();
            Date = App.ViewModel.Events.CurrentMonth;
            DateTime Date2 = Date;
            DateTime FirstDayPrev = new DateTime(Date2.AddMonths(-1).Year, Date2.AddMonths(-1).Month, 1);
            DateTime FirstDay = new DateTime(Date.Year, Date.Month, 1);
            int daysbefore = (int)FirstDay.DayOfWeek;

            /// Показываем минимальный период невозможности сдачи крови тем или иным образом
            int days = App.ViewModel.Events.DaysBefore();
            DateTime FromDays = new DateTime(1900,1,1);
            DateTime EndDays = new DateTime(1900,1,1);

            var nearestEvents = (from item in App.ViewModel.Events.UserItems
                                 where ((item.Type =="1") && (item.Date > DateTime.Now))
                                 orderby item.Date ascending
                                 select item).Take(1);
            //(item.Date <= DateTime.Now) && 
            if (nearestEvents.FirstOrDefault() != null)
            {
                FromDays = nearestEvents.FirstOrDefault().Date;
                EndDays = FromDays.AddDays(days);
            };


            for (var i = (DateTime.DaysInMonth(FirstDayPrev.Year, FirstDayPrev.Month) - daysbefore + 2); i < (DateTime.DaysInMonth(FirstDayPrev.Year, FirstDayPrev.Month) +1); i++)
            {
                DayInCalendarControl day = new DayInCalendarControl();
                day.ImagePath = ""; // "/images/x.png";

                day.DayNumber = i.ToString();
                day.MonthNumber = FirstDayPrev.Month;
                day.YearNumber = FirstDayPrev.Year;
                day.Inactive = false;
                day.TextColor = new SolidColorBrush(Colors.Gray);

                DateTime curDate = new DateTime(FirstDayPrev.Year, FirstDayPrev.Month, i);
                if (days != 0)
                {
                    if ((curDate <= EndDays) && (FromDays <= curDate))
                    {
                        //day.BgColor = new SolidColorBrush(Colors.Gray);
                        //day.TextColor = new SolidColorBrush(Colors.Black);
                        day.Inactive = true;
                    };
                };

                dayscount++;
                this.CalendarDays.Children.Add(day);
            };

            for (var i = 1; i <= DateTime.DaysInMonth(Date.Year, Date.Month); i++)
            {
                DayInCalendarControl day2 = new DayInCalendarControl();
                day2.ImagePath = null;
                day2.Tap += ClickDay;

				/// show border for current day
				if ((Date.Day == i) && (Date.Month == DateTime.Now.Month)) {
					day2.CurrentColor = new SolidColorBrush(new Color() { A = 1, B = 238, G = 31, R = 173 });
                    day2.BorderColor = new SolidColorBrush(Colors.Red);
				};
				
                day2.EventDay = App.ViewModel.Events.UserItems.FirstOrDefault(a => a.Date == new DateTime(Date.Year, Date.Month, i));

                if (day2.EventDay != null) {
                    day2.ImagePath = day2.EventDay.SmallImage.ToString();
                };

                day2.MonthNumber = Date.Month;
                day2.YearNumber = Date.Year;
                day2.DayNumber = i.ToString();
                day2.TextColor = new SolidColorBrush(Colors.Black);
                day2.Inactive = false;

                if ((day2.EventDay != null) && (day2.EventDay.Type == "Праздник"))
                {
                    Color darkred = new Color() { A = 255, B = 111, G = 63, R = 209 };
                    day2.TextColor = new SolidColorBrush(darkred);
                };

                DateTime curDate = new DateTime(Date.Year, Date.Month, i);
                if (days != 0)
                {
                    if ((curDate <= EndDays) && (FromDays <= curDate))
                    {
                        day2.Inactive = true;
                    };
                };

                dayscount++;
                this.CalendarDays.Children.Add(day2);
            };
            int dayscount2 = (int)(dayscount % 7);
            if (dayscount2 != 0)
            {
                for (var i = 1; i <= (7-dayscount2); i++)
                {
                    DayInCalendarControl day3 = new DayInCalendarControl();
                    day3.ImagePath = "";

                    day3.DayNumber = i.ToString();
                    day3.MonthNumber = FirstDayPrev.Month;
                    day3.YearNumber = FirstDayPrev.Year;
                    day3.Inactive = true;
                    day3.TextColor = new SolidColorBrush(Colors.Gray);
                    this.CalendarDays.Children.Add(day3);
                };
            };
        }

        public DateTime Date { get; set; }
        public ObservableCollection<EventViewModel> Items { get; set; }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {
            UpdateCalendar();
        }

        private void ClickDay(object sender, Microsoft.Phone.Controls.GestureEventArgs e)
        {
        }
    }
}
