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

            App.ViewModel.Events.EditedEvent = null;
            List<string> eventTypes = new List<string>() { "Кроводача", "Анализ" };
            CurrentEvent = null;
            List<string> giveTypes = new List<string>() { "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" };
            //, "Гранулоциты"

            List<string> reminderTypes = new List<string>() { "15 минут", "1 час", "1 день", "2 дня", "1 неделя" };

            this.EventType.ItemsSource = eventTypes;
            this.GiveType.ItemsSource = giveTypes;
            this.ReminderPeriod.ItemsSource = reminderTypes;

            this.Time.Value = new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day, 8, 0, 0);
            this.Date.Value = new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day);

            this.DataContext = CurrentEvent;
            App.ViewModel.Stations.SelectedStation = "";
        }

        public int DayNumber;
        public int YearNumber;
        public int MonthNumber;

        public EventViewModel CurrentEvent;
        public EventViewModel InitialCurrentEvent;

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                string id = this.NavigationContext.QueryString["id"];
                CurrentEvent = App.ViewModel.Events.Items.FirstOrDefault(c => c.Id == id);

                InitialCurrentEvent = CurrentEvent;
            }
            catch
            {
            };

            if (App.ViewModel.Events.EditedEvent != null)
            {
                try
                {
                    CurrentEvent = App.ViewModel.Events.EditedEvent;
                    StationViewModel _currentStation = App.ViewModel.Stations.Items.FirstOrDefault(c => c.Nid.ToString() == App.ViewModel.Stations.SelectedStation.ToString());
                    this.Place.Text = _currentStation.Adress.ToString();
                    CurrentEvent.Place = _currentStation.Adress.ToString();
                    CurrentEvent.Station_nid = _currentStation.Nid;
                    App.ViewModel.Events.EditedEvent = null;
                }
                catch
                {
                };
            }
            else
            {
                App.ViewModel.Events.EditedEvent = null;
            };

            try
            {
                this.Description.Text = CurrentEvent.Description;
                this.Place.Text = CurrentEvent.Place;

                List<string> eventTypes = new List<string>() { "Кроводача", "Анализ" };
                List<string> giveTypes = new List<string>() { "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" };
                this.EventType.ItemsSource = eventTypes;
                this.GiveType.ItemsSource = giveTypes;

                if (this.Date.Value == new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day))
                {
                    this.Date.Value = CurrentEvent.Date;
                };
                try
                {
                    this.EventType.SelectedItem = CurrentEvent.Type.ToString();
                }
                catch { };
                switch (CurrentEvent.Type.ToString())
                {
                    case "1": this.EventType.SelectedIndex = 0; break;
                    case "0": this.EventType.SelectedIndex = 1; break;
                    default: break;
                };
                try
                {
                    this.GiveType.SelectedItem = CurrentEvent.GiveType.ToString();
                }
                catch { };
                switch (CurrentEvent.GiveType.ToString())
                {
                        case "Тромбоциты": this.GiveType.SelectedIndex = 0; break;
                        case "Плазма": this.GiveType.SelectedIndex = 1; break;
                        case "Цельная кровь": this.GiveType.SelectedIndex = 2; break;
                        case "Гранулоциты": this.GiveType.SelectedIndex = 3; break;
                    default: break;
                };
                // "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" };


                if ((CurrentEvent.ReminderDate.ToString() != "") && (CurrentEvent.ReminderDate.ToString() != null))
                {
                    try
                    {
                        this.ReminderPeriod.SelectedItem = CurrentEvent.ReminderDate.ToString();
                    } catch {};
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
            BuildEvent(true);
            //App.ViewModel.SaveToIsolatedStorage();
        }

         private EventViewModel BuildEvent(bool save = true) {
             if (App.ViewModel.User.IsLoggedIn == false)
             {
                 MessageBox.Show("You can't add events until you enter your email and password.");
                 return null;
             };

             string give = this.GiveType.SelectedItem.ToString();
             bool possible = true;
             bool checkit = true;
             try
             {
                 if (CurrentEvent.Date != this.Date.Value.Value)
                 {
                     checkit = true;
                 }
                 else
                 {
                     checkit = false;
                 }
             }
             catch { };
             if ((this.EventType.SelectedItem.ToString() != "Анализ") && checkit)
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

                     if (this.EventType.SelectedItem.ToString() == "Кроводача")
                     {
                         CurrentEvent.Title = this.GiveType.SelectedItem.ToString();
                     }
                     else
                     {
                         CurrentEvent.Title = this.EventType.SelectedItem.ToString();
                     };

                     switch (this.EventType.SelectedItem.ToString())
                     {
                         case "0":
                             CurrentEvent.Title = "Анализ";
                             break;
                         case "1":
                             CurrentEvent.Title = this.GiveType.SelectedItem.ToString(); //"Кроводача - " + 
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
                         //if save and thiere is no events at this day
                         if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false))
                         {
                             InitialCurrentEvent.RemoveReminders();
                             switch (this.ReminderPeriod.SelectedItem.ToString())
                             {
                                 case "15 минут":
                                     CurrentEvent.AddReminder(15 * 60);
                                     break;
                                 case "1 час":
                                     CurrentEvent.AddReminder(60 * 60);
                                     break;
                                 case "1 день":
                                     CurrentEvent.AddReminder(24 * 60 * 60);
                                     break;
                                 case "2 дня":
                                     CurrentEvent.AddReminder(2 * 24 * 60 * 60);
                                     break;
                                 case "1 неделя":
                                     CurrentEvent.AddReminder(7 * 24 * 60 * 60);
                                     break;
                                 default:
                                     break;
                             };
                         };

                     };

                     if (CurrentEvent.Type == "0")
                     {
                         if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false))
                         {
                             // сохраняем анализ
                             App.ViewModel.Events.Items.Add(CurrentEvent);
                             App.ViewModel.Events.UpdateItems(CurrentEvent);
                             App.ViewModel.SaveToIsolatedStorage();
                             NavigationService.GoBack();
                         }
                         else
                         {
                             if (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date))
                             {
                                 MessageBox.Show("На этот день у вас уже запланировано событие.");
                             };
                         };
                     }
                     else
                     {
                         CurrentEvent.GiveType = this.GiveType.SelectedItem.ToString();
                         if (App.ViewModel.Events.EventsInYear(CurrentEvent.GiveType, CurrentEvent.Date) && App.ViewModel.Events.EventsInYear(CurrentEvent.GiveType, CurrentEvent.Date.AddYears(-1)))
                         {
                             if (((App.ViewModel.Settings.EventAfter == true) && (App.ViewModel.Settings.Push == true)) && (CurrentEvent.ReminderMessage == true))
                             {
                                 if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false))
                                 {
                                     InitialCurrentEvent.RemoveReminders();

                                     //в день в 17:00
                                     CurrentEvent.AddReminder(-60 * 60 * 17, CurrentEvent.GiveType);
                                     //за день в 12:00
                                     CurrentEvent.AddReminder(60 * 60 * 12, "Завтра у вас запланирована кроводача.");
                                 };
                                 
                             };

                             ///
                             /// Помечаем событие как выполненное, если его дата меньше текущей
                             if ((CurrentEvent.Date <= DateTime.Today) && (CurrentEvent.Time.Hour <= DateTime.Now.Hour) && (CurrentEvent.Time.Minute <= DateTime.Now.Minute))
                             {
                                 CurrentEvent.Finished = true;
                                 if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false))
                                 {
                                     MessageBox.Show("Вы сдали кровь. Спасибо! Рассчитан интервал до следующей возможной кроводачи");
                                 };
                             };
                             if ((save) && App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date))
                             {
                                 App.ViewModel.Events.Items.Add(CurrentEvent);

                                 App.ViewModel.Events.UpdateItems(CurrentEvent);
                                 App.ViewModel.SaveToIsolatedStorage();
                                 NavigationService.GoBack();
                             }
                             else
                             {
                                 if (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date))
                                 {
                                     MessageBox.Show("На этот день у вас уже запланировано событие.");
                                 };
                             };
                         }
                         else
                         {
                             if (save)
                             {
                                 MessageBox.Show("В данный день вы еще не можете производить сдачу крови.");
                             };
                         };
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
                     when = itemother.Date.AddDays(days + 1);
                 };
                 if ((itemother.Date <= curdate.AddDays(days2)) && (curdate < itemother.Date))
                 {
                     when = itemother.Date.AddDays(days2 + 1);
                 };
                 MessageBox.Show("Прошло мало времени с последней кроводачи. " + this.GiveType.SelectedItem.ToString() + " можно сдавать с " + when.ToShortDateString());
             };

             return CurrentEvent;
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

        double InputHeight = 0.0;

        private void MessageText_GotFocus(object sender, System.Windows.RoutedEventArgs e)
        {
            (App.Current as App).RootFrame.RenderTransform = new CompositeTransform();
        }

        private void inputText_TextChanged(object sender, System.Windows.Controls.TextChangedEventArgs e)
        {
            Dispatcher.BeginInvoke(() =>
            {
                double CurrentInputHeight = Description.ActualHeight;

                if (CurrentInputHeight > InputHeight)
                {
                    InputScrollViewer.ScrollToVerticalOffset(InputScrollViewer.VerticalOffset + CurrentInputHeight - InputHeight);
                }

                InputHeight = CurrentInputHeight;
            });
        }

        public void MessageText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            InputScrollViewer.ScrollToVerticalOffset(e.GetPosition(Description).Y - 80);
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

        private void Image_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            App.ViewModel.Events.EditedEvent = BuildEvent(false);
            NavigationService.Navigate(new Uri("/StationsSearch.xaml?task=select", UriKind.Relative));
        }

        private void Description_TextChanged(object sender, TextChangedEventArgs e)
        {
        }

        private void Description_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key.Equals(Key.Enter))
                //this.Description.Text += System.Environment.NewLine;  
                this.Description.Height = this.Description.Height + 50;
        }

    }
}