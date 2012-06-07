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

namespace Donor
{
    public partial class EventEditPage : PhoneApplicationPage
    {
        public EventEditPage()
        {
            InitializeComponent();           
        }

        public int DayNumber;
        public int YearNumber;
        public int MonthNumber;

        public EventViewModel CurrentEvent;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            
            List<string> eventTypes = new List<string>() { "Анализ", "Кроводача" };
            CurrentEvent = null;
            List<string> giveTypes = new List<string>() { "Тромбоциты", "Плазма", "Чистая кровь" };

            List<string> reminderTypes = new List<string>() { "15 минут", "1 час", "1 день", "1 неделя" };

            this.EventType.ItemsSource = eventTypes;
            this.GiveType.ItemsSource = giveTypes;
            this.ReminderPeriod.ItemsSource = reminderTypes;

            try
            {
                string id = this.NavigationContext.QueryString["id"];
                CurrentEvent = App.ViewModel.Events.Items.FirstOrDefault(c => c.Id == id);

                if (this.Date.Value == new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day))
                {
                    this.Date.Value = CurrentEvent.Date;
                };
                this.EventType.SelectedItem = CurrentEvent.Type.ToString();
                this.GiveType.SelectedItem = CurrentEvent.GiveType.ToString();
                if ((CurrentEvent.Reminder.ToString() != "") && (CurrentEvent.Reminder.ToString() != null))
                {
                this.GiveType.SelectedItem = CurrentEvent.Reminder.ToString();
                };
            }
            catch
            {
            };

            if (CurrentEvent == null)
            {
                try
                {
                    MonthNumber = int.Parse(this.NavigationContext.QueryString["month"]);
                    DayNumber = int.Parse(this.NavigationContext.QueryString["day"]);
                    YearNumber = int.Parse(this.NavigationContext.QueryString["year"]);

                    if (this.Date.Value == new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day))
                    {
                        this.Date.Value = new DateTime(YearNumber, MonthNumber, DayNumber);
                    };
                    if (this.Date.Value == new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day))
                    {
                        this.Date.Value = new DateTime(YearNumber, MonthNumber, DayNumber);
                    };

                }
                catch
                {
                };
            };
            this.DataContext = CurrentEvent;
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            NavigationService.GoBack();
        }

        private void SaveButton_Click(object sender, EventArgs e)
        {
            try
            {
                if (CurrentEvent != null)
                {
                    EventViewModel event1 = App.ViewModel.Events.Items.FirstOrDefault(s => s.Id == CurrentEvent.Id);
                    App.ViewModel.Events.Items.Remove(event1);
                }
                else
                {
                    CurrentEvent = new EventViewModel();
                };

                CurrentEvent.Id = DateTime.Now.Ticks.ToString();
                CurrentEvent.Title = this.EventType.SelectedItem.ToString();
                CurrentEvent.Type = this.EventType.SelectedItem.ToString();
                CurrentEvent.GiveType = this.GiveType.SelectedItem.ToString();
                CurrentEvent.Description = this.Description.Text.ToString();
                CurrentEvent.Date = this.Date.Value.Value;
                if (this.Time.Value == null)
                {
                    CurrentEvent.Time = DateTime.Now;
                }
                else
                {
                    CurrentEvent.Time = this.Time.Value.Value;
                };
                CurrentEvent.Place = this.Place.Text;

                if (this.EventType.SelectedItem.ToString() == "Анализ")
                {
                    CurrentEvent.Reminder = this.ReminderPeriod.SelectedItem.ToString();
                    CurrentEvent.ReminderMessage = this.KnowAboutResults.IsChecked.Value;
                };

                CurrentEvent.Image = "/images/drop.png";

                App.ViewModel.Events.Items.Add(CurrentEvent);
                NavigationService.GoBack();
            }
            catch
            {
                NavigationService.GoBack();
            };
        }

        private void EventType_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (this.EventType.SelectedItem.ToString() == "Анализ")
                {
                    this.Reminder.Visibility = Visibility.Visible;
                }
                else
                {
                    this.Reminder.Visibility = Visibility.Collapsed;
                };
            }
            catch
            {
            };
        }

        private void EventType_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                if (this.EventType.SelectedItem.ToString() == "Анализ")
                {
                    this.Reminder.Visibility = Visibility.Visible;
                }
                else
                {
                    this.Reminder.Visibility = Visibility.Collapsed;
                };
            }
            catch { };
        }
    }
}