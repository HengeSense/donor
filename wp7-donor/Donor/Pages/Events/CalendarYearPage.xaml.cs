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
using System.Windows.Media.Imaging;
using System.IO.IsolatedStorage;
using System.IO;
using System.Globalization;

namespace Donor
{
    public partial class CalendarPage : PhoneApplicationPage
    {

        public int previndex = 2;

        public CalendarPage()
        {
            InitializeComponent();
            DataContext = ViewModelLocator.MainStatic;

            try
            {
                this.Monthes.SelectedIndex = 2;
            }
            catch { };

            try
            {
                ViewModelLocator.MainStatic.EventsChangedCalendar += new MainViewModel.EventsChangedCalendarEventHandler(this.EventsChangedCalendar);

                this.EventsListPrev.ItemsSource = null;
                this.EventsList.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;
                this.EventsList.DataContext = ViewModelLocator.MainStatic.Events;
                this.EventsListNext.ItemsSource = null;

                this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
            }
            catch { };

            try
            {
                this.Monthes.IsLocked = true;
            }
            catch { };
        }

        private void EventsChangedCalendar(object sender, EventArgs e)
        {
            try
            {
                if (this.Monthes.SelectedIndex != previndex)
                {
                    Microsoft.Phone.Controls.PivotItemEventArgs arg = null;
                    this.Monthes_LoadedPivotItem(this.Monthes, arg);
                }
                else
                {
                    this.EventsListPrev.ItemsSource = null;
                    this.EventsList.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;
                    this.EventsList.DataContext = ViewModelLocator.MainStatic.Events;
                    this.EventsListNext.ItemsSource = null;

                    this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                    this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                    this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                };
            }
            catch { };
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                //DateTime date = ViewModelLocator.MainStatic.Events.PossibleGiveBlood("Тромбоциты");
                this.Monthes.Title = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                previndex = 2;
                this.Monthes.SelectedIndex = 2;

                this.EventsList2Prev.ItemsSource = null;
                this.EventsListPrev.ItemsSource = null;
                this.EventsList.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;
                this.EventsListNext.ItemsSource = null;
                this.EventsListNext2.ItemsSource = null;

                this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
            }
            catch { };
        }


        private void EventsList_Loaded(object sender, RoutedEventArgs e)
        {

        }

        private void EventsList_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as EventViewModel).Id;
                if (((sender as ListBox).SelectedItem as EventViewModel).Type != "empty")
                {
                    if (((sender as ListBox).SelectedItem as EventViewModel).Type == "PossibleBloodGive")
                    {
                        NavigationService.Navigate(new Uri("/Pages/Events/EventEditPage.xaml?id=" + id, UriKind.Relative));
                    }
                    else
                    {
                        NavigationService.Navigate(new Uri("/Pages/Events/EventPage.xaml?id=" + id, UriKind.Relative));
                    };
                };
            }
            catch
            {
            }
        }

        private void MonthCalendarButton_Click(object sender, EventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/Pages/Events/CalendarMonthPage.xaml", UriKind.Relative));
            }
            catch { };
        }

        private void AddEventButton_Click(object sender, EventArgs e)
        {
            try
            {
                NavigationService.Navigate(new Uri("/Pages/Events/EventEditPage.xaml", UriKind.Relative));
            }
            catch { };
        }

        private void Pivot_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                if (ViewModelLocator.MainStatic.Events.CurrentMonth == null)
                {
                    ViewModelLocator.MainStatic.Events.CurrentMonth = DateTime.Now;
                };
            }
            catch { };
        }

        private void Monthes_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {

        }

        private void TodayButton_Click(object sender, EventArgs e)
        {
            try
            {
                previndex = 2;

                ViewModelLocator.MainStatic.Events.CurrentMonth = DateTime.Now;

                this.Monthes.Title = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                try
                {
                    this.Monthes.SelectedIndex = 2;
                }
                catch { };

                this.EventsListPrev.ItemsSource = ViewModelLocator.MainStatic.Events.PrevMonthItems;
                this.EventsList.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;
                this.EventsListNext.ItemsSource = ViewModelLocator.MainStatic.Events.NextMonthItems;

                this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
            }
            catch { };
        }

        private void EventsListNext2_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            try
            {
                string id = ((sender as ListBox).SelectedItem as EventViewModel).Id;
                if (((sender as ListBox).SelectedItem as EventViewModel).Type != "empty")
                {
                    if (((sender as ListBox).SelectedItem as EventViewModel).Type == "PossibleBloodGive")
                    {
                        NavigationService.Navigate(new Uri("/Pages/Events/EventEditPage.xaml?id=" + id, UriKind.Relative));
                    }
                    else
                    {
                        NavigationService.Navigate(new Uri("/Pages/Events/EventPage.xaml?id=" + id, UriKind.Relative));
                    };
                };
            }
            catch
            {
            }
        }

        private void Monthes_LoadedPivotItem(object sender, PivotItemEventArgs e)
        {
            try
            {
                //ViewModelLocator.MainStatic.Events.CurrentMonth = ViewModelLocator.MainStatic.Events.CurrentMonth.AddMonths(1);
                int itemindex = 2;
                itemindex = (sender as LockablePivot).SelectedIndex;

                if (itemindex == previndex)
                {
                    return;
                }

                bool notback = ((previndex != 0) || (itemindex != 4));
                if (((itemindex > previndex) || ((itemindex == 0) && (previndex == 4))) && notback)
                {
                    ViewModelLocator.MainStatic.Events.CurrentMonth = ViewModelLocator.MainStatic.Events.CurrentMonth.AddMonths(1);

                    this.Monthes.Title = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                    previndex = itemindex;
                    switch (itemindex)
                    {
                        case 0:
                            this.EventsListPrev.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsList2Prev.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            break;
                        case 1:
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsListPrev.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            break;
                        case 2:
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsListPrev.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsList.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;

                            break;
                        case 3:
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsListPrev.ItemsSource = null;
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsListNext.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            break;
                        case 4:
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsListPrev.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsListNext2.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            break;
                        default:
                            break;
                    };
                }
                else
                {
                    ViewModelLocator.MainStatic.Events.CurrentMonth = ViewModelLocator.MainStatic.Events.CurrentMonth.AddMonths(-1);

                    this.Monthes.Title = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                    previndex = itemindex;
                    switch (itemindex)
                    {
                        case 0:
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsListPrev.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsList2Prev.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            break;
                        case 1:
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsListPrev.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            break;
                        case 2:
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsListPrev.ItemsSource = null;
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsList.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;

                            break;
                        case 3:
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsListNext.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            break;
                        case 4:
                            this.EventsListNext2.ItemsSource = null;
                            this.EventsList.ItemsSource = null;
                            this.EventsList2Prev.ItemsSource = null;
                            this.EventsListNext.ItemsSource = null;
                            this.EventsListNext2.ItemsSource = ViewModelLocator.MainStatic.Events.ThisMonthItems;

                            this.NextMonth2.Header = ViewModelLocator.MainStatic.Events.CurrentMonthString;
                            this.NextMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonthString;
                            this.ThisMonth.Header = ViewModelLocator.MainStatic.Events.PrevMonth2String;
                            this.PrevMonth.Header = ViewModelLocator.MainStatic.Events.NextMonth2String;
                            this.PrevMonth2.Header = ViewModelLocator.MainStatic.Events.NextMonthString;
                            break;
                        default:
                            break;
                    };
                };
            }
            catch { };
        }


    }
}