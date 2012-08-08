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
using Microsoft.Phone.Controls;
using System.Globalization;

namespace Donor
{
    public partial class CalendarMonthPage : PhoneApplicationPage
    {
        public CalendarMonthPage()
        {
            InitializeComponent();
            DataContext = App.ViewModel;
            this.Calendar1.Items = App.ViewModel.Events.Items;

            //show calendar control for current month, selected\changed for example in CalendarYearPage
            this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[App.ViewModel.Events.CurrentMonth.Month - 1];
            this.ApplicationTitle.Text = App.ViewModel.Events.CurrentMonth.Year.ToString();
        }

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {

        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
        }
    }
}