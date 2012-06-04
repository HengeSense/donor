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
            try
            {
                 MonthNumber = int.Parse(this.NavigationContext.QueryString["month"]);
                 DayNumber = int.Parse(this.NavigationContext.QueryString["day"]);
                 YearNumber = int.Parse(this.NavigationContext.QueryString["year"]);

                 this.Date.Value = new DateTime(YearNumber, MonthNumber, DayNumber);

            }
            catch
            {
                //NavigationService.GoBack();
            };

            List<string> eventTypes = new List<string>() { "Анализ", "Кроводача" };
            List<string> giveTypes = new List<string>() { "Тромбоциты", "Плазма", "Чистая кровь" };
            this.EventType.ItemsSource = eventTypes;
            this.GiveType.ItemsSource = giveTypes;

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

                    CurrentEvent.Id = DateTime.Now.Ticks.ToString();
                    CurrentEvent.Title = this.EventType.SelectedItem.ToString();
                    CurrentEvent.Type = this.EventType.SelectedItem.ToString();
                    CurrentEvent.Description = this.Description.Text.ToString();
                    CurrentEvent.Date = this.Date.Value.Value;
                    CurrentEvent.Image = "/images/drop.png";

                    //App.ViewModel.Events.Items.Remove(CurrentEvent);
                };
                App.ViewModel.Events.Items.Add(CurrentEvent);
                NavigationService.GoBack();
            }
            catch
            {
                NavigationService.GoBack();
            };
        }
    }
}