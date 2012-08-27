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
using Donor.ViewModels;
using MSPToolkit;

namespace Donor
{
    public partial class CalendarPage : PhoneApplicationPage
    {
        public CalendarPage()
        {
            InitializeComponent();
            DataContext = App.ViewModel;
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            this.Monthes.SelectedIndex = 1;

            this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
            this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

            this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;

            var gl = GestureService.GetGestureListener(this.Monthes);
            gl.Flick += new EventHandler<Microsoft.Phone.Controls.FlickGestureEventArgs>(GestureListener_Flick);
        }

        private void GestureListener_Flick(object sender, Microsoft.Phone.Controls.FlickGestureEventArgs e)
        {
            if (e.Direction == System.Windows.Controls.Orientation.Horizontal)
            {
                try
                {
                    if (((e.Angle < 90) && (e.Angle >= 0)) || ((e.Angle > 270) && (e.Angle < 360)))
                    {
                        App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(-1);
                        int itemindex = 1;
                        itemindex = (sender as Pivot).SelectedIndex;
                        switch (itemindex)
                        {
                            case 0:
                                this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                this.EventsList.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                this.EventsListNext.ItemsSource = App.ViewModel.Events.PrevMonthItems;

                                this.NextMonth.Header = App.ViewModel.Events.PrevMonthString;
                                this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                                this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                break;
                            case 1:
                                this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

                                this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                                this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                                break;
                            case 2:
                                this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                                this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                                this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                                break;
                            default:
                                break;
                        };
                    };
                }
                catch { };

                try
                {
                    if (((e.Angle > 90) && (e.Angle < 270)))
                    {
                        App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(1);
                        int itemindex = 1;

                        itemindex = (sender as Pivot).SelectedIndex;
                        switch (itemindex)
                        {
                            case 0:
                                this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                this.EventsList.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                this.EventsListNext.ItemsSource = App.ViewModel.Events.PrevMonthItems;

                                this.NextMonth.Header = App.ViewModel.Events.PrevMonthString;
                                this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                                this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                break;
                            case 1:
                                this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

                                this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                                this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                                break;
                            case 2:
                                this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                                this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                                this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                                break;
                            default:
                                break;
                        };
                    };
                }
                catch { };
            };
        }

        private void EventsList_Loaded(object sender, RoutedEventArgs e)
        {

        }

        private void EventsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as EventViewModel).Id;
                NavigationService.Navigate(new Uri("/EventPage.xaml?id=" + id, UriKind.Relative));
            }
            catch
            {
            }
        }

        private void MonthCalendarButton_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/CalendarMonthPage.xaml", UriKind.Relative));
        }

        private void AddEventButton_Click(object sender, EventArgs e)
        {
            NavigationService.Navigate(new Uri("/EventEditPage.xaml", UriKind.Relative));
        }

        private void Pivot_Loaded(object sender, RoutedEventArgs e)
        {
            //App.ViewModel.Events.CurrentMonth = DateTime.Now;
            if (App.ViewModel.Events.CurrentMonth == null) {
                App.ViewModel.Events.CurrentMonth = DateTime.Now;
            };
        }

        private void Pivot_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
        }
    }
}