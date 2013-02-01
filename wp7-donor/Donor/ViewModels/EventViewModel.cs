using System;
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


///
/// PossibleBloodGive - событие можно сдать
/// empty - пустое событие - для заполнение календаря-списка
/// 0 - анализ
/// 1 - кроводача
/// 2 - донорская суббота
/// Праздник - праздничный день
///

/// "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" 

namespace Donor.ViewModels
{

    public struct DateTimeWithZone
    {
        private readonly DateTime utcDateTime;
        private readonly TimeZoneInfo timeZone;

        public DateTimeWithZone(DateTime dateTime, TimeZoneInfo timeZone)
        {
            utcDateTime = TimeZoneInfo.ConvertTime(dateTime, timeZone); //ConvertTimeToUtc(dateTime, timeZone);
            this.timeZone = timeZone;
        }

        public DateTime UniversalTime
        {
            get
            {
                return utcDateTime;
            }
        }

        public TimeZoneInfo TimeZone
        {
            get
            {
                return timeZone;
            }
        }

        public DateTime LocalTime
        {
            get
            {
                return TimeZoneInfo.ConvertTime(utcDateTime, timeZone);
            }
        }
    }


    public class EventViewModel : INotifyPropertyChanged
    {
        public EventViewModel()
        {
            this.Date = DateTime.Now;

            this.UserId = App.ViewModel.User.objectId;
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

        /// <summary>
        /// Идентификатор события, после загрузки на parse соответствует objectId
        /// </summary>
        public string Id { get; set; }

        private string _title;
        /// <summary>
        /// Заголовок события
        /// </summary>
        public string Title { 
            get {
                string outTitle = "";
                switch (this.Type.ToString()) {
                    case "1":
                        if (this.Finished == true)
                        {
                            outTitle = Donor.AppResources.YouGiveBlood + this.GiveType;
                        }
                        else
                        {
                            outTitle = Donor.AppResources.PlanedBloodGive + this.GiveType;
                        };                        
                        break;                        
                    case "0":
                        outTitle = Donor.AppResources.Analisis;
                        break;
                    case "PossibleBloodGive":
                        outTitle = Donor.AppResources.PossibleBloodGive + this.GiveType;
                        break;
                    default: outTitle = _title; break;
                };
                return outTitle;
            }
            set
            {
                _title = value; 
            }
        }

        /// <summary>
        /// Комментарий к событию
        /// </summary>
        public string Description { get; set; }

        private string _notice = "0";
        // Тип уведомнения (0 – 3 мин, 1 – 5 мин, 2 – 10 мин, 3 – 15 мин)
        public string Notice
        {
            get
            {
                //"15 минут", "1 час", "1 день", "2 дня", "1 неделя"
                switch (this.ReminderDate)
                {
                    case "15 минут": _notice = "3"; break;
                    case "1 час": _notice = "4"; break;
                    case "1 день": _notice = "5"; break;
                    case "2 дня": _notice = "6"; break;
                    case "1 неделя": _notice = "7"; break;
                    default: _notice = "0"; break;
                };
                return _notice;
            }
            set
            {
                _notice = value;

                switch (_notice)
                {
                    case "3": this.ReminderDate = Donor.AppResources.Reminder15Minutes; break;
                    case "4": this.ReminderDate = Donor.AppResources.Reminder1Hour; break;
                    case "5": this.ReminderDate = Donor.AppResources.Reminder1Day; break;
                    case "6": this.ReminderDate = Donor.AppResources.Reminder2Days; break;
                    case "7": this.ReminderDate = Donor.AppResources.Reminder1Week; break;
                    default: break;
                };
            }
        }

        // AnalysisResult – Нужно ли узнать результат
        public bool AnalysisResult
        {
            get;
            set;
        }
        


        private DateTime _date;
        /// <summary>
        /// Дата провередия события
        /// </summary>
        public DateTime Date
        {
            get
            {
                return _date;
            }
            set
            {
                _date = value;
                NotifyPropertyChanged("Date");
                NotifyPropertyChanged("DateAndTime");
                NotifyPropertyChanged("ShortDate");
            }
        }

        public DateTime DateAndTime
        {
            get
            {
                return TimeZoneInfo.ConvertTime(new DateTime(_date.Year, _date.Month, _date.Day, _time.Hour, _time.Minute, 0), TimeZoneInfo.Utc);
                    //TimeZoneInfo.ConvertTime(new DateTime(_date.Year, _date.Month, _date.Day, _time.Hour, _time.Minute, 0), TimeZoneInfo.Local);
            }
            set {
                DateTime getdate = value.AddHours(TimeZoneInfo.Local.BaseUtcOffset.TotalHours);
                //TimeZoneInfo.ConvertTime(new DateTime(value.Year, value.Month, value.Day, value.Hour, value.Minute, 0), TimeZoneInfo.Local);
                _date = new DateTime(getdate.Year, getdate.Month, getdate.Day);
                _time = getdate;
            }
        }

        /// <summary>
        /// Строка с короткой записью даты проведения события
        /// </summary>
        public string ShortDate
        {
            get
            {
                if (this.Type == Donor.AppResources.EmptyType)
                {
                    return " ";
                }
                else
                {
                    return _date.ToShortDateString();
                };
            }
            private set { }
        }

        /// <summary>
        /// День проведения события (номер дня в месяце)
        /// </summary>
        public string Day
        {
            get
            {
                if (this.Type == Donor.AppResources.EmptyType)
                {
                    return " ";
                }
                else
                {
                    return _date.Day.ToString();
                };
            }
            private set { }
        }

        /// <summary>
        /// Путь
        /// </summary>
        public string Image { get; set; }

        /// <summary>
        /// Type variants
        /// Тип события (0 – Анализ, 1 – Сдача крови)
        /// </summary>
        public string Type { get; set; }

        /// <summary>
        /// Тип кроводачи (тромбоциты, плазма, цельная кровь, гранулоциты
        /// </summary>
        public string GiveType { get; set; }
        public string Place { get; set; }

        public string ReminderDate { get; set; }

        private bool _reminderMessage = true;
        public bool ReminderMessage
        {
            get
            {
                return _reminderMessage;
            }
            set {
                _reminderMessage = value; 
            }
        }

        private bool _finished = false;
        /// <summary>
        /// Является  ли событие выполеннным? true - выполнено, false - еще не выполнено (не отмечено как выполненное)
        /// </summary>
        public bool Finished
        {
            get
            {
                return _finished;
            }
            set
            {
                _finished = value;
                NotifyPropertyChanged("Finished");
                NotifyPropertyChanged("FinishedString");
            }
        }

        /// <summary>
        /// Строка, содержащая описание выполнения события
        /// </summary>
        public string FinishedString
        {
            get
            {
                if (_finished)
                {
                    return Donor.AppResources.Finished;
                }
                else
                {
                    return Donor.AppResources.DontFinished;
                };
            }
            private set
            {
            }
        }

        /// <summary>
        /// Путь к "большому" изображению события
        /// </summary>
        public string BigImage
        {
            private set
            {
            }
            get
            {
                if (this.Type == "0")
                    return "/icons/Icon_analis_plan.png";
                if (this.Type == "1")
                {
                    if (this.Finished == false)
                    {
                        switch (this.GiveType)
                        {
                            case "Цельная кровь": return "/icons/Icon_blood_plan.png";
                            case "Тромбоциты": return "/icons/Icon_tromb_plan.png";
                            case "Плазма": return "/icons/Icon_plazm_plan.png";
                            case "Гранулоциты": return "/icons/Icon_gran_plan.png";
                            default: return "/icons/Icon_blood_plan.png";
                        };
                    }
                    else
                    {
                        switch (this.GiveType)
                        {
                            case "Цельная кровь": return "/icons/Icon_blood_check.png";
                            case "Тромбоциты": return "/icons/Icon_tromb_check.png";
                            case "Плазма": return "/icons/Icon_plazm_check.png";
                            case "Гранулоциты": return "/icons/Icon_gran_check.png";
                            default: return "/icons/Icon_blood_check.png";
                        };
                    };
                };
                if (this.Type == "PossibleBloodGive")
                {
                    switch (this.GiveType)
                    {
                        case "Цельная кровь": return "/icons/Icon_blood.png";
                        case "Тромбоциты": return "/icons/Icon_tromb.png";
                        case "Плазма": return "/icons/Icon_plazm.png";
                        case "Гранулоциты": return "/icons/Icon_gran.png";
                        default: return "/icons/Icon_blood.png";
                    };
                };
                if (this.Type == "2")
                    return "/icons/ic_donors_act.png";
                return "";
            }
        }

        /// <summary>
        /// Путь к "маленькому" изображению события
        /// </summary>
        public string SmallImage
        {
            private set
            {
            }
            get
            {
                if (this.Type == "0")
                    return "/icons/ic_calendar_planned_analysis.png";
                if (this.Type == "1")
                {
                    if (this.Finished == false)
                    {
                        switch (this.GiveType)
                        {
                            case "Цельная кровь": return "/icons/Icon_blood_plan.png";
                            case "Тромбоциты": return "/icons/Icon_tromb_plan.png";
                            case "Плазма": return "/icons/Icon_plazm_plan.png";
                            case "Гранулоциты": return "/icons/Icon_gran_plan.png";
                            default: return "/icons/Icon_blood_plan.png";
                        };
                    }
                    else
                    {
                        switch (this.GiveType)
                        {
                            case "Цельная кровь": return "/icons/Icon_blood_check.png";
                            case "Тромбоциты": return "/icons/Icon_tromb_check.png";
                            case "Плазма": return "/icons/Icon_plazm_check.png";
                            case "Гранулоциты": return "/icons/Icon_gran_check.png";
                            default: return "/icons/Icon_blood_check.png";
                        };
                    };
                };
                if (this.Type == "PossibleBloodGive")
                {
                    switch (this.GiveType)
                    {
                        case "Цельная кровь": return "/icons/Icon_blood_small.png";
                        case "Тромбоциты": return "/icons/Icon_tromb_small.png";
                        case "Плазма": return "/icons/Icon_plazm_small.png";
                        case "Гранулоциты": return "/icons/Icon_gran_small.png";
                        default: return "/icons/Icon_blood.png";
                    };
                };
                if (this.Type == "2")
                    return "/icons/ic_donors_act.png";
                return "";
            }
        }
        public bool ParseExists = false;

        private DateTime _time;        
        /// <summary>
        /// Время проведения события
        /// </summary>
        public DateTime Time
        {
            get
            {
                return _time;
            }
            set
            {
                _time = value;
                NotifyPropertyChanged("Time");
                NotifyPropertyChanged("ShortTime");
            }
        }

        /// <summary>
        /// Строка с верменем проведения события
        /// </summary>
        public string ShortTime
        {
            get
            {
                return _time.ToShortTimeString();
            }
            private set { }
        }

        /// <summary>
        /// Удаляем все возможные установленные напоминания для события соответственно
        /// </summary>
        public void RemoveReminders()
        {
            try
            {
                List<long> addSecondsList = new List<long>() { 15 * 60, 60 * 60, 24 * 60 * 60, 2 * 24 * 60 * 60, 7 * 24 * 60 * 60, -60 * 60 * 13, -60 * 60 * 17, 60 * 60 * 12, -60 * 60 * 12 };
                foreach (var addSeconds in addSecondsList)
                {
                    try
                    {
                        Reminder objReminder = ScheduledActionService.Find(this.Id + addSeconds.ToString()) as Reminder;
                        if (objReminder != null)
                            ScheduledActionService.Remove(this.Id + addSeconds.ToString());
                    }
                    catch { };
                };
            }
            catch { };
        }

        /// <summary>
        /// Добавляем все напоминания, необходимые для события
        /// </summary>
        public void AddREventReminders() {
            if (this.Type == "0")
            {
                try
                {
                    this.RemoveReminders();
                }
                catch
                {
                };

                switch (this.ReminderDate.ToString())
                {
                    case "15 минут":
                        this.AddReminder(15 * 60);
                        break;
                    case "1 час":
                        this.AddReminder(60 * 60);
                        break;
                    case "1 день":
                        this.AddReminder(24 * 60 * 60);
                        break;
                    case "2 дня":
                        this.AddReminder(2 * 24 * 60 * 60);
                        break;
                    case "1 неделя":
                        this.AddReminder(7 * 24 * 60 * 60);
                        break;
                    default:
                        break;
                };
            }
            else
            {
                if (this.Type == "1")
                {
                    try
                    {
                        this.RemoveReminders();
                    }
                    catch
                    {
                    };

                    //в день в 17:00
                    this.AddReminder(-60 * 60 * 17, Donor.AppResources.DoYouGiveBloodToday);
                    //за день в 12:00
                    this.AddReminder(60 * 60 * 12, Donor.AppResources.YouHaveBloodGiveTomorrow);
                };
            };
        }

        /// <summary>
        /// Добавляем напоминание о событии
        /// </summary>
        /// <param name="addSeconds">
        /// Количество секнд, которое будет вычтено из даты события. Т.е. дата установлена на 00:00, и указав кол-во секунд равное 10*60*60, мы получим напоминание, установленное за 10 часов до дня проведения события. 
        /// Соответственно отрицательное значение необходимо для установки напоминания в "будущем"
        /// </param>
        /// <param name="rtitle">
        /// Строка для установки в поле содержимое напоминание. В случае, если она не указана, то в поле содержимое подставляется тип кроводачи
        /// </param>
        public void AddReminder(long addSeconds = 0, string rtitle = "")
        {
            try
            {
                Reminder objReminder = ScheduledActionService.Find(this.Id + addSeconds.ToString()) as Reminder;
                if (objReminder != null)
                    ScheduledActionService.Remove(this.Id + addSeconds.ToString());
                objReminder = new Reminder(this.Id + addSeconds.ToString());
                DateTime RememberDate = this.Date;
                TimeSpan ts = new TimeSpan(this.Time.Hour, this.Time.Minute, 0);
                RememberDate = RememberDate.Date + ts;
                
                RememberDate = RememberDate.AddSeconds(-addSeconds);
                objReminder.BeginTime = RememberDate;

                if (rtitle == "")
                {
                    objReminder.Title = Donor.AppResources.Donors;
                    objReminder.Content = this.Title;
                }
                else
                {
                    objReminder.Title = Donor.AppResources.Donors;
                    objReminder.Content = rtitle;
                };

                if (this.Type != "PossibleBloodGive")
                {                    
                    objReminder.NavigationUri = new Uri("/MainPage.xaml?eventid=" + this.Id, UriKind.Relative);
                }
                else
                {                    
                    objReminder.NavigationUri = new Uri("/MainPage.xaml?editeventid=" + this.Id, UriKind.Relative);
                };
                
                ScheduledActionService.Add(objReminder);
            }
            catch { };
        }

        /// <summary>
        /// Идентификатор пользователя, который создал событие. Использеутся в связи с возможностью работы с событиями разными пользователями на одном устройстве
        /// </summary>
        public string UserId { get; set; }
        
        /// <summary>
        /// Идентификатор станции, к  которой привязано событие (в случае, если место проведения события было выбрано из списка стандции)
        /// </summary>
        public long Station_nid { get; set; }

        public string Delivery
        {
            get
            {
                /// "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" 
                switch (GiveType)
                {
                    case "Тромбоциты":      return "0";
                    case "Плазма":          return "1";
                    case "Цельная кровь":   return "2";
                    case "Гранулоциты":     return "3";
                    default:                return "0";
                };
            }
            private set
            {
            }
        }
    }



    public class EventsListViewModel : INotifyPropertyChanged
    {
        public EventsListViewModel()
        {
            Items = new ObservableCollection<EventViewModel>();
        }

        public void SaveEventsParse()
        {
        }

        public delegate void EventsChangedEventHandler(object sender, EventArgs e);
        public event EventsChangedEventHandler EventsChanged;
        public virtual void OnEventsChanged(EventArgs e)
        {
            if (EventsChanged != null)
                EventsChanged(this, e);
        }

        private void EventFromJSON(JObject item)
        {
            EventViewModel jsonitem = new EventViewModel();

            jsonitem.Title = "";

            try
            {
                jsonitem.Description = item["comment"].ToString();
            }
            catch
            {
            };

            jsonitem.Id = item["objectId"].ToString();
            try
            {
                jsonitem.Type = item["type"].ToString();
            }
            catch
            {
            };
            try
            {
                jsonitem.DateAndTime = DateTime.Parse(item["date"]["iso"].ToString());
            }
            catch
            {
            };

            try
            {
                jsonitem.Place = item["adress"].ToString();
            }
            catch
            {
            };
            try
            {
                jsonitem.Description = item["comment"].ToString();
            }
            catch
            {
            };
            try
            {
                jsonitem.UserId = App.ViewModel.User.objectId;
            }
            catch
            {
            };
            try
            {
                switch (item["delivery"].ToString())
                {
                    case "0": jsonitem.GiveType = Donor.AppResources.Platelets; break;
                    case "1": jsonitem.GiveType = Donor.AppResources.Plasma; break;
                    case "2": jsonitem.GiveType = Donor.AppResources.WholeBlood; break;
                    case "3": jsonitem.GiveType = Donor.AppResources.Granulocytes; break;
                    default: jsonitem.GiveType = Donor.AppResources.Platelets; break;
                };
            }
            catch
            {
            };

            try
            {
                /*  Также:
                    4 – 1 час
                    5 – 1 день
                    6 – 2 дня
                    7 – 1 неделя */
                switch (item["notice"].ToString())
                {
                    case "3": jsonitem.ReminderDate = Donor.AppResources.Reminder15Minutes; break;
                    case "4": jsonitem.ReminderDate = Donor.AppResources.Reminder1Hour; break;
                    case "5": jsonitem.ReminderDate = Donor.AppResources.Reminder1Day; break;
                    case "6": jsonitem.ReminderDate = Donor.AppResources.Reminder2Days; break;
                    case "7": jsonitem.ReminderDate = Donor.AppResources.Reminder1Week; break;
                    default: break;
                };
            }
            catch
            {
            };

            try
            {
                jsonitem.ReminderMessage = Boolean.Parse(item["analysisResult"].ToString());
            }
            catch
            {
                jsonitem.ReminderMessage = false;
            };

            try
            {
                    switch (jsonitem.Type.ToString())
                    {
                        case "0":
                            jsonitem.Title = Donor.AppResources.Analisis;
                            break;
                        case "1":
                            jsonitem.Title = jsonitem.GiveType.ToString(); //"Кроводача - " + 
                            break;
                    };
            }
            catch
            {
            };

            try
            {
                jsonitem.Finished = Boolean.Parse(item["finished"].ToString());
            }
            catch
            {
                jsonitem.Finished = false;
            };

            try
            {
                jsonitem.AnalysisResult = Boolean.Parse(item["analysisResult"].ToString());
            }
            catch
            {
                jsonitem.AnalysisResult = false;
            };

            try
            {
                jsonitem.Notice = item["notice"].ToString();
            }
            catch
            {
                jsonitem.Notice = "0";
            };

            try
            {
                jsonitem.Station_nid = Int32.Parse(item["station_nid"].ToString());
            }
            catch
            {
            };

            this.Items.Remove(this.Items.FirstOrDefault(c => c.Id == jsonitem.Id));
            this.Items.Add(jsonitem);
        }

        public void LoadEventsParse()
        {
            try
            {
                if ((App.ViewModel.User != null) && (App.ViewModel.User.objectId != ""))
                {
                    var clientuser = new RestClient("https://api.parse.com");
                    var requestuser = new RestRequest("1/classes/Events", Method.GET);

                    requestuser.Parameters.Clear();
                    requestuser.AddParameter("where", "{\"$relatedTo\":{\"object\":{\"__type\":\"Pointer\",\"className\":\"_User\",\"objectId\":\"" + App.ViewModel.User.objectId + "\"},\"key\":\"events\"}}");
                    requestuser.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                    requestuser.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);

                    clientuser.ExecuteAsync(requestuser, responseuser =>
                    {

                            //var bw = new BackgroundWorker();
                            //bw.DoWork += delegate
                            //{
                                try
                                {
                                    ObservableCollection<EventViewModel> eventslist1 = new ObservableCollection<EventViewModel>();
                                    JObject o = JObject.Parse(responseuser.Content.ToString());
                                    foreach (JObject item in o["results"])
                                    {
                                        EventFromJSON(item);
                                    };
                                    App.ViewModel.Events.UpdateItems();
                                    App.ViewModel.OnDataFLoaded(EventArgs.Empty);
                                    App.ViewModel.IsDataLoaded = true;
                                }
                                catch
                                {
                                    App.ViewModel.OnDataFLoaded(EventArgs.Empty);
                                    App.ViewModel.IsDataLoaded = true;
                                };
                            //Deployment.Current.Dispatcher.BeginInvoke(() =>
                            //{
                            //});
                        //};
                        //bw.RunWorkerAsync();

                        this.NotifyPropertyChanged("Items");
                        this.NotifyPropertyChanged("WeekItems");
                    });
                };
            }
            catch { };
        }

        /// <summary>
        /// Есть ли в день, соответствующей переданной дате события (за исключением событий "можно сдать"
        /// </summary>
        /// <param name="date"></param>
        /// <returns></returns>
        public bool ThisDayEvents(DateTime date)
        {
            bool existsEvent = false;
            if (this.UserItems.FirstOrDefault(c => ((c.Date == date) && (c.Type != "PossibleBloodGive") && (c.Type != "Праздник"))) != null)
            {
                existsEvent = true;
            };
            return existsEvent;
        }

        /// <summary>
        /// Получаем дату ближайшей возможной кроводачи данного типа в будущем без учета запланированных в будущем событий 
        /// (на пересечение с возможной кроводачей)
        /// </summary>
        /// <param name="GiveType"> тип кроводачи</param>
        /// <returns></returns>
        public DateTime NearestPossibleGiveBlood(string GiveType = "")
        {
            List<string> TypesGive = new List<string>() { Donor.AppResources.Platelets, 
                Donor.AppResources.Plasma, Donor.AppResources.WholeBlood, Donor.AppResources.Granulocytes };

            var _selected_user_items = (from item in this.Items
                                        where ((item.UserId == App.ViewModel.User.objectId) && (item.Type == "1") && (item.Finished == true))
                                        orderby item.Date descending
                                        select item);

            var previtem = _selected_user_items.FirstOrDefault();
            DateTime Date = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day).AddDays(-1);
            DateTime OutDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day).AddDays(-1);

            foreach (var item in _selected_user_items)
            {
                int days = App.ViewModel.Events.DaysFromEvent(_selected_user_items.FirstOrDefault().GiveType, GiveType);
                previtem = item;
                //if (previtem.Date.AddDays(days) >= DateTime.Today)
                //{
                    if (App.ViewModel.Events.EventsInYear(GiveType, OutDate) && App.ViewModel.Events.EventsInYear(GiveType, OutDate.AddYears(-1)))
                    {
                        OutDate = previtem.Date.AddDays(days);
                        break;
                    }
                    else
                    {
                    };
                //};

            };

            return OutDate;
        }


        public DateTime PossibleGiveBlood(string GiveType = "")
        {

            List<string> TypesGive = new List<string>() { Donor.AppResources.Platelets, 
                Donor.AppResources.Plasma, Donor.AppResources.WholeBlood, Donor.AppResources.Granulocytes };

            var _selected_user_items = (from item in this.Items
                                        where ((item.UserId == App.ViewModel.User.objectId) && (item.Type == "1"))
                                        orderby item.Date ascending
                                        select item);

            var previtem = _selected_user_items.FirstOrDefault();
            DateTime Date = DateTime.Now;
            DateTime OutDate = DateTime.Now;

            if (App.ViewModel.Events.EventsInYear(GiveType, OutDate) && App.ViewModel.Events.EventsInYear(GiveType, OutDate.AddYears(-1)))
            {

            };
            foreach (var item in _selected_user_items)
            {
                int days = App.ViewModel.Events.DaysFromEvent(_selected_user_items.FirstOrDefault().GiveType, GiveType);
                previtem = item;
                if (previtem.Date.AddDays(days) >= DateTime.Now)
                {
                    if (App.ViewModel.Events.EventsInYear(GiveType, OutDate) && App.ViewModel.Events.EventsInYear(GiveType, OutDate.AddYears(-1)))
                    {
                        OutDate = previtem.Date.AddDays(days);
                        break;
                    }
                    else
                    {
                    };
                };
            };

            var _future_items = (from item in this.Items
                                 where (((item.UserId == App.ViewModel.User.objectId) && (item.Type == "1")) && (item.Date >= DateTime.Now))
                                 orderby item.Date ascending
                                 select item);

            foreach (var item in _future_items)
            {
                int daysc1 = App.ViewModel.Events.DaysFromEvent(item.GiveType, GiveType);
                int daysc2 = App.ViewModel.Events.DaysFromEvent(GiveType, item.GiveType);
                if ((OutDate <= item.Date.AddDays(daysc1)) && (OutDate >= item.Date))
                {
                    previtem = item;
                    OutDate = previtem.Date.AddDays(daysc1);
                    break;
                };
                if ((item.Date <= OutDate.AddDays(daysc2)) && (OutDate < item.Date))
                {
                    previtem = item;
                    OutDate = previtem.Date.AddDays(daysc2);
                    break;
                };
            };
            return OutDate;
        }

        /// <summary>
        /// Удаляем события, попадающие в интервал отдыха выполненных событий
        /// </summary>
        private void DeleteUncorrectEvents()
        {
            List<string> TypesGive = new List<string>() { Donor.AppResources.Platelets, 
                Donor.AppResources.Plasma, Donor.AppResources.WholeBlood, Donor.AppResources.Granulocytes };

            var _selected_user_items = (from item in this.Items
                                        where ((item.UserId == App.ViewModel.User.objectId) && (item.Type == "1") && (item.Finished == true))
                                        orderby item.Date ascending
                                        select item);

            // проверяем периодыдля всех выполненных событий
            foreach (var item in _selected_user_items)
            {
                // ищем события в периодах отдыха для разных типов кроводачи
                foreach (var give in TypesGive)
                {
                    int daysc1 = App.ViewModel.Events.DaysFromEvent(item.GiveType, give);
                    // выбираем события, попадающие в период отдыха, не являющиеся выполненными и являющимися соыбтиями типа кроводачи
                    var deleteitems = App.ViewModel.Events.UserItems.Where(c => (c.Date <= item.Date.AddDays(daysc1)) && (c.Date >= item.Date) && (c.Finished == false) && (c.Type == "1") && (c.GiveType == give));
                    foreach (var delitem in deleteitems)
                    {
                        //this.Items.Remove(delitem);
                        DeleteEventWithoutUpdate(delitem);
                    };
                };
            }
        }

        /// <summary>
        /// Подсчет будущих событий в календаре пользователя
        /// </summary>
        /// <returns></returns>
        public int FutureEventsCount()
        {
            int count = 0;
            count = (from item in this.UserItems
                     where (item.Date >= DateTime.Now) && (item.Type == "1") && (item.Type == "0")
                     orderby item.Date ascending
                     select item).Count();
            return count;
        }

        public int DaysBefore()
        {
            List<string> TypesGive = new List<string>() { Donor.AppResources.Platelets, 
                Donor.AppResources.Plasma, Donor.AppResources.WholeBlood, Donor.AppResources.Granulocytes };


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
                    }
                    else
                    {
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
                    if (((yearitems4.Count() > 4) && (App.ViewModel.User.Sex == 0)) || ((yearitems4.Count() > 3) && (App.ViewModel.User.Sex == 1)))
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

            return (days_count);
        }

        public EventViewModel NearestEvents()
        {
            var item_near2 = (from item in this.UserItems
                              where (item.Date >= DateTime.Now) && ((item.Type == "1") || (item.Type == "0"))
                              orderby item.Date ascending
                              select item).Take(1);
            return item_near2.FirstOrDefault();
        }

        /// <summary>
        /// События принадлежащие вошедшему пользователю (из доступных приложению событий на устройстве соответственно)
        /// </summary>
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
                    foreach (var item in _selected_user_items)
                    {
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

        public void DeleteEvent(EventViewModel _currentEvent = null)
        {
            try
            {
                App.ViewModel.Events.Items.Remove(_currentEvent);
                App.ViewModel.Events.RemoveItemFromParse(_currentEvent);
                App.ViewModel.Events.UpdateItems();

                /// Add event to Flurry about vent delete
                List<FlurryWP7SDK.Models.Parameter> articleParams = new List<FlurryWP7SDK.Models.Parameter> { 
                            new FlurryWP7SDK.Models.Parameter("Type", _currentEvent.Type), 
                            new FlurryWP7SDK.Models.Parameter("Delivery", _currentEvent.Delivery), 
                            new FlurryWP7SDK.Models.Parameter("Action", "deleted") 
                        };
                FlurryWP7SDK.Api.LogEvent("Event", articleParams);

            }
            catch
            {
            };
        }


        public void DeleteEventWithoutUpdate(EventViewModel _currentEvent = null)
        {
            try
            {
                App.ViewModel.Events.Items.Remove(_currentEvent);
                App.ViewModel.Events.RemoveItemFromParse(_currentEvent);
            }
            catch
            {
            };
        }


        public void UpdateEventParse(EventViewModel addedItems = null)
        {
            if ((addedItems != null) && ((addedItems.Type == "0") || (addedItems.Type == "1")))
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/classes/Events/" + addedItems.Id.ToString(), Method.PUT);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                string strJSONContent = "{\"analysisResult\":" + addedItems.ReminderMessage.ToString().ToLower() + ", \"notice\": " + addedItems.Notice.ToString() + ", \"station_nid\": " + addedItems.Station_nid + ", \"date\": {\"__type\": \"Date\", \"iso\": \"" + addedItems.DateAndTime.ToString("s") + "\"}, \"finished\":" + addedItems.Finished.ToString().ToLower() + ", \"adress\":\"" + addedItems.Place + "\", \"comment\":\"" + addedItems.Description.Replace("\r", "\n") + "\", \"type\":" + addedItems.Type + ", \"delivery\":" + addedItems.Delivery + ", \"type\":" + addedItems.Type + "}";


                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);
                client.ExecuteAsync(request, response =>
                {
                    JObject o = JObject.Parse(response.Content.ToString());
                    if (o["error"] == null)
                    {
                        List<FlurryWP7SDK.Models.Parameter> articleParams = new List<FlurryWP7SDK.Models.Parameter> { 
                            new FlurryWP7SDK.Models.Parameter("Type", addedItems.Type), 
                            new FlurryWP7SDK.Models.Parameter("Delivery", addedItems.Delivery), 
                            new FlurryWP7SDK.Models.Parameter("Action", "updated") 
                        };
                        FlurryWP7SDK.Api.LogEvent("Event", articleParams);

                        /// Устанавливаем напоминания
                        addedItems.AddREventReminders();

                        NotifyPropertyChanged("Items");
                        NotifyPropertyChanged("UserItems");
                        NotifyPropertyChanged("WeekItems");
                        NotifyPropertyChanged("ThisMonthItems");
                        UpdateNearestEvents();

                        this.DeleteUncorrectEvents();

                        // обновляем Tile приложения
                        App.ViewModel.CreateApplicationTile(App.ViewModel.Events.NearestEvents());

                        App.ViewModel.Events.OnEventsChanged(EventArgs.Empty);

                        App.ViewModel.SaveToIsolatedStorage();
                    }
                    else
                    {

                    };
                });

            };
        }

        public void AddEventParse(EventViewModel addedItems = null)
        {
            this.Items.Add(addedItems);
            if ((addedItems != null) && ((addedItems.Type == "0") || (addedItems.Type == "1")))
            {
                var client = new RestClient("https://api.parse.com");
                var request = new RestRequest("1/classes/Events", Method.POST);
                request.AddHeader("Accept", "application/json");
                request.Parameters.Clear();
                string strJSONContent = "{\"analysisResult\":" + addedItems.ReminderMessage.ToString().ToLower() + ", \"notice\": " + addedItems.Notice.ToString() + ", \"station_nid\": " + addedItems.Station_nid + ", \"date\": {\"__type\": \"Date\", \"iso\": \"" + addedItems.DateAndTime.ToString("s") + "\"}, \"finished\":" + addedItems.Finished.ToString().ToLower() + ", \"adress\":\"" + addedItems.Place + "\", \"comment\":\"" + addedItems.Description.Replace("\r", "\n") + "\", \"type\":" + addedItems.Type + ", \"delivery\":" + addedItems.Delivery + ", \"type\":" + addedItems.Type + "}";


                request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                request.AddHeader("Content-Type", "application/json");

                request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);
                client.ExecuteAsync(request, response =>
                {
                    try
                    {
                        JObject o = JObject.Parse(response.Content.ToString());
                        if (o["error"] == null)
                        {
                            this.Items.Remove(addedItems);
                            addedItems.Id = o["objectId"].ToString();
                            this.Items.Add(addedItems);

                            var clientrel = new RestClient("https://api.parse.com");
                            var requestrel = new RestRequest("1/users/" + App.ViewModel.User.objectId, Method.PUT);
                            request.AddHeader("Accept", "application/json");
                            request.Parameters.Clear();
                            string strJSONContentrel = "{\"events\":{\"__op\":\"AddRelation\",\"objects\":[{\"__type\":\"Pointer\",\"className\":\"Events\",\"objectId\":\"" + addedItems.Id + "\"}]}}";

                            requestrel.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
                            requestrel.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
                            requestrel.AddHeader("X-Parse-Session-Token", App.ViewModel.User.sessionToken);
                            requestrel.AddHeader("Content-Type", "application/json");

                            requestrel.AddParameter("application/json", strJSONContentrel, ParameterType.RequestBody);
                            client.ExecuteAsync(requestrel, responserel =>
                            {
                                JObject orel = JObject.Parse(responserel.Content.ToString());
                            });

                            List<FlurryWP7SDK.Models.Parameter> articleParams = new List<FlurryWP7SDK.Models.Parameter> { 
                            new FlurryWP7SDK.Models.Parameter("Type", addedItems.Type), 
                            new FlurryWP7SDK.Models.Parameter("Delivery", addedItems.Delivery), 
                            new FlurryWP7SDK.Models.Parameter("Action", "created") 
                        };
                            FlurryWP7SDK.Api.LogEvent("Event", articleParams);

                            /// Устанавливаем напоминания после получения идентификатора parse.com
                            addedItems.AddREventReminders();

                            NotifyPropertyChanged("Items");
                            NotifyPropertyChanged("UserItems");
                            NotifyPropertyChanged("WeekItems");
                            NotifyPropertyChanged("ThisMonthItems");
                            UpdateNearestEvents();

                            this.DeleteUncorrectEvents();

                            // обновляем Tile приложения
                            App.ViewModel.CreateApplicationTile(App.ViewModel.Events.NearestEvents());

                            App.ViewModel.Events.OnEventsChanged(EventArgs.Empty);

                            App.ViewModel.SaveToIsolatedStorage();
                        }
                        else
                        {

                        };
                    }
                    catch { };
                });

            };
        }

        /// <summary>
        /// Сохраняем обновлениный список событий, посылаем данные о событии на parse.com
        /// </summary>
        /// <param name="addedItems"></param>
        public void UpdateItems(EventViewModel addedItems = null)
        {
            if (addedItems == null)
            {
                App.ViewModel.CreateApplicationTile(App.ViewModel.Events.NearestEvents());
                App.ViewModel.SaveToIsolatedStorage();

                NotifyPropertyChanged("Items");
                NotifyPropertyChanged("UserItems");
                NotifyPropertyChanged("WeekItems");
                NotifyPropertyChanged("ThisMonthItems");
                UpdateNearestEvents();

                this.DeleteUncorrectEvents();

                App.ViewModel.Events.OnEventsChanged(EventArgs.Empty);
            }
            else
            {
                if (addedItems.ParseExists == true)
                {
                    UpdateEventParse(addedItems);
                }
                else
                {
                    AddEventParse(addedItems);
                };
            };

            App.ViewModel.User.NotifyAll();
        }

        /// <summary>
        /// Добавляем события - возможные кроводачи
        /// </summary>
        public void UpdateNearestEvents()
        {
            var _selected_user_items = (from item in this.Items
                                        where ((item.UserId == App.ViewModel.User.objectId) && (item.Type == "1") && (item.Finished == true))
                                        orderby item.Date ascending
                                        select item);

            List<string> TypesGive = new List<string>() { Donor.AppResources.Platelets, Donor.AppResources.Plasma, Donor.AppResources.WholeBlood }; //, "Гранулоциты" 

            foreach (var item in TypesGive)
            {
                try
                {
                    // удаляем старые напоминания о событиях можно сдать
                    this.Items.FirstOrDefault(c => c.Type == "PossibleBloodGive").RemoveReminders();
                    this.Items.Remove(this.Items.FirstOrDefault(c => c.Type == "PossibleBloodGive"));
                }
                catch
                {
                };
            };

            // не создаем можно сдать если нет выполненных кроводач у данного пользователя
            if (_selected_user_items.Count() > 0)
            {
                try
                {
                    List<EventViewModel> possibleEvents = new List<EventViewModel>();

                    var cnt = 0;
                    // создаем новые события для типов кроводачи можно сдать
                    foreach (var item in TypesGive)
                    {
                        cnt++;
                        DateTime date = NearestPossibleGiveBlood(item);
                        date = date.AddDays(1);
                        var possibleItem = new EventViewModel();
                        possibleItem.Date = date;
                        possibleItem.Time = new DateTime(date.Year, date.Month, date.Day, 8, 0, 0);
                        possibleItem.Type = "PossibleBloodGive";
                        possibleItem.GiveType = item;
                        possibleItem.Title = item + Donor.AppResources.PossibleBloodGiveTitle;
                        possibleItem.Description = "";
                        possibleItem.Place = "";
                        possibleItem.Id = cnt.ToString() + DateTime.Now.Ticks.ToString();
                        possibleItem.UserId = App.ViewModel.User.objectId;
                        possibleItem.ReminderDate = "";
                        possibleItem.ParseExists = false;

                        possibleEvents.Add(possibleItem);
                        this.Items.Add(possibleItem);
                    };

                    try
                    {
                        // добавляем напоминания о "можно сдать" с учетом их возможного присутствия в один и тот же день
                        List<DateTime> dates = new List<DateTime>();
                        foreach (var item in possibleEvents)
                        {
                            if ((dates.FirstOrDefault(c => c.Date == item.Date) == null) || (dates.Count() == 0))
                            {
                                int thisDaysCount = possibleEvents.Count(c => c.Date == item.Date);
                                List<EventViewModel> giveTypes = new List<EventViewModel>();
                                giveTypes = possibleEvents.Where(c => c.Date == item.Date).ToList();

                                // отмечаем, что данная дата уже добавлена в напоминания
                                dates.Add(item.Date);

                                // создаем соответствующее напоминение на 12 часов дня
                                switch (thisDaysCount)
                                {
                                    case 0: break;
                                    case 1: item.AddReminder(-60 * 60 * 12, Donor.AppResources.YouCanPlanBlood + item.GiveType); break;
                                    case 2: item.AddReminder(-60 * 60 * 12, Donor.AppResources.YouCanPlanBlood + giveTypes[0].GiveType + ", " + giveTypes[1].GiveType); break;
                                    case 3: item.AddReminder(-60 * 60 * 12, Donor.AppResources.YouCanPlanBlood + giveTypes[0].GiveType + ", " + giveTypes[1].GiveType + ", " + giveTypes[2].GiveType); break;
                                    case 4: item.AddReminder(-60 * 60 * 12, Donor.AppResources.YouCanPlanBlood2); break;
                                    default: break;
                                };
                            };
                        };
                    }
                    catch
                    {
                    };

                }
                catch
                {
                };
            };
        }

        public EventViewModel EditedEvent { get; set; }

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

                    //UpdateNearestEvents();
                };
            }
        }

        public int BloodGiveCount
        {
            get
            {
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
            private set { }
        }

        public void WeekItemsUpdated()
        {
            this.NotifyPropertyChanged("WeekItems");
        }

        public List<EventViewModel> WeekItems
        {
            get
            {
                var newitems = (from eventCal in this.UserItems
                                where
                                (eventCal.Type != Donor.AppResources.HolidayType)
                                &&
                                (new DateTime(eventCal.Date.Year, eventCal.Date.Month, eventCal.Date.Day) >= DateTime.Today)
                                && (App.ViewModel.User.objectId == eventCal.UserId)
                                orderby eventCal.Date descending
                                select eventCal).Take(20);
                List<EventViewModel> outnews = newitems.ToList();
                return outnews;
            }
            private set { }
        }

        public void GetThisMonthItems()
        {
            var bw = new BackgroundWorker();

            bw.DoWork += delegate
            {
                System.Threading.Thread.Sleep(300);

                var newitems = (from eventCal in this.Items
                                where ((eventCal.UserId == App.ViewModel.User.objectId) || ((eventCal.Type != "0") || (eventCal.Type != "1"))) &&
                                (eventCal.Date.Month == CurrentMonth.Month) && (eventCal.Date.Year == CurrentMonth.Year)
                                orderby eventCal.Date descending
                                select eventCal);
                List<EventViewModel> outnews = newitems.ToList();

                var emptyItem = new EventViewModel();
                emptyItem.Date = CurrentMonth;
                emptyItem.Type = Donor.AppResources.EmptyType;
                emptyItem.Title = "";

                int addi = 14 - newitems.Count();
                if (addi > 0)
                {
                    for (var ii = 0; ii < addi; ii++)
                    {
                        outnews.Add(emptyItem);
                    };
                };
                Deployment.Current.Dispatcher.BeginInvoke(() =>
                    {
                        _thisMonthItems = outnews;
                        NotifyPropertyChanged("ThisMonthItems");
                    });
            };
            bw.RunWorkerAsync();
        }

        private List<EventViewModel> _thisMonthItems;
        public List<EventViewModel> ThisMonthItems
        {
            get
            {
                var newitems = (from eventCal in this.Items
                                where ((eventCal.UserId == App.ViewModel.User.objectId) || ((eventCal.Type != "0") && (eventCal.Type != "1"))) &&
                                (eventCal.Date.Month == CurrentMonth.Month) && (eventCal.Date.Year == CurrentMonth.Year)
                                orderby eventCal.Date descending
                                select eventCal);
                List<EventViewModel> _thisMonthItems = newitems.ToList();

                var emptyItem = new EventViewModel();
                emptyItem.Date = CurrentMonth;
                emptyItem.Type = Donor.AppResources.EmptyType;
                emptyItem.Title = "";

                int addi = 11 - newitems.Count();
                if (addi > 0)
                {
                    for (var ii = 0; ii < addi; ii++)
                    {
                        _thisMonthItems.Add(emptyItem);
                    };
                };
                return _thisMonthItems;
            }
            private set { }
        }

        private List<EventViewModel> _thisMonthItemsWithoutEmpty;
        public List<EventViewModel> ThisMonthItemsWithoutEmpty
        {
            get
            {
                var newitems = (from eventCal in this.Items
                                where ((eventCal.UserId == App.ViewModel.User.objectId) || ((eventCal.Type != "0") && (eventCal.Type != "1"))) &&
                                (eventCal.Date.Month == CurrentMonth.Month) && (eventCal.Date.Year == CurrentMonth.Year)
                                orderby eventCal.Date descending
                                select eventCal);
                List<EventViewModel> _thisMonthItemsWithoutEmpty = newitems.ToList();

                return _thisMonthItemsWithoutEmpty;
            }
            private set { }
        }


        private DateTime _currentMonth = DateTime.Now;
        public DateTime CurrentMonth
        {
            get
            {
                return _currentMonth;
            }
            set
            {
                _currentMonth = value;
                GetThisMonthItems();
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
            get
            {
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

        public string CurrentMonthString
        {
            get
            {
                return CultureInfo.CurrentCulture.DateTimeFormat.MonthNames[
CurrentMonth.Month - 1];
            }
            private set { }
        }

        /// <summary>
        /// Название следующего месяца для календаря
        /// </summary>
        public string NextMonthString
        {
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

        public void RemoveItemFromParse(EventViewModel _currentEvent)
        {
            var client = new RestClient("https://api.parse.com");
            var request = new RestRequest("1/classes/Events/" + _currentEvent.Id, Method.DELETE);
            request.AddHeader("Accept", "application/json");
            request.Parameters.Clear();
            string strJSONContent = "";
            request.AddHeader("X-Parse-Application-Id", MainViewModel.XParseApplicationId);
            request.AddHeader("X-Parse-REST-API-Key", MainViewModel.XParseRESTAPIKey);
            request.AddHeader("Content-Type", "application/json");

            request.AddParameter("application/json", strJSONContent, ParameterType.RequestBody);

            client.ExecuteAsync(request, response =>
            {
                JObject o = JObject.Parse(response.Content.ToString());
                if (o["error"] == null)
                {
                    App.ViewModel.SaveToIsolatedStorage();
                }
                else
                {

                };
            });
        }
    }
}
