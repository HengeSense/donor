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
            List<string> eventTypes = new List<string>() { Donor.AppResources.BloodGiveTitle2, Donor.AppResources.Analisis };
            CurrentEvent = null;
            List<string> giveTypes = new List<string>() { Donor.AppResources.Platelets, 
                Donor.AppResources.Plasma, Donor.AppResources.WholeBlood, Donor.AppResources.Granulocytes };

            List<string> reminderTypes = new List<string>() { Donor.AppResources.Reminder15Minutes, 
                Donor.AppResources.Reminder1Hour, Donor.AppResources.Reminder1Day, 
                Donor.AppResources.Reminder2Days, Donor.AppResources.Reminder1Week };

            this.EventType.ItemsSource = eventTypes;
            this.GiveType.ItemsSource = giveTypes;
            this.ReminderPeriod.ItemsSource = reminderTypes;

            this.Time.Value = new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day, 8, 0, 0);
            // устанавливаем дату на завтрашний день
            this.Date.Value = new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day);

            this.DataContext = CurrentEvent;
            App.ViewModel.Stations.SelectedStation = "";
        }

        public int DayNumber;
        public int YearNumber;
        public int MonthNumber;

        public EventViewModel CurrentEvent;
        public EventViewModel InitialCurrentEvent;

        public string EventId = "";

        protected override void OnNavigatedFrom(System.Windows.Navigation.NavigationEventArgs e)
        {
            try
            {
                if (e.Uri.ToString() != "/EventPage.xaml?id=" + EventId)
                {
                    App.ViewModel.Events.EditedEvent = BuildEvent(false);
                };
            }
            catch { };
            base.OnNavigatedFrom(e);
        }

        private void DataFLoaded(object sender, EventArgs e)
        {
            try
            {
                EventId = this.NavigationContext.QueryString["id"];
                CurrentEvent = App.ViewModel.Events.Items.FirstOrDefault(c => c.Id == EventId);
                if (CurrentEvent.Type == "PossibleBloodGive")
                {
                    CurrentEvent.ParseExists = false;
                } else  {
                    CurrentEvent.ParseExists = true;
                };                

                InitialCurrentEvent = CurrentEvent;


                this.Date.Value = CurrentEvent.Date;
                this.Time.Value = CurrentEvent.Time;
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

                List<string> eventTypes = new List<string>() { Donor.AppResources.BloodGiveTitle2, Donor.AppResources.Analisis };
                List<string> giveTypes = new List<string>() { Donor.AppResources.Platelets, 
                        Donor.AppResources.Plasma, Donor.AppResources.WholeBlood, Donor.AppResources.Granulocytes };
                this.EventType.ItemsSource = eventTypes;
                this.GiveType.ItemsSource = giveTypes;

                /*if (this.Date.Value == new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day))
                {
                    this.Date.Value = CurrentEvent.Date;
                };*/
                try
                {
                    if (CurrentEvent.Type.ToString() != "PossibleBloodGive")
                    {
                        this.EventType.SelectedItem = CurrentEvent.Type.ToString();
                    }
                    else
                    {
                        this.EventType.SelectedIndex = 0; //CurrentEvent.Type = "1"; 
                    };
                }
                catch
                {
                };
                switch (CurrentEvent.Type.ToString())
                {
                    case "1": this.EventType.SelectedIndex = 0; break;
                    case "PossibleBloodGive": this.EventType.SelectedIndex = 0; break;
                    case "0": this.EventType.SelectedIndex = 1; break;
                    default: break;
                };
                try
                {
                    this.GiveType.SelectedItem = CurrentEvent.GiveType.ToString();
                }
                catch
                {
                };
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
                    }
                    catch
                    {
                    };
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
                    CurrentEvent = new EventViewModel();
                    CurrentEvent.Finished = false;

                    MonthNumber = int.Parse(this.NavigationContext.QueryString["month"]);
                    DayNumber = int.Parse(this.NavigationContext.QueryString["day"]);
                    YearNumber = int.Parse(this.NavigationContext.QueryString["year"]);

                    if (this.Date.Value == new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day))
                    {
                        this.Date.Value = new DateTime(YearNumber, MonthNumber, DayNumber);
                        CurrentEvent.Date = new DateTime(YearNumber, MonthNumber, DayNumber);
                    };
                    if (this.Date.Value == new DateTime(DateTime.Now.AddDays(1).Year, DateTime.Now.AddDays(1).Month, DateTime.Now.AddDays(1).Day))
                    {
                        this.Date.Value = new DateTime(YearNumber, MonthNumber, DayNumber);
                        CurrentEvent.Date = new DateTime(YearNumber, MonthNumber, DayNumber);
                    };

                    BuildEvent(false);
                }
                catch { };
            };
        }

        private void PhoneApplicationPage_Loaded(object sender, RoutedEventArgs e)
        {
            try { DataFLoaded(this, EventArgs.Empty); }
            catch { };
            try { App.ViewModel.DataFLoaded += new MainViewModel.DataFLoadedEventHandler(this.DataFLoaded);} catch { };
            
        }

        private void CancelButton_Click(object sender, EventArgs e)
        {
            NavigationService.GoBack();
        }

        private EventViewModel itemother;

        private void SaveButton_Click(object sender, EventArgs e)
        {
            BuildEvent(true);
        }

         private EventViewModel BuildEvent(bool save = true) {
             if (App.ViewModel.User.IsLoggedIn == false)
             {
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
                 };
                 if (save)
                 {
                     checkit = true;
                 };
             }
             catch { };
             bool curan = false;
             try {
                 curan = CurrentEvent.Type != "0";
             } catch {
             };
             if ((this.EventType.SelectedItem.ToString() == Donor.AppResources.Analisis) || (this.EventType.SelectedItem.ToString()=="0"))
             {
                 checkit = false;
             };
             if ((this.EventType.SelectedItem.ToString() != Donor.AppResources.Analisis || curan || this.EventType.SelectedIndex != 1) && checkit)
             {
                 try
                 {
                     DateTime curdate = this.Date.Value.Value;
                     var checkitems = (from item in App.ViewModel.Events.UserItems
                                       where (item.Type == "1") && (item.Finished == true)
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

                     if (this.EventType.SelectedItem.ToString() == Donor.AppResources.BloodGiveTitle2)
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
                             CurrentEvent.Title = Donor.AppResources.Analisis;
                             break;
                         case "1":
                             CurrentEvent.Title = this.GiveType.SelectedItem.ToString(); //"Кроводача - " + 
                             break;
                         case "PossibleBloodGive":
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
                         case "PossibleBloodGive":
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

                     if (this.EventType.SelectedItem.ToString() == Donor.AppResources.Analisis)
                     {
                         CurrentEvent.ReminderDate = this.ReminderPeriod.SelectedItem.ToString();
                         CurrentEvent.ReminderMessage = this.KnowAboutResults.IsChecked.Value;
                     };

                     CurrentEvent.Image = "/images/drop.png";
                     //if save and there is no events at this day
                     if (CurrentEvent.Type == "0")
                     {
                         if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false))
                         {
                             try
                             {
                                 InitialCurrentEvent.RemoveReminders();
                             }
                             catch
                             {
                             };
                         };
                     };

                     if (CurrentEvent.Type == "0")
                     {
                         if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false))
                         {
                             // сохраняем анализ
                             try
                             {
                                 CurrentEvent.ParseExists = InitialCurrentEvent.ParseExists;
                                 if (InitialCurrentEvent.ParseExists == true)
                                 {
                                     CurrentEvent.Id = EventId;
                                 };
                                 
                             }
                             catch
                             {
                             };

                             App.ViewModel.Events.Items.Add(CurrentEvent);

                             App.ViewModel.Events.UpdateItems(CurrentEvent);
                             App.ViewModel.Events.UpdateItems();

                             App.ViewModel.Events.CurrentMonth = CurrentEvent.Date;

                             NavigationService.GoBack();
                         }
                         else
                         {
                             if (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) && save)
                             {
                                 MessageBox.Show(Donor.AppResources.YouHaveEventAtThisDay);
                             };
                         };
                     }
                     else
                     {
                         CurrentEvent.GiveType = this.GiveType.SelectedItem.ToString();
                         if (App.ViewModel.Events.EventsInYear(CurrentEvent.GiveType, CurrentEvent.Date) && App.ViewModel.Events.EventsInYear(CurrentEvent.GiveType, CurrentEvent.Date.AddYears(-1)))
                         {

                             if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false) && (CurrentEvent.Type == "1"))
                                 {
                                     try
                                     {
                                         InitialCurrentEvent.RemoveReminders();
                                     }
                                     catch { };
                                 };
                                 
                             /// Помечаем событие как выполненное, если его дата меньше текущей
                             if ((CurrentEvent.Date < DateTime.Today) || ((CurrentEvent.Date == DateTime.Today) && (CurrentEvent.Time.Hour <= DateTime.Now.Hour) && (CurrentEvent.Time.Minute <= DateTime.Now.Minute)))
                             {
                                 CurrentEvent.Finished = true;
                                 if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) == false))
                                 {
                                     MessageBox.Show(Donor.AppResources.YouGiveBloodThanks);
                                 };
                             }
                             else
                             {
                                 CurrentEvent.Finished = false;
                             };
                             if ((save) && (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date)==false))
                             {
                                 try
                                 {
                                     CurrentEvent.ParseExists = InitialCurrentEvent.ParseExists;
                                     if (InitialCurrentEvent.ParseExists == true)
                                     {
                                         CurrentEvent.Id = EventId;
                                     };
                                 }
                                 catch
                                 {
                                 };

                                 App.ViewModel.Events.Items.Add(CurrentEvent);

                                 App.ViewModel.Events.UpdateItems(CurrentEvent);
                                 App.ViewModel.Events.UpdateItems();

                                 App.ViewModel.Events.CurrentMonth = CurrentEvent.Date;

                                 NavigationService.GoBack();
                             }
                             else
                             {
                                 if (App.ViewModel.Events.ThisDayEvents(CurrentEvent.Date) && save)
                                 {
                                     MessageBox.Show(Donor.AppResources.YouHaveEventAtThisDay);
                                 };
                             };
                         }
                         else
                         {
                             if (save)
                             {
                                 MessageBox.Show(Donor.AppResources.YouCantPlanBloodGiveThisDay);
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
                 try
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
                     if (save)
                     {
                         MessageBox.Show(Donor.AppResources.NotTooMuchDaysFromLastBloodGive + this.GiveType.SelectedItem.ToString() + Donor.AppResources.PossibleGiveBloodStartingFrom + when.ToShortDateString());
                     };
                 }
                 catch {
                     if (save)
                     {
                         MessageBox.Show(Donor.AppResources.NotTooMuchDaysFromLastBloodGive);
                     };
                 };
             };

             return CurrentEvent;
         }

        private void EventType_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            try
            {
                if (this.EventType.SelectedItem.ToString() == Donor.AppResources.Analisis)
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

        /*private void MessageText_GotFocus(object sender, System.Windows.RoutedEventArgs e)
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
        }*/

        /*public void MessageText_Tap(object sender, System.Windows.Input.GestureEventArgs e)
        {
            InputScrollViewer.ScrollToVerticalOffset(e.GetPosition(Description).Y - 80);
        }*/


        private void EventType_Loaded(object sender, RoutedEventArgs e)
        {
            try
            {
                if (this.EventType.SelectedItem.ToString() == Donor.AppResources.Analisis)
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

        /// <summary>
        /// Переходим на страницу списка станции для выбора станции сдачи крови
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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
                this.Description.Height = this.Description.Height + 50;
        }

    }
}