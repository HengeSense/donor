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

        public int previndex = 2;

        public CalendarPage()
        {
            InitializeComponent();
            DataContext = App.ViewModel;

            try
            {
                this.Monthes.SelectedIndex = 2;
            }
            catch { };
            try
            {
                //this.Monthes.IsLocked = true;
            }
            catch { };

            this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
            this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

            this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;

            try
            {
                this.Monthes.IsLocked = true;
            }
            catch { };
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            var gl = GestureService.GetGestureListener(this.Monthes);
            //l.Flick += new EventHandler<Microsoft.Phone.Controls.FlickGestureEventArgs>(GestureListener_Flick);
        }

        bool right = false;
        bool left = false;

        private void GestureListener_Flick(object sender, Microsoft.Phone.Controls.FlickGestureEventArgs e)
        {
            //this.Monthes.IsLocked = true;
            this.Monthes.IsLocked = true;

            if (e.Direction == System.Windows.Controls.Orientation.Horizontal)
            {
                if (e.HorizontalVelocity < 0)
                {
                    try
                    {
                        right = true;
                        left = false;
                    }
                    catch {
                        right = false;
                        left = false;
                    };
                }
                else
                {
                    try
                    {
                        right = false;
                        left = true;
                    }
                    catch {
                        right = false;
                        left = false;
                    };
                };
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

            this.Monthes.IsLocked = false;
        }

        private void GestureListener_Flick1(object sender, Microsoft.Phone.Controls.FlickGestureEventArgs e)
        {
            this.Monthes.IsLocked = true;

            if (e.Direction == System.Windows.Controls.Orientation.Horizontal)
            {
                if (e.HorizontalVelocity < 0)
                {
                    try
                    {
                            App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(1);
                            int itemindex = 1;
                            itemindex = (sender as LockablePivot).SelectedIndex;
                            /*switch (itemindex)
                            {
                                case 0:
                                    this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                    this.EventsList.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                    this.EventsListNext.ItemsSource = App.ViewModel.Events.PrevMonthItems;

                                    this.NextMonth.Header = App.ViewModel.Events.PrevMonthString;
                                    this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                                    this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                    break;*/
                                //case 1:
                                    this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                    this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                    this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

                                    this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                                    this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                    this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                                    //break;
                                /*case 2:
                                    this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                    this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                    this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                                    this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                    this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                                    this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                                    break;
                                default:
                                    break;
                            };*/
                        }
                        catch { };
                }
                else
                {
                    try
                    {
                            App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(-1);
                            int itemindex = 1;
                            itemindex = (sender as LockablePivot).SelectedIndex;
                            /*switch (itemindex)
                            {
                                case 0:
                                    this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                    this.EventsList.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                    this.EventsListNext.ItemsSource = App.ViewModel.Events.PrevMonthItems;

                                    this.NextMonth.Header = App.ViewModel.Events.PrevMonthString;
                                    this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                                    this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                    break;
                                case 1:*/
                                    this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                    this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                                    this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

                                    this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                                    this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                    this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                                    //break;
                                /*case 2:
                                    this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                                    this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                                    this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                                    this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                                    this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                                    this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                                    break;
                                default:
                                    break;
                            };*/
                    }
                    catch { };
                };
            }
            else
            {
                if (e.VerticalVelocity < 0)
                {
                    // flick up
                }
                else
                {
                    // flick down
                }
            };

            /*if (e.Direction == System.Windows.Controls.Orientation.Horizontal)
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
            };*/
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
            if (App.ViewModel.Events.CurrentMonth == null) {
                App.ViewModel.Events.CurrentMonth = DateTime.Now;
            };
        }

        private void Monthes_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                //App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(1);
                int itemindex = 2;
                itemindex = (sender as LockablePivot).SelectedIndex;

                if (itemindex == previndex)
                {
                    return;
                }

               bool notback = ((previndex!=0) || (itemindex!=4));
               if (((itemindex > previndex) || ((itemindex == 0) && (previndex == 4))) && notback)
                {
                    App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(1);
                    previndex = itemindex;
                    switch (itemindex)
                    {
                        case 0:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.PrevMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.CurrentMonthString;
                            break;
                        case 1:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            break;
                        case 2:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonth2String;                            

                            break;
                        case 3:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.PrevMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            break;
                        case 4:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;


                            this.NextMonth2.Header = App.ViewModel.Events.CurrentMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.PrevMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.PrevMonth2.Header = App.ViewModel.Events.NextMonthString;
                            break;
                        default:
                            break;
                    };
                }
                else
                {
                    App.ViewModel.Events.CurrentMonth = App.ViewModel.Events.CurrentMonth.AddMonths(-1);
                    previndex = itemindex;
                    switch (itemindex)
                    {
                        case 0:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.PrevMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.CurrentMonthString;
                            break;
                        case 1:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            break;
                        case 2:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonth2String;

                            break;
                        case 3:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.PrevMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            break;
                        case 4:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.NextMonthItems;
                            this.EventsList.ItemsSource = App.ViewModel.Events.PrevMonthItems;
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;


                            this.NextMonth2.Header = App.ViewModel.Events.CurrentMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.PrevMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.PrevMonth2.Header = App.ViewModel.Events.NextMonthString;
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