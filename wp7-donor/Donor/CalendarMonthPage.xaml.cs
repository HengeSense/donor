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
using Donor.ViewModels;

namespace Donor
{
    public partial class CalendarMonthPage : PhoneApplicationPage
    {
        public CalendarMonthPage()
        {
            InitializeComponent();
            DataContext = ViewModelLocator.MainStatic;

            ViewModelLocator.MainStatic.EventsChangedCalendar += new MainViewModel.EventsChangedCalendarEventHandler(this.EventsChangedCalendar);

            try
            {
                this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[ViewModelLocator.MainStatic.Events.CurrentMonth.Month - 1];
                this.ApplicationTitle.Text = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                var gl = GestureService.GetGestureListener(this.Calendar1);
                gl.Flick += new EventHandler<Microsoft.Phone.Controls.FlickGestureEventArgs>(GestureListener_Flick);
            }
            catch { };
        }

        private void EventsChangedCalendar(object sender, EventArgs e)
        {
            try
            {
                this.Calendar1.UpdateCalendar();
            }
            catch { };
        }

        private void LayoutRoot_Loaded(object sender, RoutedEventArgs e)
        {
            this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[ViewModelLocator.MainStatic.Events.CurrentMonth.Month - 1];
            this.ApplicationTitle.Text = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();
        }

        protected override void OnNavigatedTo(System.Windows.Navigation.NavigationEventArgs e)
        {
            this.Calendar1.UpdateCalendar();
            base.OnNavigatedTo(e);            
        }

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            base.OnNavigatedTo(e);
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
        }

        private void StartAnimationTop()
        {
            Storyboard storyboard = new Storyboard();
            TranslateTransform trans = new TranslateTransform() { X = 1.0, Y = 1.0 };
            Calendar1.RenderTransformOrigin = new Point(0.5, 0.5);
            Calendar1.RenderTransform = trans;

            DoubleAnimation moveAnim = new DoubleAnimation();
            moveAnim.Duration = TimeSpan.FromMilliseconds(400);
            moveAnim.BeginTime = TimeSpan.FromMilliseconds(0);
            moveAnim.From = 0;
            moveAnim.To = 700;
            Storyboard.SetTarget(moveAnim, Calendar1);
            storyboard.Completed += new System.EventHandler(storyboard_Completed);
            Storyboard.SetTargetProperty(moveAnim, new PropertyPath("(UIElement.RenderTransform).(TranslateTransform.Y)"));
            storyboard.Children.Add(moveAnim);
            storyboard.Begin();
        }
        private void StartAnimationBottom()
        {
            this.Calendar1.Visibility = Visibility.Visible;
            Storyboard storyboard = new Storyboard();
            TranslateTransform trans = new TranslateTransform() { X = 1.0, Y = 1.0 };
            Calendar1.RenderTransformOrigin = new Point(0.5, 0.5);
            Calendar1.RenderTransform = trans;

            DoubleAnimation moveAnim = new DoubleAnimation();
            moveAnim.Duration = TimeSpan.FromMilliseconds(400);
            moveAnim.BeginTime = TimeSpan.FromMilliseconds(0);
            moveAnim.From = 700;
            moveAnim.To = 0;
            Storyboard.SetTarget(moveAnim, Calendar1);
            storyboard.Completed += new System.EventHandler(storyboard_CompletedBottom);
            Storyboard.SetTargetProperty(moveAnim, new PropertyPath("(UIElement.RenderTransform).(TranslateTransform.Y)"));
            storyboard.Children.Add(moveAnim);
            storyboard.Begin();
        }


        private void StartAnimationTop2()
        {
            Storyboard storyboard = new Storyboard();
            TranslateTransform trans = new TranslateTransform() { X = 1.0, Y = 1.0 };
            Calendar1.RenderTransformOrigin = new Point(0.5, 0.5);
            Calendar1.RenderTransform = trans;

            DoubleAnimation moveAnim = new DoubleAnimation();
            moveAnim.Duration = TimeSpan.FromMilliseconds(400);
            moveAnim.BeginTime = TimeSpan.FromMilliseconds(0);
            moveAnim.From = 0;
            moveAnim.To = -700;
            Storyboard.SetTarget(moveAnim, Calendar1);
            storyboard.Completed += new System.EventHandler(storyboard_Completed);
            Storyboard.SetTargetProperty(moveAnim, new PropertyPath("(UIElement.RenderTransform).(TranslateTransform.Y)"));
            storyboard.Children.Add(moveAnim);
            storyboard.Begin();

            this.Calendar1.Visibility = Visibility.Visible;
        }
        private void StartAnimationBottom2()
        {
            this.Calendar1.Visibility = Visibility.Visible;
            Storyboard storyboard = new Storyboard();
            TranslateTransform trans = new TranslateTransform() { X = 1.0, Y = 1.0 };
            Calendar1.RenderTransformOrigin = new Point(0.5, 0.5);
            Calendar1.RenderTransform = trans;

            DoubleAnimation moveAnim = new DoubleAnimation();
            moveAnim.Duration = TimeSpan.FromMilliseconds(400);
            moveAnim.BeginTime = TimeSpan.FromMilliseconds(0);
            moveAnim.From = -700;
            moveAnim.To = 0;
            Storyboard.SetTarget(moveAnim, Calendar1);
            storyboard.Completed += new System.EventHandler(storyboard_CompletedBottom);
            Storyboard.SetTargetProperty(moveAnim, new PropertyPath("(UIElement.RenderTransform).(TranslateTransform.Y)"));
            storyboard.Children.Add(moveAnim);
            storyboard.Begin();
        }


        Microsoft.Phone.Controls.FlickGestureEventArgs move;
        //Microsoft.Phone.Controls.DragCompletedGestureEventArgs move;
        private void storyboard_CompletedBottom(object sender, EventArgs e)
        {            
        }
        private void storyboard_Completed(object sender, EventArgs e)
        {
            //this.Calendar1.Visibility = Visibility.Collapsed;
            if (move.Direction == System.Windows.Controls.Orientation.Vertical)
            {
                if (move.VerticalVelocity < 0)
                {
                    try
                    {
                        /*ViewModelLocator.MainStatic.Events.CurrentMonth = ViewModelLocator.MainStatic.Events.CurrentMonth.AddMonths(1);

                        this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[ViewModelLocator.MainStatic.Events.CurrentMonth.Month - 1];
                        this.ApplicationTitle.Text = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                        this.Calendar1.UpdateCalendar(); */                   

                        StartAnimationBottom();
                    }
                    catch
                    {
                    };
                }
                else
                {
                    try
                    {
                        /*ViewModelLocator.MainStatic.Events.CurrentMonth = ViewModelLocator.MainStatic.Events.CurrentMonth.AddMonths(-1);

                        this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[ViewModelLocator.MainStatic.Events.CurrentMonth.Month - 1];
                        this.ApplicationTitle.Text = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();*/

                        //this.Calendar1.UpdateCalendar();

                        StartAnimationBottom2();
                    }
                    catch
                    {
                    };
                };
            }
            else
            {
                if (move.VerticalVelocity < 0)
                {
                }
                else
                {
                }
            };
            
        }

        private void GestureListener_Flick(object sender, Microsoft.Phone.Controls.FlickGestureEventArgs e)
        {
            move = e;
            if (move.Direction == System.Windows.Controls.Orientation.Vertical)
            {                
                if (move.VerticalVelocity < 0)
                {
                    StartAnimationTop2();

                    ViewModelLocator.MainStatic.Events.CurrentMonth = ViewModelLocator.MainStatic.Events.CurrentMonth.AddMonths(1);
                    this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[ViewModelLocator.MainStatic.Events.CurrentMonth.Month - 1];
                    this.ApplicationTitle.Text = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                    this.Calendar1.UpdateCalendar();
                }
                else
                {

                    StartAnimationTop();

                    ViewModelLocator.MainStatic.Events.CurrentMonth = ViewModelLocator.MainStatic.Events.CurrentMonth.AddMonths(-1);
                    this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[ViewModelLocator.MainStatic.Events.CurrentMonth.Month - 1];
                    this.ApplicationTitle.Text = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                    this.Calendar1.UpdateCalendar();
                };
            };
        }

        private void TodayButton_Click(object sender, EventArgs e)
        {
            try
            {
                ViewModelLocator.MainStatic.Events.CurrentMonth = DateTime.Now;

                this.PageTitle.Text = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[ViewModelLocator.MainStatic.Events.CurrentMonth.Month - 1];
                this.ApplicationTitle.Text = ViewModelLocator.MainStatic.Events.CurrentMonth.Year.ToString();

                this.Calendar1.UpdateCalendar();                
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