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
            List<string> eventTypes = new List<string>() { "Кроводача", "Анализ" };
            CurrentEvent = null;
            List<string> giveTypes = new List<string>() { "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" };
            //, "Гранулоциты"

            List<string> reminderTypes = new List<string>() { "15 минут", "1 час", "1 день", "1 неделя" };

            this.EventType.ItemsSource = eventTypes;
            this.GiveType.ItemsSource = giveTypes;
            this.ReminderPeriod.ItemsSource = reminderTypes;

            this.Time.Value = new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day, 8, 0, 0);

            this.DataContext = CurrentEvent;

        }

        public int DayNumber;
        public int YearNumber;
        public int MonthNumber;

        public EventViewModel CurrentEvent;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                string id = this.NavigationContext.QueryString["id"];
                CurrentEvent = App.ViewModel.Events.Items.FirstOrDefault(c => c.Id == id);

                if (this.Date.Value == new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day))
                {
                    this.Date.Value = CurrentEvent.Date;
                };
                this.EventType.SelectedItem = CurrentEvent.Type.ToString();
                this.GiveType.SelectedItem = CurrentEvent.GiveType.ToString();
                if ((CurrentEvent.ReminderDate.ToString() != "") && (CurrentEvent.ReminderDate.ToString() != null))
                {
                    this.GiveType.SelectedItem = CurrentEvent.ReminderDate.ToString();
                };
            }
            catch
            {
            };
            this.DataContext = CurrentEvent;

            if (CurrentEvent == null)
            {
                try
                {
                    MonthNumber = int.Parse(this.NavigationContext.QueryString["month"]);
                    DayNumber = int.Parse(this.NavigationContext.QueryString["day"]);
                    YearNumber = int.Parse(this.NavigationContext.QueryString["year"]);

                    if (this.Date.Value == new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day))
                    {
                        this.Date.Value = new DateTime(YearNumber, MonthNumber, DayNumber);
                    };
                    if (this.Date.Value == new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day))
                    {
                        this.Date.Value = new DateTime(YearNumber, MonthNumber, DayNumber);
                    };

                    
                }
                catch
                {
                    this.Date.Value = new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day);
                    //this.Time.Value = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day, 8, 0, 0);
                };
            };
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            NavigationService.GoBack();
        }

        private EventViewModel itemother;
        private void SaveButton_Click(object sender, EventArgs e)
        {
            if (App.ViewModel.User.IsLoggedIn == false)
            {
                MessageBox.Show("You can't add events until you enter your email and password.");
                return;
            };
            string give = this.GiveType.SelectedItem.ToString();
            bool possible = true;
            if (this.EventType.SelectedItem.ToString() != "Анализ")
            {
                try
                {
                    DateTime curdate = this.Date.Value.Value;
                    var checkitems = (from item in App.ViewModel.Events.Items
                                      where (item.Type == "1")
                                      orderby item.Date descending
                                      select item);
                    foreach (var item in checkitems)
                    {
                        if (CurrentEvent != item)
                        {
                            int days = App.ViewModel.Events.DaysFromEvent(item.GiveType, give);
                            int days2 = App.ViewModel.Events.DaysFromEvent(give, item.GiveType);
                            if ((curdate <= item.Date.AddDays(days)) && (curdate >= item.Date))
                            {
                                possible = false;
                                itemother = item;
                                break;
                            };
                            if ((item.Date <= curdate.AddDays(days2)) && (curdate < item.Date))
                            {
                                possible = false;
                                itemother = item;
                                break;
                            };
                        };
                    };
                }
                catch
                {
                    possible = true;
                };
            };

            if (possible == true)
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
                    switch (this.EventType.SelectedItem.ToString())
                    {
                        case "0":
                            CurrentEvent.Title = "Анализ";
                            break;
                        case "1":
                            CurrentEvent.Type = "Кроводача";
                            break;
                        default:
                            break;
                    };
                    
                    switch (this.EventType.SelectedItem.ToString())
                    {
                        case "Анализ":
                            CurrentEvent.Type = "0";
                            break;
                        case "Кроводача":
                            CurrentEvent.Type = "1";
                            break;
                        default:
                            CurrentEvent.Type = this.EventType.SelectedItem.ToString();
                            break;
                    };
                    //CurrentEvent.Type = this.EventType.SelectedItem.ToString();
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
                        CurrentEvent.ReminderDate = this.ReminderPeriod.SelectedItem.ToString();
                        CurrentEvent.ReminderMessage = this.KnowAboutResults.IsChecked.Value;
                    };

                    CurrentEvent.Image = "/images/drop.png";

                    if ((App.ViewModel.Settings.EventBefore == true) && (App.ViewModel.Settings.Push == true))
                    {
                        //{ "15 минут", "1 час", "1 день", "1 неделя" };
                        switch (this.ReminderPeriod.SelectedItem.ToString())
                        {
                            case "15 минут":
                                CurrentEvent.AddReminder(-15 * 60);
                                break;
                            case "1 час":
                                CurrentEvent.AddReminder(-60 * 60);
                                break;
                            case "1 день":
                                CurrentEvent.AddReminder(-24 * 60 * 60);
                                break;
                            case "1 неделя":
                                CurrentEvent.AddReminder(-7 * 24 * 60 * 60);
                                break;
                            default:
                                break;
                        }

                    };

                    if (App.ViewModel.Events.EventsInYear(CurrentEvent.GiveType, CurrentEvent.Date) && App.ViewModel.Events.EventsInYear(CurrentEvent.GiveType, CurrentEvent.Date.AddYears(-1)))
                    {
                        if (((App.ViewModel.Settings.EventAfter == true) && (App.ViewModel.Settings.Push == true)) && (CurrentEvent.ReminderMessage == true))
                        {
                            //в день в 17:00
                            CurrentEvent.AddReminder(-60*60*17);
                        };

                        ///
                        /// Помечаем событие как выполненное, если его дата меньше текущей
                        ///
                        if ((CurrentEvent.Date <= DateTime.Today) && (CurrentEvent.Time < DateTime.Now))
                        {
                            CurrentEvent.Finished = true;
                            MessageBox.Show("Вы сдали кровь. Спасибо! Рассчитан интервал до следующей возможной кроводачи");
                        };
                        App.ViewModel.Events.Items.Add(CurrentEvent);

                        App.ViewModel.Events.UpdateItems();
                        NavigationService.GoBack();
                    }
                    else
                    {
                        MessageBox.Show("В данный день вы еще не можете производить сдачу крови.");
                    };
                }
                catch
                {
                    NavigationService.GoBack();
                };
            }
            else
            {                
                DateTime curdate = this.Date.Value.Value;
                int days = App.ViewModel.Events.DaysFromEvent(itemother.GiveType, give);
                int days2 = App.ViewModel.Events.DaysFromEvent(give, itemother.GiveType);
                var dif = Math.Abs(days - days2);

                DateTime when = curdate;
                if ((curdate <= itemother.Date.AddDays(days)) && (curdate >= itemother.Date))
                {
                    when = itemother.Date.AddDays(days);
                };
                if ((itemother.Date <= curdate.AddDays(days2)) && (curdate < itemother.Date))
                {
                    when = curdate.AddDays(days2);
                };
                MessageBox.Show("Прошло мало времени с последней кроводачи. " + this.GiveType.SelectedItem.ToString() + " можно сдавать с " + when.ToShortDateString());
            };
            App.ViewModel.SaveToIsolatedStorage();
        }

        private void EventType_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (this.EventType.SelectedItem.ToString() == "Анализ")
                {
                    this.Reminder.Visibility = Visibility.Visible;
                    this.GiveType.Visibility = Visibility.Collapsed;
                }
                else
                {
                    this.Reminder.Visibility = Visibility.Collapsed;
                    this.GiveType.Visibility = Visibility.Visible;
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