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
using GalaSoft.MvvmLight;


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


    public class EventViewModel : ViewModelBase
    {
        public EventViewModel()
        {
            this.Date = DateTime.Now;
            this.UserId = ViewModelLocator.MainStatic.User.objectId;
        }

        /// <summary>
        /// Идентификатор события, после загрузки на parse соответствует objectId
        /// </summary>
        public string Id { get; set; }

        private string _title;
        /// <summary>
        /// Заголовок события
        /// </summary>
        public string Title
        {
            get
            {
                string outTitle = "";
                switch (this.Type.ToString())
                {
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
                RaisePropertyChanged("Title");
            }
        }

        public string _description = "";
        /// <summary>
        /// Комментарий к событию
        /// </summary>
        public string Description
        {
            get
            {
                return _description;
            }
            set
            {
                if (_description != value)
                {
                    _description = value;
                    RaisePropertyChanged("Description");
                };
            }
        }

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
                RaisePropertyChanged("Notice");
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
                RaisePropertyChanged("Date");
                RaisePropertyChanged("DateAndTime");
                RaisePropertyChanged("ShortDate");
            }
        }

        /// <summary>
        /// Дата и время события
        /// </summary>
        public DateTime DateAndTime
        {
            get
            {
                return TimeZoneInfo.ConvertTime(new DateTime(_date.Year, _date.Month, _date.Day, _time.Hour, _time.Minute, 0), TimeZoneInfo.Utc);
            }
            set
            {
                DateTime getdate = value.AddHours(TimeZoneInfo.Local.BaseUtcOffset.TotalHours);
                _date = new DateTime(getdate.Year, getdate.Month, getdate.Day);
                _time = getdate;
                RaisePropertyChanged("DateAndTime");
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

        private string _place = "";
        public string Place
        {
            get
            {
                if (_place == "")
                {
                    return "Не указано";
                }
                else
                {
                    return _place;
                };
            }
            set
            {
                if (_place != value)
                {
                    _place = value;
                    RaisePropertyChanged("Place");
                }
            }
        }

        public string ReminderDate { get; set; }

        private bool _reminderMessage = true;
        public bool ReminderMessage
        {
            get
            {
                return _reminderMessage;
            }
            set
            {
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
                RaisePropertyChanged("Finished");
                RaisePropertyChanged("FinishedString");
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

        /// <summary>
        /// Существует ли событие на parse
        /// </summary>
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
                RaisePropertyChanged("Time");
                RaisePropertyChanged("ShortTime");
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
        public void AddREventReminders()
        {
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
        public string Station_nid { get; set; }

        private string _yastation_objectid = "";
        public string YAStation_objectid
        {
            get
            {
                return _yastation_objectid;
            }
            set
            {
                if (_yastation_objectid != value)
                {
                    _yastation_objectid = value;
                    RaisePropertyChanged("YAStation_objectid");
                };
            }
        }

        public string Delivery
        {
            get
            {
                /// "Тромбоциты", "Плазма", "Цельная кровь", "Гранулоциты" 
                switch (GiveType)
                {
                    case "Тромбоциты": return "0";
                    case "Плазма": return "1";
                    case "Цельная кровь": return "2";
                    case "Гранулоциты": return "3";
                    default: return "0";
                };
            }
            private set
            {
            }
        }
    }
}