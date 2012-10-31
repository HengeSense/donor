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
            //this.Calendar1.Items = App.ViewModel.Events.Items;

            this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[App.ViewModel.Events.CurrentMonth.Month - 1];
            this.ApplicationTitle.Text = App.ViewModel.Events.CurrentMonth.Year.ToString();

            var gl = GestureService.GetGestureListener(this.Calendar1);
            gl.Flick += new EventHandler<Microsoft.Phone.Controls.FlickGestureEventArgs>(GestureListener_Flick);
        }

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[App.ViewModel.Events.CurrentMonth.Month - 1];
            this.ApplicationTitle.Text = App.ViewModel.Events.CurrentMonth.Year.ToString();
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            
        }

        private void GestureListener_Flick(object sender, Microsoft.Phone.Controls.FlickGestureEventArgs e)
        {
            if (e.Direction == System.Windows.Controls.Orientation.Vertical)
            {
                if (e.VerticalVelocity < 0)
                {
                   
                    try
                    {
                        //this.fadeOut.Begin();
                        App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(1);

                        this.Calendar1.UpdateCalendar();

                        this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[App.ViewModel.Events.CurrentMonth.Month - 1];
                        this.ApplicationTitle.Text = App.ViewModel.Events.CurrentMonth.Year.ToString();
                    }
                    catch
                    {
                    };
                }
                else
                {
                    try
                    {
                        //this.fadeOut.Begin();
                        App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(-1);

                        this.Calendar1.UpdateCalendar();
                        this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[App.ViewModel.Events.CurrentMonth.Month - 1];
                        this.ApplicationTitle.Text = App.ViewModel.Events.CurrentMonth.Year.ToString();
                    }
                    catch
                    {
                    };
                };
                //this.fadeIn.Begin();
            }
            else
            {
                if (e.VerticalVelocity < 0)
                {
                }
                else
                {
                }
            };
        }

        private void TodayButton_Click(object sender, EventArgs e)
        {
            try
            {
                App.ViewModel.Events.CurrentMonth = DateTime.Now;

                this.Calendar1.UpdateCalendar();
                this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[App.ViewModel.Events.CurrentMonth.Month - 1];
                this.ApplicationTitle.Text = App.ViewModel.Events.CurrentMonth.Year.ToString();
            }
            catch { };
        }

        private void AddEventButton_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/EventEditPage.xaml", UriKind.Relative));
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            this.fadeOut.Begin();
        }

        private void Button_Click_1(object sender, RoutedEventArgs e)
        {
            this.fadeIn.Begin();
        }


    }
}