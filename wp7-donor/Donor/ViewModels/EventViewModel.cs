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

namespace Donor.ViewModels
{
    public class EventViewModel
    {
        public EventViewModel()
        {
            this.Date = DateTime.Now;
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
        public string Type { get; set; }
        public string GiveType { get; set; }
        public string Place { get; set; }

        public string Reminder { get; set; }
        public bool ReminderMessage { get; set; }

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
    }

    public class EventsListViewModel
    {
        public EventsListViewModel()
        {
            Items = new ObservableCollection<EventViewModel>();
        }

        public ObservableCollection<EventViewModel> Items { get; set; }
    }
}
