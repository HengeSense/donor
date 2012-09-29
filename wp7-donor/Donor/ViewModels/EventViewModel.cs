﻿using System;
using System.Net;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Documents;
using System.Windows.Ink;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Animation;
using System.Windows.Shapes;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Collections.Generic;
using System.Globalization;
using RestSharp;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Microsoft.Phone.Scheduler;

namespace Donor.ViewModels
{
    public class EventViewModel
    {
        public EventViewModel()
        {
            this.Date = DateTime.Now;

            this.UserId = App.ViewModel.User.objectId;
        }

        public string Id { get; set; }
        public string Title { get; set; }
        public string Description {get; set; }
        private DateTime _date;
        public DateTime Date { 
            get
            {
                return _date;
            }
            set
            {
                _date = value;
            }
        }
        public string ShortDate
        {
            get
            {
                return _date.ToShortDateString();
            }
            private set { }
        }

        public string Image { get; set; }

        /// <summary>
        /// Type variants
        /// Тип события (0 – Анализ, 1 – Сдача крови)
        /// </summary>
        public string Type { get; set; }
        public string GiveType { get; set; }
        public string Place { get; set; }

        public string ReminderDate { get; set; }
        public bool ReminderMessage { get; set; }

        private bool _finished = false;
        public bool Finished
        {
            get
            {
                return _finished;
            }
            set
            {
                _finished = value;
            }
        }
        public string FinishedString
        {
            get
            {
                if (_finished)
                {
                    return "Выполнено";
                }
                else
                {
                    return "Еще не отмечено как выполненное";
                };
            }
            private set {            }
        }
        
        public string BigImage
        {
            private set
            {
            }
            get
            {
                if (this.Type == "0") 
                    return "/images/ic_planned_analysis.png";
                if (this.Type == "1")
                    return "/images/ic_planned_giving_blood.png";
                if (this.Type == "2")
                    return "/images/ic_donors_act.png";
                return "";
            }
        }

        private DateTime _time;
        public DateTime Time {
            get
            {
                return _time;
            }
            set
            {
                _time = value;
            }
        }
        public string ShortTime
        {
            get
            {
                return _time.ToShortTimeString();
            }
            private set { }
        }

        public void AddReminder(long addSeconds = 0, string rtitle="") {
            try
            {
                Reminder objReminder = ScheduledActionService.Find(this.Id) as Reminder;
                if (objReminder != null)
                    ScheduledActionService.Remove(this.Id);
                objReminder = new Reminder(this.Id);
                DateTime RememberDate = this.Date;
                if (addSeconds >= 0)
                {
                    RememberDate = RememberDate.AddSeconds((this.Time.Hour * 60 * 60) + (this.Time.Minute * 60) + (this.Time.Second));
                };
                RememberDate = RememberDate.AddSeconds(-addSeconds);
                objReminder.BeginTime = RememberDate;

                if (rtitle == "")
                {
                    objReminder.Title = this.GiveType;
                }
                else
                {
                    objReminder.Title = rtitle;
                };

                objReminder.NavigationUri = new Uri("/EventPage.xaml?id=" + this.Id, UriKind.Relative);
                ScheduledActionService.Add(objReminder);
            }
            catch { };
        }

        public string UserId { get; set; }
    }

    public class EventsListViewModel: INotifyPropertyChanged
    {
        public EventsListViewModel()
        {
            Items = new ObservableCollection<EventViewModel>();
        }

        public int FutureEventsCount()
        {
            int count = 0;
            count = (from item in this.UserItems
                          where (item.Date >= DateTime.Now) && (item.Type == "1") && (item.Type == "0")
                         orderby item.Date ascending select item).Count();
            return count;
        }

        public int DaysBefore()
        {
            List<string> TypesGive = new List<string>() { "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" };
            

            int days_count = 0;
            var nearestEvents = (from item in this.UserItems
                              where (item.Date <= DateTime.Now)
                              orderby item.Date descending
                              select item).Take(1);

            if (nearestEvents.Count() == 0)
            {
                return 0;
            }
            else
            {
                int min = 10000000;
                string min_item1;
                string min_item2;
                foreach (var item in TypesGive)
                {
                    foreach (var item2 in TypesGive)
                    {
                        if (min > DaysFromEvent(item, item2))
                        {
                            min_item1 = item;
                            min_item2 = item;
                            min = DaysFromEvent(item, item2);
                        };
                    };
                };
                days_count = min;
                return days_count;
            };            
        }

        public bool EventsInYear(string event_give_type, DateTime start)
        {
            /*var yearitems = from item in App.ViewModel.Events.UserItems
                            where item.Date >= start && item.Date <= start.AddYears(1)
                            select item;*/
            switch (event_give_type)
            {
                case "Тромбоциты":
                    var yearitems = from item in App.ViewModel.Events.UserItems
                                    where (item.Date >= start && item.Date <= start.AddYears(1) && item.GiveType == "Тромбоциты")
                                    select item;
                    if (yearitems.Count() > 9)
                    {
                        return false;
                    } else {
                        return true;
                    };
                case "Гранулоциты":
                    var yearitems2 = from item in App.ViewModel.Events.UserItems
                                     where (item.GiveType == "Гранулоциты")
                                    select item;
                    if (yearitems2.Count() > 2)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    };
                case "Плазма":
                    var yearitems3 = from item in App.ViewModel.Events.UserItems
                                     where (item.Date >= start && item.Date <= start.AddYears(1) && item.GiveType == "Плазма")
                                    select item;
                    if (yearitems3.Count() > 11)
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    };
                case "Цельная кровь":
                    var yearitems4 = from item in App.ViewModel.Events.UserItems
                                     where (item.Date >= start && item.Date <= start.AddYears(1) && item.GiveType == "Цельная кровь")
                                     select item;
                    if (((yearitems4.Count() > 4) && (App.ViewModel.User.Sex==0)) || ((yearitems4.Count() > 3) && (App.ViewModel.User.Sex==1)))
                    {
                        return false;
                    }
                    else
                    {
                        return true;
                    };
                default:
                    return true;
                    
            }
        }

        public int DaysFromEvent(string event_give_type, string want_event_give_type)
        {
            int days_count = 0;

            switch (event_give_type)
            {
                case "Тромбоциты":
                    switch (want_event_give_type)
                    {
                        case "Тромбоциты":
                            days_count = 14;
                            break;
                        case "Плазма":
                            days_count = 14;
                            break;
                        case "Цельная кровь":
                            days_count = 30;
                            break;
                        case "Гранулоциты":
                            days_count = 30;
                            break;
                        default: break;
                    };
                    break;
                case "Плазма":
                    switch (want_event_give_type)
                    {
                        case "Тромбоциты":
                            days_count = 14;
                            break;
                        case "Плазма":
                            days_count = 14;
                            break;
                        case "Цельная кровь":
                            days_count = 14;
                            break;
                        case "Гранулоциты":
                            days_count = 14;
                            break;
                        default: break;
                    };
                    break;
                case "Цельная кровь":
                    switch (want_event_give_type)
                    {
                        case "Тромбоциты":
                            days_count = 30;
                            break;
                        case "Плазма":
                            days_count = 30;
                            break;
                        case "Цельная кровь":
                            days_count = 60;
                            break;
                        case "Гранулоциты":
                            days_count = 30;
                            break;
                        default: break;
                    };
                    break;
                case "Гранулоциты":
                    switch (want_event_give_type)
                    {
                        case "Тромбоциты":
                            days_count = 30;
                            break;
                        case "Плазма":
                            days_count = 14;
                            break;
                        case "Цельная кровь":
                            days_count = 30;
                            break;
                        case "Гранулоциты":
                            days_count = 365;
                            break;
                        default: break;
                    };
                    break;
                default: break;
            }

            return days_count;
        }

        public EventViewModel NearestEvents()
        {
            var item_near2 = (from item in this.UserItems
                     where (item.Date >= DateTime.Now) && (item.Type == "1") && (item.Type == "0")
                     orderby item.Date ascending
                     select item).Take(1);
            return item_near2.FirstOrDefault();
        }

        public ObservableCollection<EventViewModel> UserItems
        {
            get
            {
                ObservableCollection<EventViewModel> _user_items = new ObservableCollection<EventViewModel>();
                if (App.ViewModel.User.IsLoggedIn)
                {
                    var _selected_user_items = (from item in this.Items
                                                where (item.UserId == App.ViewModel.User.objectId) || ((item.Type != "0") && (item.Type != "1"))
                                                orderby item.Date descending
                                                select item);
                    foreach (var item in _selected_user_items) {
                        _user_items.Add(item);
                    };
                    return _user_items;
                }
                else
                {
                    return _user_items;
                };

                //return _user_items;
            }
            private set
            {
            }
        }

        public EventViewModel NearestEventsAll()
        {
            var item_near2 = (from item in this.UserItems
                              where (item.Date >= DateTime.Now)
                              orderby item.Date ascending
                              select item).Take(1);
            return item_near2.FirstOrDefault();
        }

        public void UpdateItems() {
            NotifyPropertyChanged("Items");
            NotifyPropertyChanged("UserItems");
            NotifyPropertyChanged("WeekItems");
            NotifyPropertyChanged("ThisMonthItems");

            App.ViewModel.CreateApplicationTile(App.ViewModel.Events.NearestEvents());
            App.ViewModel.SaveToIsolatedStorage();
        }

        public void LoadDonorsSaturdays()
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Events", Method.GET);
            request.Parameters.Clear();
            string strJSONContent = "{\"type\":2}";
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            request.AddParameter("where", strJSONContent);
            client.ExecuteAsync(request, response =>
            {
                try
                {
                    ObservableCollection<EventViewModel> eventslist1 = new ObservableCollection<EventViewModel>();
                    JObject o = JObject.Parse(response.Content.ToString());                    
                    foreach (var item in o["results"])
                    {
                        EventViewModel jsonitem = new EventViewModel();
                        jsonitem.Title = item["title"].ToString();
                        try
                        {
                            jsonitem.Description = item["comment"].ToString();
                        }
                        catch { };
                        jsonitem.Id = item["objectId"].ToString();
                        jsonitem.Type = item["type"].ToString();
                        jsonitem.Date = DateTime.Parse(item["date"]["iso"].ToString());
                        this.Items.Remove(this.Items.FirstOrDefault(c => c.Id == jsonitem.Id));
                        this.Items.Add(jsonitem);
                    };
                }
                catch
                {
                };
                this.NotifyPropertyChanged("Items");
                this.NotifyPropertyChanged("WeekItems");
            });            
        }

        private ObservableCollection<EventViewModel> _items;
        public ObservableCollection<EventViewModel> Items
        {
            get { return _items; }
            set
            {
                if (_items != value)
                {
                    _items = value;
                    this.NotifyPropertyChanged("Items");
                    this.NotifyPropertyChanged("WeekItems");
                };
            }
        }

        public int BloodGiveCount {
        get {
            if (App.ViewModel.User.IsLoggedIn)
            {
                var _selected_user_items = (from item in this.Items
                                            where (item.UserId == App.ViewModel.User.objectId) || ((item.Type != "1"))
                                            orderby item.Date descending
                                            select item);
                return _selected_user_items.Count();
            }
            else
            {
                return 0;
            };
        }
        private set {}
        }

        public void WeekItemsUpdated() {
            this.NotifyPropertyChanged("WeekItems");
        }

        public List<EventViewModel> WeekItems { 
            get 
            {
                var newitems = (from eventCal in this.UserItems
                                where (eventCal.Date.Month == DateTime.Now.Month) && (eventCal.Date.Year == DateTime.Now.Year) && (App.ViewModel.User.objectId == eventCal.UserId)
                               orderby eventCal.Date descending
                                select eventCal).Take(10);
                List<EventViewModel> outnews = newitems.ToList();
                return outnews;
            }
            private set { } 
        }

        public List<EventViewModel> ThisMonthItems
        {
            get
            {
                var newitems = (from eventCal in this.UserItems
                                where (eventCal.Date.Month == CurrentMonth.Month) && (eventCal.Date.Year == CurrentMonth.Year)
                                orderby eventCal.Date descending
                                select eventCal);
                List<EventViewModel> outnews = newitems.ToList();
                return outnews;
            }
            private set { }
        }

        private DateTime _currentMonth = DateTime.Now;
        public DateTime CurrentMonth {
            get {
                return _currentMonth;
            }
            set 
            { 
                _currentMonth = value;
                NotifyPropertyChanged("CurrentMonthString");
                NotifyPropertyChanged("NextMonthString");
                NotifyPropertyChanged("PrevMonthString");
                NotifyPropertyChanged("NextMonthItems");
                NotifyPropertyChanged("ThisMonthItems");
                NotifyPropertyChanged("PrevMonthItems");
            }
        }

        public string CurrentDate
        {
            get {
                return DateTime.Now.ToString("D");
                //CultureInfo.CurrentCulture.DateTimeFormat.LongDatePattern.;
            }
            private set
            {
            }
        }

        public string CurrentDateYear
        {
            get
            {
                return DateTime.Now.Year.ToString();
                //CultureInfo.CurrentCulture.DateTimeFormat.LongDatePattern.;
            }
            private set
            {
            }
        }

        public string CurrentMonthString {
            get {
                return CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[
CurrentMonth.Month-1]; 
            }
            private set { }
        }
        public string NextMonthString {
            get { return CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[CurrentMonth.AddMonths(1).Month - 1]; }
            private set { }
        }
        public string NextMonth2String
        {
            get { return CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[CurrentMonth.AddMonths(2).Month - 1]; }
            private set { }
        }
        public string PrevMonthString
        {
            get { return CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[CurrentMonth.AddMonths(-1).Month - 1]; }
            private set { }
        }
        public string PrevMonth2String
        {
            get { return CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[CurrentMonth.AddMonths(-2).Month - 1]; }
            private set { }
        }

        public List<EventViewModel> NextMonthItems
        {
            get
            {
                var newitems = (from eventCal in this.UserItems
                                where (eventCal.Date.Month == CurrentMonth.AddMonths(1).Month) && (eventCal.Date.Year == CurrentMonth.AddMonths(1).Year)
                                orderby eventCal.Date descending
                                select eventCal);
                List<EventViewModel> outnews = newitems.ToList();
                return outnews;
            }
            private set { }
        }

        public List<EventViewModel> PrevMonthItems
        {
            get
            {
                var newitems = (from eventCal in this.UserItems
                                where (eventCal.Date.Month == CurrentMonth.AddMonths(-1).Month) && (eventCal.Date.Year == CurrentMonth.AddMonths(-1).Year)
                                orderby eventCal.Date descending
                                select eventCal);
                List<EventViewModel> outnews = newitems.ToList();
                return outnews;
            }
            private set { }
        }

        public event PropertyChangedEventHandler PropertyChanged;
        private void NotifyPropertyChanged(String propertyName)
        {
            PropertyChangedEventHandler handler = PropertyChanged;
            if (null != handler)
            {
                handler(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}
