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
            DataContext = App.ViewModel;

            try
            {
                this.Monthes.SelectedIndex = 2;
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
            this.Monthes.Title = App.ViewModel.Events.CurrentMonth.Year.ToString();

            previndex = 2;
            this.Monthes.SelectedIndex = 2;

            this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
            this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

             this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;



            //var bmp = new WriteableBitmap(173, 173);
            var logo = new BitmapImage(new Uri("icons/empty.png", UriKind.Relative));
            var img2 = new Image { Source = logo };

            logo.CreateOptions = BitmapCreateOptions.None;
            //logo.ImageOpened += (sender1, e1) =>
            //{
                var bmp = new WriteableBitmap(48, 48);
                var img = new Image { Source = logo };

                var Stack = new StackPanel();
                /*var bl2 = new TextBlock();
                bl2.Foreground = new SolidColorBrush(Colors.White);
                bl2.FontSize = 10.0;
                bl2.Text = DateTime.Now.Day.ToString();
                Stack.Children.Add(bl2);*/
                var bl = new TextBlock();
                bl.Foreground = new SolidColorBrush(Colors.White);
                bl.FontSize = 14.0;
                bl.TextWrapping = TextWrapping.Wrap;
                bl.HorizontalAlignment = System.Windows.HorizontalAlignment.Center;
                bl.Text = DateTime.Now.Day.ToString()+"\n"+CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[
DateTime.Now.Month - 1];

                Stack.Children.Add(bl);

                bmp.Render(Stack, null);

                var tt = new TranslateTransform();
                tt.X = 48 - logo.PixelWidth;
                tt.Y = 48 - logo.PixelHeight;

                bmp.Render(img, tt);
                bmp.Invalidate();

                using (var store = IsolatedStorageFile.GetUserStoreForApplication())
                {
                    var filename = "/Shared/ShellContent/testtile.jpg";
                    if (!store.DirectoryExists("/Shared/ShellContent"))
                    {
                        store.CreateDirectory("/Shared/ShellContent");
                    }
                    if (store.FileExists(filename))
                    {
                        //store.DeleteFile(filename);
                    }
                        //"/icons/testtile.jpg";
                    using (var st = store.OpenFile(filename, System.IO.FileMode.OpenOrCreate))
                    {
                        bmp.SaveJpeg(st, 48, 48, 0, 100);
                        //st.Close();
                    };

                    BitmapImage bi = new BitmapImage();
                    using (IsolatedStorageFileStream fileStream = store.OpenFile(filename, FileMode.Open, FileAccess.Read))
                    {
                        bi.SetSource(fileStream);
                    };

                    //this.TodayButton.IconUri = new Uri("isostore:" + filename, UriKind.Absolute);
                    //this.TodayButton.
                    //this.button1.IconUri = new Uri(filename, UriKind.RelativeOrAbsolute);
                    //Uri uri = new Uri("isostore:" + filename, UriKind.Absolute);
                    ImageSource imgSource = bi;

                    //this.Test.Source = imgSource;
                }
            //};
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

                    this.Monthes.Title = App.ViewModel.Events.CurrentMonth.Year.ToString();

                    previndex = itemindex;
                    switch (itemindex)
                    {
                        case 0:
                            this.EventsList2Prev.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.CurrentMonthString;
                            break;
                        case 1:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            break;
                        case 2:
                            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonth2String;                            

                            break;
                        case 3:
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.PrevMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            break;
                        case 4:
                            this.EventsListNext2.ItemsSource = App.ViewModel.Events.ThisMonthItems;

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

                    this.Monthes.Title = App.ViewModel.Events.CurrentMonth.Year.ToString();

                    previndex = itemindex;
                    switch (itemindex)
                    {
                        case 0:
                            this.EventsList2Prev.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.PrevMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.CurrentMonthString;
                            break;
                        case 1:
                            this.EventsListPrev.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.PrevMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonth2String;
                            this.ThisMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonthString;
                            break;
                        case 2:
                            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth2.Header = App.ViewModel.Events.PrevMonth2String;

                            break;
                        case 3:
                            this.EventsListNext.ItemsSource = App.ViewModel.Events.ThisMonthItems;

                            this.NextMonth2.Header = App.ViewModel.Events.NextMonthString;
                            this.NextMonth.Header = App.ViewModel.Events.CurrentMonthString;
                            this.ThisMonth.Header = App.ViewModel.Events.PrevMonthString;
                            this.PrevMonth.Header = App.ViewModel.Events.PrevMonth2String;
                            this.PrevMonth2.Header = App.ViewModel.Events.NextMonth2String;
                            break;
                        case 4:
                            this.EventsListNext2.ItemsSource = App.ViewModel.Events.ThisMonthItems;

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

        private void TodayButton_Click(object sender, EventArgs e)
        {
            previndex = 2;

            App.ViewModel.Events.CurrentMonth = DateTime.Now;

            this.Monthes.Title = App.ViewModel.Events.CurrentMonth.Year.ToString();

            try
            {
                this.Monthes.SelectedIndex = 2;
            }
            catch { };

            this.EventsListPrev.ItemsSource = App.ViewModel.Events.PrevMonthItems;
            this.EventsList.ItemsSource = App.ViewModel.Events.ThisMonthItems;
            this.EventsListNext.ItemsSource = App.ViewModel.Events.NextMonthItems;

            this.NextMonth.Header = App.ViewModel.Events.NextMonthString;
            this.ThisMonth.Header = App.ViewModel.Events.CurrentMonthString;
            this.PrevMonth.Header = App.ViewModel.Events.PrevMonthString;
        }

        private void EventsListNext2_Tap(object sender, System.Windows.Input.GestureEventArgs e)
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


    }
}