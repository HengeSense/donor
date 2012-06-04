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

namespace Donor.Controls
{
    public partial class MonthCalendar : UserControl
    {
        public MonthCalendar()
        {
            InitializeComponent();
        }

        public DateTime Date { get; set; }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {            
            Date = DateTime.Now;
            DateTime FirstDay = new DateTime(Date.Year, Date.Month, 1);
            int daysbefore = (int)FirstDay.DayOfWeek;

            for (var i = 1; i <= daysbefore; i++)
            {
                Border day = new Border();
                day.Background = new SolidColorBrush(Colors.Gray);
                day.BorderBrush = new SolidColorBrush(Colors.Gray);
                day.BorderThickness = new Thickness(2);
                TextBlock DayLabel1 = new TextBlock();
                day.Height = 60;
                day.Width = 60;
                //day.Tap += this.ClickDay;
                DayLabel1.Text = i.ToString();
                day.Child = DayLabel1;
                this.CalendarDays.Children.Add(day);
            };

            for (var i = 1; i<= DateTime.DaysInMonth(Date.Year, Date.Month); i++)
            {
                Border day = new Border();
                day.BorderBrush = new SolidColorBrush(Colors.LightGray);
                day.BorderThickness = new Thickness(2);
                TextBlock DayLabel1 = new TextBlock();
                day.Tap += this.ClickDay;
                day.Height = 60;
                day.Width = 60;
                DayLabel1.Text = i.ToString();
                day.Child = DayLabel1;
                this.CalendarDays.Children.Add(day);
            };            
        }

        private void ClickDay(object sender, System.Windows.Input.GestureEventArgs e)
        {
            (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventEditPage.xaml", UriKind.Relative));
            //throw new NotImplementedException();
        }

        /*private EventHandler<Microsoft.Phone.Controls.GestureEventArgs> ClickDay(Border day)
        {
            //throw new NotImplementedException();
            (Application.Current.RootVisual as PhoneApplicationFrame).Navigate(new Uri("/EventEditPage.xaml", UriKind.Relative));
        }*/
    }
}
